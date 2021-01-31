package ek
{
	import flash.display.MovieClip;
	
	import mochi.MochiAd;
	
	public dynamic class ekMochiAd extends MovieClip
	{
		public const OPTIONS:Object = new Object();
		public const CLIP:MovieClip = new MovieClip();
		
		public var completed:Boolean;
		public var progress:Number;
		
		public function ekMochiAd()
		{
			completed = false;
			progress = 0;
			
			this.addChild(CLIP);
			
			OPTIONS["clip"] = CLIP;
			OPTIONS["ad_start"] = adStart;
			OPTIONS["ad_finished"] = adComplete;
			OPTIONS["ad_progress"] = adProgress;
			OPTIONS["no_progress_bar"] = true;
			OPTIONS["no_bg"] = true;
		}
		
		public function show():void
		{
			MochiAd.showPreloaderAd(OPTIONS);
		}
		
		public function adStart():void { }
		
		public function adProgress(perc:Number):void {
			progress = perc*0.01; }
		
        public function adComplete():void
        {
        	completed = true;
        	this.removeChild(CLIP);
        }

	}
}