package ui
{
	import ek.sui.SUIScreen;
	import ek.sui.SUISystem;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class UpgradeMenu extends SUIScreen
	{
		[Embed(source="gfx/incdef.png")]
        private var gfxIncDef:Class;
        
        [Embed(source="gfx/incclick.png")]
        private var gfxIncClick:Class;
        
        [Embed(source="gfx/incdis.png")]
        private var gfxIncDis:Class;
        
        [Embed(source="gfx/decdef.png")]
        private var gfxDecDef:Class;
        
        [Embed(source="gfx/inc_dec_glow.png")]
        private var gfxIncDecGlow:Class;
        
        [Embed(source="gfx/decclick.png")]
        private var gfxDecClick:Class;
        
        [Embed(source="gfx/decdis.png")]
        private var gfxDecDis:Class;
        
        [Embed(source="gfx/label.png")]
        private var gfxLabel:Class;
        
        [Embed(source="gfx/def.png")]
        private var gfxDef:Class;
        
        public var media:UIMedia;
        
        public var text:TextField;
        private var mini:TextField;
        private var imgLabel:BitmapData;
        private var imgDef:BitmapData;
        
        private const priceHP:int = 1234;
        private const priceDef:int = 765;
        private const priceNorm:int = 2009;
        private const priceHell:int = 3456;
        
		private var btnSkip:CircleButton;
		public var btnBuy:CircleButton;
		
		private var btnHPInc:DefaultButton;
		private var btnHPDec:DefaultButton;
		private var hp:int;
		private var hpText:BitmapData;
		private var hpRC:Rectangle;
		
		private var btnDefInc:DefaultButton;
		private var btnDefDec:DefaultButton;
		private var def:Number;
		private var defText:BitmapData;
		private var defRC:Rectangle;
		
		private var btnNormInc:DefaultButton;
		private var btnNormDec:DefaultButton;
		private var norm:int;
		private var pills:Array;
		
		private var btnHellInc:DefaultButton;
		private var btnHellDec:DefaultButton;
		private var hell:int;
				
		private var cash:int;
		private var cashText:BitmapData;
		private var cashRC:Rectangle;
		
		private var level:Level;
		private var gui:SUISystem;
		private var state:GameState;
		
		public var pillsMedia:PillsMedia;
		public var gameInfo:GameInfo;
		
		private var incImgs:Array;
		private var decImgs:Array;
		private var imgIncDecGlow:BitmapData;
		
		//private var color:ColorTransform;
		
		private var priceImgs:Array;
		private var helpImgs:Array;
		private var helpLast:int;
		private var helpCounter:Number;
		private var helpNew:int;
		
		private var hpPulse:Number;
		private var hpCounter:Number;

		public function UpgradeMenu(_gui:SUISystem, _level:Level)
		{
			var rc:Rectangle = new Rectangle(6.0, 6.0, 29.0, 29.0);
			var bm:BitmapData;
			
			gui = _gui;
			level = _level;
			state = _level.state;
			pillsMedia = _level.pills.media;
			media = Game.instance.uiMedia;
			
			//color = new ColorTransform();
			hpCounter = 0;
			hpPulse = 0;
			
			imgIncDecGlow = (new gfxIncDecGlow()).bitmapData;
			
			incImgs = [imgIncDecGlow, 
						(new gfxIncDef()).bitmapData, 
						(new gfxIncClick()).bitmapData, 
						(new gfxIncDis()).bitmapData];
						
			decImgs = [imgIncDecGlow,
						(new gfxDecDef()).bitmapData, 
						(new gfxDecClick()).bitmapData, 
						(new gfxDecDis()).bitmapData];
			
			imgLabel = (new gfxLabel()).bitmapData;
			imgDef = (new gfxDef()).bitmapData;
			
			pills = [new PillImage(220.0, 179.0, 0, false, pillsMedia),
					 new PillImage(236.0, 162.0, 1, false, pillsMedia),
					 new PillImage(252.0, 179.0, 2, false, pillsMedia),
					 new PillImage(220.0, 179.0+72.0, 0, true, pillsMedia),
					 new PillImage(236.0, 162.0+72.0, 1, true, pillsMedia),
					 new PillImage(252.0, 179.0+72.0, 2, true, pillsMedia)];
			
			text = media.bigText;
			mini = media.miniText;
				
			text.text = "100"
			hpRC = new Rectangle(0.0, 0.0, int(text.width+1.0), int(text.height+1.0));	
			hpText = new BitmapData(hpRC.width, hpRC.height, true, 0x0);
			
			text.text = "75%"
			defRC = new Rectangle(0.0, 0.0, int(text.width+1.0), int(text.height+1.0));	
			defText = new BitmapData(defRC.width, defRC.height, true, 0x0);
			
			cashRC = new Rectangle(0.0, 0.0, 300.0, 100.0);	
			cashText = new BitmapData(cashRC.width, cashRC.height, true, 0x0);
			
			
			///*** ЦЕНЫ ****////
			priceImgs = new Array();
			
			text.text = priceHP.toString() + ".0 $";	
			bm = new BitmapData(int(text.width+1), int(text.height+1), true, 0x0);
			bm.draw(text);
			priceImgs.push(bm);
			
			text.text = priceDef.toString() + ".0 $";	
			bm = new BitmapData(int(text.width+1), int(text.height+1), true, 0x0);
			bm.draw(text);
			priceImgs.push(bm);
			
			text.text = priceNorm.toString() + ".0 $";	
			bm = new BitmapData(int(text.width+1), int(text.height+1), true, 0x0);
			bm.draw(text);
			priceImgs.push(bm);
			
			text.text = priceHell.toString() + ".0 $";	
			bm = new BitmapData(int(text.width+1), int(text.height+1), true, 0x0);
			bm.draw(text);
			priceImgs.push(bm);
			//////
			
			// ПОдсКАЗКИ
			initHelp();
			
			super();
			
			btnSkip = new CircleButton();
			btnSkip.x = 455.0;
			btnSkip.y = 284.0;
			btnSkip.radius = 55.0;
			btnSkip.callback = level.closeUpgradeMenu;
			btnSkip.img = media.imgCBBack;
			
			btnBuy = new CircleButton();
			btnBuy.x = 455.0;
			btnBuy.y = 110.0;
			btnBuy.radius = 55.0;
			btnBuy.callback = buy;
			btnBuy.img = media.imgCBBuy;
			
			btnHPInc = new DefaultButton();
			btnHPInc.x = 272.0;
			btnHPInc.y = 32.0;
			btnHPInc.imgs = incImgs;
			btnHPInc.rc = rc;
			btnHPInc.callback = incHP;
			
			btnHPDec = new DefaultButton();
			btnHPDec.x = 160.0;
			btnHPDec.y = 32.0;
			btnHPDec.imgs = decImgs;
			btnHPDec.rc = rc;
			btnHPDec.callback = decHP;
			
			btnDefInc = new DefaultButton();
			btnDefInc.x = 272.0;
			btnDefInc.y = 104.0;
			btnDefInc.imgs = incImgs;
			btnDefInc.rc = rc;
			btnDefInc.callback = incDef;
			
			btnDefDec = new DefaultButton();
			btnDefDec.x = 160.0;
			btnDefDec.y = 104.0;
			btnDefDec.imgs = decImgs;
			btnDefDec.rc = rc;
			btnDefDec.callback = decDef;
			
			btnNormInc = new DefaultButton();
			btnNormDec = new DefaultButton();
			btnNormInc.imgs = incImgs;
			btnNormDec.imgs = decImgs;
			btnNormInc.rc = btnNormDec.rc = rc;
			btnNormInc.y = btnNormDec.y = 176.0;
			btnNormInc.x = 272.0;
			btnNormDec.x = 160.0;
			btnNormInc.callback = incNorm;
			btnNormDec.callback = decNorm;
			
			btnHellInc = new DefaultButton();
			btnHellDec = new DefaultButton();
			btnHellInc.imgs = incImgs;
			btnHellDec.imgs = decImgs;
			btnHellInc.rc = btnHellDec.rc = rc;
			btnHellInc.y = btnHellDec.y = 248.0;
			btnHellInc.x = 272.0;
			btnHellDec.x = 160.0;
			btnHellInc.callback = incHell;
			btnHellDec.callback = decHell;		
			
			add(btnSkip);
			add(btnBuy);
			
			add(btnHPInc);
			add(btnHPDec);
			
			add(btnDefInc);
			add(btnDefDec);
			
			add(btnNormInc);
			add(btnNormDec);
			
			add(btnHellInc);
			add(btnHellDec);
			
			
		}
		
		private function initHelp():void
		{
			var bm:BitmapData;
			var shape:Shape = new Shape();
			var gr:Graphics = shape.graphics;
			var mat:Matrix = new Matrix(1,0,0,1,5,2.5);
			
			helpImgs = new Array();
			
			mini.text = "HEALTH:\nTHE LEVEL OF YOUR HEALTH.\n("+priceHP.toString() +" MONEY FOR 5 HIT POINTS)";	
			bm = new BitmapData(int(mini.width+1+10), int(mini.height+1+10), true, 0x0);
			gr.clear();
			gr.lineStyle(1, 0xffffff, 1, true);
			gr.beginFill(0x000000, 0.8);
			gr.drawRoundRect(0, 0, mini.width+10, mini.height+4, 20);
			gr.endFill();  
			bm.draw(shape);
			bm.draw(mini, mat);
			helpImgs.push(bm);
			
			mini.text = "ARMOR:\nREDUCES THE NEGATIVE DAMAGE.\n("+priceDef.toString() +" MONEY FOR 5 ARMOR POINTS)";	
			bm = new BitmapData(int(mini.width+1+10), int(mini.height+1+10), true, 0x0);
			gr.clear();
			gr.lineStyle(1, 0xffffff, 1, true);
			gr.beginFill(0x000000, 0.8);
			gr.drawRoundRect(0, 0, mini.width+10, mini.height+4, 20);
			gr.endFill();  
			bm.draw(shape);
			bm.draw(mini, mat);
			helpImgs.push(bm);
			
			mini.text = "NORMAL POWER-UPS:\nPROVIDE A SPECIFIED NUMBER OF POINTS.\n(EACH UPGRADE COSTS "+priceNorm.toString() +" MONEY)";	
			bm = new BitmapData(int(mini.width+1+10), int(mini.height+1+10), true, 0x0);
			gr.clear();
			gr.lineStyle(1, 0xffffff, 1, true);
			gr.beginFill(0x000000, 0.8);
			gr.drawRoundRect(0, 0, mini.width+10, mini.height+4, 20);
			gr.endFill();  
			bm.draw(shape);
			bm.draw(mini, mat);
			helpImgs.push(bm);
			
			mini.text = "TRIP POWER-UPS:\nEACH OF THEM GIVES THE SPECIFIED NUMBER OF POINTS.\n(EACH UPGRADE COSTS "+priceHell.toString() +" MONEY)";			bm = new BitmapData(int(mini.width+1+10), int(mini.height+1+10), true, 0x0);
			gr.clear();
			gr.lineStyle(1, 0xffffff, 1, true);
			gr.beginFill(0x000000, 0.8);
			gr.drawRoundRect(0, 0, mini.width+10, mini.height+4, 20);
			gr.endFill();  
			bm.draw(shape);
			bm.draw(mini, mat);
			helpImgs.push(bm);
			
			helpLast = -1;
			helpCounter = 0;
			helpNew = -1;
		}
		
		public function go():Boolean
		{
			var ret:Boolean = true;/*( state.def<75 || 
								state.maxHP<100 || 
								state.hell<2 || state.norm<3 );
								
			ret = ret && state.scores>0;*/
			
			if(ret)
			{
				gui.setCurrent(this);
				
				/*if(level.env.day)
					color.redMultiplier = color.greenMultiplier = color.blueMultiplier = 0.0;
				else
					color.redMultiplier = color.greenMultiplier = color.blueMultiplier = 1.0;*/
					
				hp = state.maxHP;
				def = state.def;
				norm = state.norm;
				hell = state.hell;
				cash = 0;
				refresh();
			}
				
			return ret;
		}
		
		override public function mouseMove(x:Number, y:Number):void
		{
			super.mouseMove(x, y);
			
		    var o:*;
			
			for each(o in pills)
				PillImage(o).updateSpy(x, y);
			
			helpNew = -1;
			
			if(x>=166 && x<=166+141)
			{
				if(y>=10 && y<=75)
					helpNew = 0;
				else if(y>=78 && y<=78+68)
					helpNew = 1;
				else if(y>=151 && y<=151+67)
					helpNew = 2;
				else if(y>=223 && y<=223+67)
					helpNew = 3;
			}
		}
		
		override public function update(dt:Number):void
		{
			var t:Number = 15*dt;
			var power:Number = level.power;
			var o:*;
			
			super.update(dt);
			
			for each(o in pills)
				PillImage(o).update(dt);
			
			if(helpLast<0 && helpCounter<=0.0)
				helpLast = helpNew;
			
			if(helpLast>=0)
			{
				if(helpLast==helpNew)
				{
					if(helpCounter<1.0)
					{
						helpCounter+=t;
						if(helpCounter>=1.0)
							helpCounter = 1.0;
					}
				}
				else
				{
					helpCounter-=t;
					if(helpCounter<=0.0)
					{
						helpCounter = 0;
						helpLast = helpNew;
					}
				}
			}
			
			if(hpPulse>0.0) { hpPulse-=4.0*dt; if(hpPulse<0.0) hpPulse = 0.0; }
			hpCounter+=4.0*dt;
			if(power<0.33) {
				if(hpCounter>4.0) { hpCounter-=4.0; hpPulse = 1.0; }
			}
			else if(power<0.66) {
				if(hpCounter>2.0) { hpCounter-=2.0; hpPulse = 1.0; }
			}
			else {
				if(hpCounter>1.0) {	hpCounter-=1.0; hpPulse = 1.0; }
			}
		}
	
		override public function draw(canvas:BitmapData):void
		{
			var mat:Matrix = new Matrix(1.0, 0.0, 0.0, 1.0, -25.0, -23.0);
			var col:ColorTransform = new ColorTransform();
			var rc:Rectangle = new Rectangle();
			var p:Point = new Point();
			var sc:Number = 1.0 + 0.3*hpPulse;
			var bm:BitmapData;
			var bm2:BitmapData;
			var bm3:BitmapData;
			var i:int;
			var o:*;
			
			mat.scale(sc, sc);
			mat.translate(237.0, 32.0);
			canvas.draw(level.imgHP1, mat, null, null, null, true);
			canvas.draw(level.imgHP3, mat, null, null, null, true);
			
			//mat.identity();
			p.x = 237.0-27.0;
			p.y = 104.0-33.0;
			rc.width = imgDef.width;
			rc.height = imgDef.height;
			
			canvas.copyPixels(imgDef, rc, p);
			
			rc.width = imgLabel.width;
			rc.height = imgLabel.height;
			
			p.x = 203.0;
			p.y = 47.0;
			
			canvas.copyPixels(imgLabel, rc, p);
			
			p.y = 119.0;
			canvas.copyPixels(imgLabel, rc, p);
			
			p.y = 191.0;
			canvas.copyPixels(imgLabel, rc, p);
			
			p.y = 263.0;
			canvas.copyPixels(imgLabel, rc, p);
			
			p.x = 218;
			p.y = 44;
			canvas.copyPixels(hpText, hpRC, p);
			
			p.x = 219;
			p.y = 116;
			canvas.copyPixels(defText, defRC, p);
			
			p.y = 10;
			for each(o in priceImgs)
			{
				bm = BitmapData(o);
				rc.width = bm.width;
				rc.height = bm.height;
				p.x = 128 - bm.width;
				canvas.copyPixels(bm, rc, p);
				p.y+=72;
			}
			
			for each(o in pills)
				PillImage(o).draw(canvas);
			
			if(norm==0) bm = gameInfo.one;
			else bm = gameInfo.powers[norm-1];
			
			rc.width = bm.width;
			rc.height = bm.height;
			p.x = 235 - (bm.width>>1);
			p.y = 193;
			canvas.copyPixels(bm, rc, p);
			

			bm = gameInfo.powers[hell];
			bm2 = gameInfo.powers[hell+1];
			bm3 = gameInfo.powers[hell+2];

			
			rc.width = bm2.width;
			rc.height = bm2.height;
			p.x = 235 - (bm2.width>>1);
			p.y = 259;
			canvas.copyPixels(bm2, rc, p);
			
			rc.width = bm.width;
			rc.height = bm.height;
			p.x = 221 - (bm.width>>1);
			p.y = 270;
			canvas.copyPixels(bm, rc, p);
			
			rc.width = bm3.width;
			rc.height = bm3.height;
			p.x = 251 - (bm3.width>>1);
			canvas.copyPixels(bm3, rc, p);
			

			p.x = 90;
			p.y = 295;
			canvas.copyPixels(cashText, cashRC, p);
			
			if(helpLast>=0)
			{
				bm = helpImgs[helpLast];
				
				mat.identity();
				mat.tx = -(bm.width>>1);
				mat.ty = -(bm.height>>1);
				mat.scale(helpCounter, helpCounter);
				mat.translate(320, 440);
				
				col.alphaMultiplier = helpCounter;
				
				canvas.draw(bm, mat, col);
			}
			
			super.draw(canvas);
		}
		
		public function buy():void
		{
			var hplevel:Number = state.health/state.maxHP;
			state.maxHP = hp;
			state.health = hp*hplevel;
			state.def = def;
			state.norm = norm;
			state.hell = hell;
			state.scores -= cash;
			
			level.syncScores();
			level.closeUpgradeMenu();
		}
		
		private function refreshCash():void
		{
			var mat:Matrix = new Matrix();
			//var col:ColorTransform = new ColorTransform(1.0, 0.4, 0);		
			
			cash =  (hp-state.maxHP)*priceHP/5 + 
					(def-state.def)*priceDef/5 +
					(norm-state.norm)*priceNorm +
					(hell-state.hell)*priceHell;
			
			btnBuy.enabled = (cash>0 && cash<=state.scores);
				
			cashText.fillRect(cashRC, 0x00000000);
			
			/*text.text = "YOUR CASH: " + state.scores.toString();
			mat.tx = (cashRC.width-text.width)*0.5;
			cashText.draw(text, mat, color);
		
			text.text = "TOTAL PRICE: " + cash.toString();
			mat.tx = (cashRC.width-text.width)*0.5;
			mat.ty = 26;
			cashText.draw(text, mat, color);
			
			text.text = "CASH LEFT: " + (state.scores - cash).toString();
			mat.tx = (cashRC.width-text.width)*0.5;
			mat.ty = 52;
			cashText.draw(text, mat, color);*/
			
			text.text = "YOUR CASH: ";
			mat.tx = 200 - text.width;
			cashText.draw(text, mat);
			
			text.text = state.scores.toString();
			mat.tx = 200;
			cashText.draw(text, mat);
		
			mat.ty = 26;
			text.text = "TOTAL PRICE: "
			mat.tx = 200 - text.width;
			cashText.draw(text, mat);
			
			text.text = cash.toString();
			mat.tx = 200;
			cashText.draw(text, mat);
			
			mat.ty = 62;
			text.text = "CASH LEFT: ";
			mat.tx = 200 - text.width;
			cashText.draw(text, mat);
			
			text.text = (state.scores - cash).toString();
			mat.tx = 200;
			cashText.draw(text, mat);
		}
		
		private function refresh():void
		{
			var mat:Matrix = new Matrix();
			
			refreshCash();
			
			text.text = hp.toString();
			mat.tx = (hpRC.width-text.width)*0.5;
			hpText.fillRect(hpRC, 0x00000000);
			hpText.draw(text, mat);
			
			text.text = def.toString()+"%";
			mat.tx = (defRC.width-text.width)*0.5;
			defText.fillRect(defRC, 0x00000000);
			defText.draw(text, mat);
				
			btnHPDec.enabled = (hp!=state.maxHP);
			btnHPInc.enabled = (hp<100 && (state.scores - cash) >= priceHP);
			btnDefDec.enabled = (def>state.def);
			btnDefInc.enabled = (def<75 && (state.scores - cash) >= priceDef);
			btnNormDec.enabled = (norm!=state.norm);
			btnNormInc.enabled = (norm<=hell && (state.scores - cash) >= priceNorm);
			btnHellDec.enabled = (hell!=state.hell && norm<=hell);
			btnHellInc.enabled = (hell<3 && (state.scores - cash) >= priceHell);
		}
		
		public function incHP():void
		{
			hp+=5;
			refresh();
		}
		
		public function decHP():void
		{
			hp-=5;
			refresh();
		}
		
		public function incDef():void
		{
			def+=5;
			refresh();
		}
		
		public function decDef():void
		{
			def-=5;
			refresh();
		}
		
		public function incNorm():void
		{
			norm++;
			refresh();
		}
		
		public function decNorm():void
		{
			norm--;
			refresh();
		}
		
		public function incHell():void
		{
			hell++;
			refresh();
		}
		
		public function decHell():void
		{
			hell--;
			refresh();
		}

		
	}
}
