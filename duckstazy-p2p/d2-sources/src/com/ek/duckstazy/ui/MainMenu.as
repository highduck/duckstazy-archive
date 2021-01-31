package com.ek.duckstazy.ui
{
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.ek.duckstazy.game.Config;
	import com.ek.duckstazy.game.Game;
	import com.ek.duckstazy.game.LevelUtil;
	import com.ek.duckstazy.game.P2PManager;

	import flash.events.Event;



	/**
	 * @author eliasku
	 */
	public class MainMenu extends MenuScreen
	{
		private var _panel:Panel;
		
		private var _btnP1:PushButton;
		private var _btnP2:PushButton;
		private var _btnNetworkGame:PushButton;
		
		private var _btnReplays:PushButton;
		private var _btnEditor:PushButton;
		
		private var _txtMyPeer:TextArea;
		private var _txtFarPeer:TextArea;
		private var _btnConnect:PushButton;
		
		public function MainMenu()
		{
			super("main_menu");
			
			_panel = new Panel(null, 0, 0);
			_panel.setSize(Config.WIDTH, Config.HEIGHT);
			addChild(_panel);
			
			_btnP1 = new PushButton(_panel, 100, 100, "Single Player", onP1);
			_btnP1.enabled = false;
			
			_btnP2 = new PushButton(_panel, 100, 130, "2 Players", onP2);
			
			_btnNetworkGame = new PushButton(_panel, 100, 160, "Network", onNetworkGame);
			_btnNetworkGame.enabled = false;
			
			_btnReplays = new PushButton(_panel, 100, 190, "Replays", onReplays);
			
			_btnEditor = new PushButton(_panel, 100, 220, "Editor", onEditor);
			
			_txtMyPeer = new TextArea(_panel, 300, 100, "");
			_txtMyPeer.enabled = false;
			
			_txtMyPeer.autoHideScrollBar = true;
			_txtMyPeer.width = 400;
			_txtMyPeer.height = 20;
			
			_txtFarPeer = new TextArea(_panel, 300, 130, "");
			_txtFarPeer.autoHideScrollBar = true;
			_txtFarPeer.width = 400;
			_txtFarPeer.height = 20;
			
			_btnConnect = new PushButton(_panel, 300, 160, "Connect...", onConnect);
			
			P2PManager.instance.initialize(onP2PInitialized, onPeerConnect);
			//_lblMyPeer.text = P2PManager.instance.myPeerID;
		}


		private function onPeerConnect():void
		{
			_btnConnect.enabled = false;
			_txtFarPeer.editable = false;
			_btnNetworkGame.enabled = true;
		}

		private function onP2PInitialized():void
		{
			_txtMyPeer.text = P2PManager.instance.myPeerID;
			_txtMyPeer.enabled = true;
			_txtMyPeer.editable = false;
		}
		
		private function onConnect(e:Event):void
		{
			P2PManager.instance.farPeerID = _txtFarPeer.text;
			P2PManager.instance.initRecvStream();
		}

		private function onReplays(e:Event):void
		{
			Game.instance.startPrevReplay();
		}

		private function onP1(e:Event):void
		{
		}
		
		private function onP2(e:Event):void
		{
			SelectLevelMenu.open("versus");
		}
		
		private function onNetworkGame(e:Event):void
		{
			SelectLevelMenu.open("network");
		}
		
		private function onEditor(e:Event):void
		{
			Game.instance.startLevel( LevelUtil.createEditor("level_blank") );
		}

	}
}
