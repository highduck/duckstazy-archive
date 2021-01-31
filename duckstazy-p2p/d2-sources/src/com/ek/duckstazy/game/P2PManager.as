// header
package com.ek.duckstazy.game
{
	import com.ek.duckstazy.ui.SelectLevelMenu;
	import com.ek.library.debug.Console;
	import com.ek.library.debug.Logger;

	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.getTimer;


	/**
	 * @author eliasku
	 */
	public class P2PManager
	{
		private static const SERVER_ADDRESS:String = "rtmfp://p2p.rtmfp.net/209ac34d41919ad33da13655-777f16b4ea48/";
		private static const DEVELOPER_KEY:String = "209ac34d41919ad33da13655-777f16b4ea48";

		private var _nc:NetConnection;
		private var _myPeerID:String;
		private var _farPeerID:String;
		// streams
		private var _sendStream:NetStream;
		private var _recvStream:NetStream;
		
		//callbacks
		private var _onInitialized:Function;
		
		private var _onPeerConnect:Function;

		public function P2PManager()
		{
		}
		
		public function initialize(onInitialized:Function, onPeerConnect:Function):void
		{
			_onInitialized = onInitialized;
			
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
			_nc.connect(SERVER_ADDRESS+DEVELOPER_KEY);
			
			Console.proxy.addCommand("init-send", "", initSendStream);
			Console.proxy.addCommand("init-recv", "", initRecvStream);
			
			Console.proxy.addCommand("s", "", send);
			
			_onPeerConnect = onPeerConnect;
			
			_mpLast = getTimer();
		}
		
		private function onConnectionStatus(event:NetStatusEvent):void
		{
			Logger.message("onConnectionStatus: " + event.info.code);
			
			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
			
					_myPeerID = _nc.nearID;
			
					Logger.message("Peer ID: " + _nc.nearID);
					
					if(_onInitialized != null)
					{
						_onInitialized();
					}
					
					initSendStream();
					
					break;
					
				case "NetStream.Connect.Success":
					
					if(_onPeerConnect != null)
						_onPeerConnect();
					
					break;
			}
			
			
			
		}
		
		public function initSendStream():void
		{
			Logger.message("initSendStream");
			
			_sendStream = new NetStream(_nc, NetStream.DIRECT_CONNECTIONS);
			_sendStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);
			_sendStream.publish("media");
			
			var sendStreamClient:Object = new Object();
			sendStreamClient.onPeerConnect = function(callerns:NetStream):Boolean
			{
				_farPeerID = callerns.farID;
				Logger.message("onPeerConnect " + _farPeerID);
				
				if(!_recvStream)
				{
					initRecvStream();
				}
				
				return true;
			};
			
			_sendStream.client = sendStreamClient;
		}
		
		public function initRecvStream():void
		{
			_recvStream = new NetStream(_nc, _farPeerID);
			_recvStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);
			_recvStream.play("media");
			
			_recvStream.client = this;
		}
		
		public function r(command:int, data:Object):void
		{
			//Logger.message(command);
			
			
			switch(command)
			{
				case P2PGameCommands.LEVEL_START:
					(Game.menu.getScreen("select_level") as SelectLevelMenu).onHostedStart(data.seed, data.settings);
					break;
				case P2PGameCommands.LEVEL_TICKS:
					if(Game.currentLevel)
					{
						Game.currentLevel.addNetworkedTicks(P2PPackets.uncompressTicks(data as Array));
					}
					break;
				case P2PGameCommands.LEVEL_INPUT1:
					if(Game.currentLevel)
					{
						Game.currentLevel.addNetworkedInput(P2PPackets.uncompressInputPacket(data as Array));
					}
					break;
			}
		}
		
		public function send(command:int, data:Object):void
		{
			switch(command)
			{
				case P2PGameCommands.LEVEL_INPUT1:
					_sendStream.send("r", command, P2PPackets.compressInputPacket(data));
					break;
				case P2PGameCommands.LEVEL_TICKS:
					_sendStream.send("r", command, P2PPackets.compressTicks(data as Array));
					break;
				default:
					_sendStream.send("r", command, data);
					break;
			}
			//Logger.message(''+(_sendStream.info.dataBytesPerSecond) + '  ' + _sendStream.objectEncoding);
		}
		
		private var _mpStart:int;
		private var _mpTime:int;
		private var _mpLast:int;
		
		public function p():void
		{
			_mpTime = getTimer() - _mpStart;
			_mpStart = 0;
			Console.proxy.setInfo(1, "marco/polo: " + _mpTime);
		}
		
		public function m():void
		{
			_sendStream.send("p");
		}
		
		public function update():void
		{
			var time:int;
			
			if((_mpStart == 0 || getTimer()-_mpStart > 3000) && _sendStream && _recvStream)
			{
				time = getTimer();
				if(time - _mpLast >= 1000)
				{
					_mpLast = _mpStart = time;
					_sendStream.send("m");
				}
			}
		}
		
		private function onNetStatusHandler(event:NetStatusEvent):void
		{
			Logger.message("onNetStatusHandler: " + event.info.code);
		}
		
		private static var _instance:P2PManager;
		
		public static function get instance():P2PManager
		{
			if(!_instance)
			{
				_instance = new P2PManager();
			}
			
			return _instance;
		}

		public function get myPeerID():String
		{
			return _myPeerID;
		}

		public function get farPeerID():String
		{
			return _farPeerID;
		}

		public function set farPeerID(value:String):void
		{
			_farPeerID = value;
		}		
	}
}
