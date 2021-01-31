package com.ek.duckstazy
{
	import com.ek.library.core.CoreManager;

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	/**
	 * @author eliasku
	 */
	public class StatService
	{
		private static var _url:String = '';
		private static var _session:String = '';
		
		private static var _sendTime:uint;
		private static var _lastTime:uint;
		private static var _deltaTime:uint;
		private static var _activated:Boolean;
		
		public static function initialize(url:String, session:String):void
		{
			_url = url;
			_session = session;
			_lastTime = _sendTime = getTimer();
			
			CoreManager.stage.addEventListener(Event.DEACTIVATE, onDeactivate);
			CoreManager.stage.addEventListener(Event.ACTIVATE, onActivate);
			setInterval(update, 1000);
		}

		private static function onActivate(e:Event):void
		{
			_activated = true;
		}

		private static function onDeactivate(e:Event):void
		{
			_activated = false;
		}
		
		public static function update():void
		{
			var now:uint = getTimer();
			
			if(_activated)
			{
				_deltaTime += now - _lastTime;
			}
			
			_lastTime = now;
			
			if(now - _sendTime > 10000)
			{
				_sendTime = now;
				send();
			}
		}

		private static function send():void
		{
			var req:URLRequest;
			var loader:URLLoader;
			var time:uint = _deltaTime;
			
			if(time > 0)
			{
				_deltaTime = 0;
				req = new URLRequest(_url + "?stat_ssid=" + _session + "&delta_time=" + time.toString());
				loader = new URLLoader();
				loader.load(req);
			}
		}
		
	}
}
