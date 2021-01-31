package com.ek.duckstazy.edit
{
	import com.ek.library.core.CoreManager;
	import com.ek.library.debug.Logger;

	import flash.utils.describeType;
	/**
	 * @author eliasku
	 */
	public class EditableProperty
	{
		public var name:String = null;
		public var type:String = null;		
		public var params:Object = null;
		public var hasReadAccess:Boolean = true;
		
		
		public static function parse(cls:Class):Vector.<EditableProperty>
		{
			// describeType() the class
			var xml:XML = describeType(cls);
			
			// create our vector to hold the things we can change
			var v:Vector.<EditableProperty> = new Vector.<EditableProperty>;
			
			// look for public variables, then accessors
			_explore( xml, v, "variable" );
			_explore( xml, v, "accessor" );
			
			// sort the vector by alphabetical order
			//v.sort( _sort );
			
			// return the vector
			return v;
		}
		
		/*********************************************************************************/
		
		// Explores an XML object to pull out all the editable vars. The node parameter
		// determines what we're looking at; variables or accessors
		private static function _explore(xml:XML, vector:Vector.<EditableProperty>, node:String):void
		{
			for each(var node:XML in xml.factory[node])
				_exploreNode( xml, node, vector);
		}
		
		// Explores a particular node in an XML for editable vars
		private static function _exploreNode( xml:XML, node:XML, vector:Vector.<EditableProperty> ):void
		{	
			// if we already have this variable in the vector, ignore it. this can happen
			// if we add [Editable] metadata for parameters that we don't have in the class,
			// (e.g. if we extend Sprite and we can to edit the x, or y), as to do this, I
			// edit the XML but I can't guarantee if we've already treated the node or not
			for each( var prop:EditableProperty in vector )
				if ( prop.name == node.@name )
					return;
					
			// loop through the meta data
			for each ( var meta:XML in node.metadata )
			{
				// if the meta data isn't [Editable], do nothing
				if ( meta.@name != "Editable" )
					continue;
					
				// if the metadata has a "field" parameter, then it's a tag that's
				// been added for a variable that we don't have in this class (e.g.
				// if you extend Sprite, and you want to add the x, or y variables)
				// so we look for it in the variables and accessors of the class, and
				// modify it's XML node to include the meta data (minus the "field"
				// declaration)
				if ( meta.arg.(@key == "field") != undefined )
				{
					// hold the node name
					var nodeName:String = meta.arg.(@key == "field").@value;
					var i:int			= 0;
					var metaArg:XML		= null;
					
					// look for it in the variables
					if ( xml.factory.variable.(@name == nodeName) != undefined )
					{
						// remove the "field" meta argument, otherwise we'll go into
						// an infinite loop
						i = 0;
						for each( metaArg in meta.arg )
						{
							if ( metaArg.@key == "field" )
								break;
							i++;
						}
						delete meta.children()[i]; // remove the arg node
						
						// append the meta data to the node, then explore it
						xml.factory.variable.(@name == nodeName).appendChild( meta );
						_exploreNode( xml, XML( xml.factory.variable.(@name == nodeName) ), vector );
					}
					// look for it in the accessors
					else if ( xml.factory.accessor.(@name == nodeName) != undefined )
					{
						// remove the "field" meeta argument, otherwise we'll go into
						// an infinite loop
						i = 0;
						for each( metaArg in meta.arg )
						{
							if ( metaArg.@key == "field" )
								break;
							i++;
						}
						delete meta.children()[i]; // remove the arg node
						
						// append the meta data to the node, then explore it
						xml.factory.accessor.(@name == nodeName).appendChild( meta );
						_exploreNode( xml, XML( xml.factory.accessor.(@name == nodeName) ), vector );
					}
					else
						Logger.warning( "Couldn't add field '" + nodeName + "' as Editable as we couldn't find it" );
						
					// the added variable will be explored at this point, so just continue
					continue;
				}
					
				// create our editable var obj
				var editVar:EditableProperty = new EditableProperty();
				
				// if this is an accessor and it's readonly, then change the type to "watch"
				// as we can only get the data, not set it
				if ( node.@access != undefined && node.@access == "readonly" )
				{
					// if it has an arg type in it's meta data, then change it,
					// otherwise add a new arg node
					if ( meta.arg.(@key == "type") != undefined )
						meta.arg.(@key == "type").@value = EditableType.WATCH;
					else
						meta.appendChild( new XML( <arg key="type" value={EditableType.WATCH} /> ) );
				}
				// if this is an accessor and it's writeonly, then set the bool on our EditableVar obj
				else if ( node.@access != undefined && node.@access != "readwrite" )
					editVar.hasReadAccess = false; // we don't have read access to this var
				
				// set the name of the variable
				editVar.name = node.@name;
				
				// if it has a "type", use it
				if ( meta.arg.(@key == "type") != undefined )
				{
					// set the type
					editVar.type = ( meta.arg.(@key == "type").@value );
					
					// make sure it's good
					if ( !EditableType.isValid( editVar.type ) )
					{
						editVar.type = _getDefaultType( node.@type );
						//this.m_editor.log( "The type set for '" + varXML.@name + "' was wrong, changing it to " + editVar.type, 2 );
					}
				}
				else
					// there was no "type" set, just take the default
					editVar.type = _getDefaultType( node.@type );
					
				// set the default arguments for the type
				editVar.params = _getDefaultParams( editVar.type );
					
				// get the other arguments (component configuration)
				for each( var argsXML:XML in meta.arg )
				{
					// ignore the "type" arg
					if ( argsXML.@key == "type" )
						continue;
						
					// see if the arg set is acceptable for the type of component that we're going to use
					if ( !_isGoodArg( argsXML.@key, editVar.type ) )
					{
						Logger.warning( "Ignoring argument '" + argsXML.@key + "' on '" + node.@name + "' as it's not used for this type: " + editVar.type );
						continue;
					}
					
					// get our sanitised value (i.e. convert from a String)
					var val:* = _convertArgValue( argsXML.@key, argsXML.@value );
					if ( val == null )
					{
						Logger.warning( "Couldn't convert the value '" + argsXML.@value + "' for argument '" + argsXML.@key + "' on '" + node.@name + "'" );
						continue;
					}
					
					// if we don't have an obj, create one, then store our val
					if ( editVar.params == null )
						editVar.params = new Object();
						
					// if it's a static const type, get the constants
					if ( editVar.type == EditableType.ENUM )
						editVar.params[argsXML.@key] = _getConstants( val, node.@type );
					else
						// otherwise, just set the value
						editVar.params[argsXML.@key] = val;
				}
				
				// add our edit var to the vector
				vector.push( editVar );
			}
		}
		
		// Returns the default EditableType component that we're going to use depending
		// on what type the variable is
		private static function _getDefaultType( varType:String ):String
		{
			// Strings use the input component
			if ( varType == "String" )
				return EditableType.INPUT;
				
			// Booleans use a checkbox
			if ( varType == "Boolean" )
				return EditableType.CHECKBOX;
				
			// int, uint and number all revert to TYPE_STEPPER
			if( varType == "int" || varType == "uint" || varType == "Number" )
				return EditableType.STEPPER;
				
			// just a non-editable watch type
			return EditableType.WATCH;
		}
		
		// Returns the default params for the edit component depending on what
		// type component we're using
		private static function _getDefaultParams( type:String ):Object
		{
			// if it's an input type, then the default max number of chars allowed is infinite
			if ( type == EditableType.INPUT )
				return { maxChars:0 };
			// else if it's a slider or a stepper, we set a min and max between 0-100, with a step of 1
			else if ( type == EditableType.SLIDER || type == EditableType.STEPPER )
				return { min:0, max:100, step:1 };
			// none of the other component have default params
			else
				return null;
		}
		
		// makes sure that any arguments coming from the user code are valid
		private static function _isGoodArg( arg:String, type:String ):Boolean
		{
			// for input types, the only thing we accept is the "maxChars" arg
			if ( type == EditableType.INPUT )
				return ( arg == "max_chars" );
				
			// if it's a static const type, the only thing we accept is the "clazz" arg
			if ( type == EditableType.ENUM )
				return ( arg == "cls" );
				
			// if it's a slider, or a stepper, we only accept "min", "max", and "step"
			if ( type == EditableType.SLIDER || type == EditableType.STEPPER )
				return ( arg == "min" || arg == "max" || arg == "step" ); // 'min', 'max' and 'step' are the only ones we accept
				
			return false; // the rest don't take any args
		}
		
		// this takes the value passed with an arg and converts it to the right type from a String
		private static function _convertArgValue(key:String, value:String):*
		{
			// "maxChars" only accepts int type
			if ( key == "max_chars" )
				return int( value );
			// if it's a "clazz", then look in the application domain to see if the class exists
			else if ( key == "cls" )
			{
				var c:Class = null;
				try
				{
					c = CoreManager.stage.loaderInfo.applicationDomain.getDefinition( value ) as Class;
				}
				catch(e:Error) { /* couldn't find the class */ }
				return c; // will be null if we can't find the class
			}
			// the "min", "max", and "step" all convert to Number
			else if ( key == "min" || key == "max" || key == "step" )
				return Number( value );
				
			return null;
		}
		
		// looks at a class and strips out all the static consts in the class that match our
		// type (e.g. "String" or "Number")
		private static function _getConstants( cls:Class, type:String ):Array
		{
			// describeType() the class
			var xml:XML = describeType( cls );
			
			// the array that we're going to return (array as that's what the
			// combobox component takes as a display list)
			var a:Array = new Array;
			
			// go through all the statics and take out the statics that match our type
			for each( var cXML:XML in xml.constant )
			{
				// if the type is the same, the add a new object with the "label" set to
				// the constant variable name + it's value, and the "data" set to the value
				if ( cXML.@type == type )
					a.push( { label:cXML.@name.toString() + " - (" + cls[cXML.@name] + ")", data:cls[cXML.@name] } );
			}
				
			// sort the array
			a.sortOn( "label" );
			
			// return the array
			return a;
		}
		
		// sorts the vector of EditableVars based on the variable alphabetical order
		private static function _sort( a:EditableProperty, b:EditableProperty ):int
		{
			if ( a.name < b.name )
				return -1;
			return 1;
		}
		
	}
}
