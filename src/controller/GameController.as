
package controller
{
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	
	import gameconfig.LanguageController;
	import gameconfig.LocalData;
	
	import model.battle.BattleRule;
	import model.player.GameUser;
	
	import starling.display.Sprite;
	import starling.utils.AssetManager;
	
	import view.panel.MessagePanel;
	import view.panel.PanelConfirmEvent;
	import view.screen.BattleScene;
	import view.screen.WorldScene;

	public class GameController
	{
		private var gameLayer:Sprite;
		private var sceneLayer:Sprite;
		private var dialogLayer:Sprite;
		private var uiLayer:Sprite;
		
		public var localPlayer:GameUser;
		public var selectTool:String;
		public var selectSeed:String;
		public var isNewer:Boolean = false;
		//super_man_01
		private static var _controller:GameController;
		public static function get instance():GameController
		{
			if(!_controller){
				_controller = new GameController();
			}
			return _controller;
		}
		public function GameController()
		{
			
		}
		
		public function show(layer:Game):void
		{
			gameLayer = layer;
			
			sceneLayer = new Sprite();
			gameLayer.addChild(sceneLayer);
			
			uiLayer = new Sprite;
			gameLayer.addChild(uiLayer);
			
			dialogLayer = new Sprite();
			gameLayer.addChild(dialogLayer);
			DialogController.instance.setLayer(dialogLayer);
			
		}
		public function start():void
		{
			VoiceController.instance.init();
			localPlayer = LocalData.instance.localPlayer;
			showWorldScene();
			initSource();
		}
		private function initSource():void
		{
			var appDir:File = File.applicationDirectory;
			var assets:AssetManager = Game.assets;
			assets.enqueue(
				appDir.resolvePath("textures/skill/")
			);
			assets.loadQueue(onSourcePrepared);
		}
		public function onSourcePrepared(progress:Number):void
		{
			if(progress >= 1){
			}
		}
		public function get layer():Sprite
		{
			return gameLayer;
		}
		
		private var curWorld:WorldScene;
		
		public function get curWorldScene():WorldScene
		{
			return curWorld;
		}
		
		public function showWorldScene():void{
			if(curBattleScene){
				curBattleScene.removeFromParent(true);
				curBattleScene= null;
			}
			
			if(!curWorld){
				curWorld = new WorldScene();
			}
			VoiceController.instance.playRack();
			sceneLayer.addChild(curWorld);
			
		}
		
		public var curBattleRule:BattleRule;
		public var curBattleScene:BattleScene;
		public function beginBattle(rule:BattleRule):void
		{
			DialogController.instance.destroy();
			if(curWorld){
				curWorld.removeFromParent();
			}
			if(curBattleScene){
				curBattleScene.removeFromParent(true);
				curBattleScene= null;
			}
			curBattleRule = rule;
			
			curBattleScene = new BattleScene(rule);
			sceneLayer.addChild(curBattleScene);
			
		}
		public function showAD():void
		{
			 var rot:Number = 0.5;
			 var ran:Number = Math.random();
			 if(ran < rot){
				 PlatForm.showAD(); 
			}
		}
		
	
		
		public function onKeyCancel():void
		{
			if(DialogController.instance.hasPanel){
				DialogController.instance.destroy();
			}else{
				var panel:MessagePanel = new MessagePanel(LanguageController.getInstance().getString("warnintLeave") ,true)
				DialogController.instance.showPanel(panel);
				panel.addEventListener(PanelConfirmEvent.CLOSE,onOutConfirmHandler);
			}
		}
		private function onOutConfirmHandler(e:PanelConfirmEvent):void
		{
			if(e.BeConfirm){
				NativeApplication.nativeApplication.exit();
			}
		}
		public function refreshLanguage():void
		{
		}
		public function get VersionMes():Array
		{
			return [1,2,3];
		}
		
	}
}