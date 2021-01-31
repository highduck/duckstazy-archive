package com.ek.duckstazy.particles
{
	import flash.display.DisplayObjectContainer;
	/**
	 * @author Elias Ku
	 */
	public interface IParticleManager
	{
		function update(dt:Number):void;
				
		function addParticle(target:DisplayObjectContainer, particle:IParticle):void;
		
		function getActiveParticlesCount():int;
		
		function getParticlesPoolLength():int;
		
		function createParticle(style:String):IParticle;
		
		function cleanup():void;
		
		function addStyle(style:IParticleStyle):void;
		
		function setStyleFactory(styleFactory:IParticleStyleFactory):void;
		
		function createStyle(name:String, type:String):IParticleStyle;
		
		function reserveParticles(styleName:String, count:int):void;
		
		function getStyle(name:String):IParticleStyle;
		
		function addStylesFromXML(xml:XML):void;
	}
}
