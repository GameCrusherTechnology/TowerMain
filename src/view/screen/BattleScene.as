package view.screen
{
	import flash.filesystem.File;
	import flash.geom.Point;
	
	import controller.SpecController;
	
	import gameconfig.Configrations;
	
	import model.battle.BattleRule;
	import model.gameSpec.SkillItemSpec;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;
	
	import view.compenent.BattleLoadingScreen;
	import view.compenent.HeroSkillButton;
	import view.compenent.HeroSkillTouchEvent;

	public class BattleScene extends Sprite
	{
		public var battleRule:BattleRule ;
		private var sceneheight:Number;
		private var backLayer:Sprite;
		private var bgLayer:Sprite;
		private var entityLayer:Sprite;
		public var armLayer:Sprite;
		private var superLayer:Sprite;
		private var uiLayer:Sprite;
		private var backScale:Number;
		
		public function BattleScene(rule:BattleRule)
		{
			battleRule = rule;
			initialize();
			prepareBattle();
		}
		
		private function initialize():void
		{
			initializeBack();
		}
		
		private function prepareBattle():void
		{
			if(!Configrations.BattleLoadingScene){
				Configrations.BattleLoadingScene = new BattleLoadingScreen();
			}
			addChild(Configrations.BattleLoadingScene);
			Configrations.BattleLoadingScene.start();
			
		}
		public function onPrepared(progress:Number):void
		{
			Configrations.BattleLoadingScene.validateLoading(progress);
			if(progress >= 1){
				Configrations.BattleLoadingScene.dispose();
				initializeHandler();
				addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}
		}
			
		private function onEnterFrame(e:Event):void
		{
			
		}
		protected function initializeHandler():void
		{
			configSkill();
			
			bgLayer.addEventListener(TouchEvent.TOUCH,onTouch);
		}
		private function initializeBack():void
		{
			bgLayer = new Sprite;
			addChild(bgLayer);
			backLayer= new Sprite;
			bgLayer.addChild(backLayer);
			entityLayer = new Sprite;
			bgLayer.addChild(entityLayer);
			armLayer = new Sprite;
			bgLayer.addChild(armLayer);
			superLayer = new Sprite;
			bgLayer.addChild(superLayer);
			uiLayer = new Sprite;
			addChild(uiLayer);
			configMap();
		}
		private var scenewidth:Number;
		private var bottomLine:Number = 0;
		private function configMap():void
		{
			var scenebackSkin:Image = new Image(Game.assets.getTexture("arryBG"));
			backScale = Math.max(Configrations.ViewPortWidth/scenebackSkin.width ,Configrations.ViewPortHeight/scenebackSkin.height)
			scenebackSkin.scaleX = scenebackSkin.scaleY = backScale;
			backLayer.addChild(scenebackSkin);
			scenebackSkin.y = scenebackSkin.height - Configrations.ViewPortHeight;
			scenewidth = scenebackSkin.width;
			sceneheight = Configrations.ViewPortHeight;
			bottomLine = scenebackSkin.height *0.7;
		}
		private var skillButs:Array = [];
		private function configSkill():void
		{
			skillButs = [];
//			var container:Sprite = new Sprite;
//			var skills:Array = battleRule.player.heroData.skillList;
//			var spec:SkillItemSpec;
//			var curIndex:int = 0;
//			var but:HeroSkillButton;
//			var side:Number = Configrations.ViewPortWidth *0.1;
//			var bottom:Number = Configrations.ViewPortHeight -  side - 20*Configrations.ViewScale;
//			
//			
//			for each(var id:String in skills){
//				spec = SpecController.instance.getItemSpec(id) as SkillItemSpec;
//				if(spec){
//					but = new HeroSkillButton(spec,side,spec.recycle);
//					container.addChild(but);
//					skillButs.push(but);
//					but.addEventListener(HeroSkillTouchEvent.trigger,onSkillTriggered);
//					but.x = curIndex*(side*1.3);
//					curIndex++;
//				}
//			}
//			container.addEventListener(Event.TRIGGERED,onSkillTriggered);
//			uiLayer.addChild(container);
//			container.x = Configrations.ViewPortWidth/2 - container.width/2;
//			container.y = bottom;
		}
		public function onTouch(evt:TouchEvent):void{
			var scenePos:Point;
			var touches:Vector.<Touch> = evt.getTouches(this, TouchPhase.MOVED);
			if (touches.length >= 1){
				var movetouch:Touch = touches[0] as Touch;
			}
			
			//touch begin
			var beginTouch:Touch = evt.getTouch(this,TouchPhase.BEGAN);
			if(beginTouch){
//				mouseDownPos = new Point(beginTouch.globalX, beginTouch.globalY);
			}
			
		}
	}
}