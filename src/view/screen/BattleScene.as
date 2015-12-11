package view.screen
{
	import flash.geom.Point;
	
	import controller.SpecController;
	
	import gameconfig.Configrations;
	
	import model.battle.BattleRule;
	import model.gameSpec.SkillItemSpec;
	import model.item.HeroData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import view.bullet.ArmObject;
	import view.compenent.BattleLoadingScreen;
	import view.compenent.BattleTopPart;
	import view.compenent.HeroSkillButton;
	import view.compenent.HurtTip;
	import view.entity.GameEntity;

	public class BattleScene extends Sprite
	{
		private var battleRule:BattleRule ;
		private var sceneheight:Number;
		private var backLayer:Sprite;
		private var bgLayer:Sprite;
		private var entityLayer:Sprite;
		private var armLayer:Sprite;
		private var superLayer:Sprite;
		private var uiLayer:Sprite;
		private var backScale:Number;
		
		public function BattleScene(rule:BattleRule)
		{
			battleRule = rule;
			initialize();
			addEventListener(Event.ADDED_TO_STAGE,onAddStage);
			prepareBattle();
		}
		
		private function onAddStage(e:Event):void
		{
			battleRule.prepareBattle();
		}
		private function initialize():void
		{
			initializeBack();
			entityVec = new Vector.<GameEntity>;
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
				battleRule.beginBattle();
				initializeHandler();
				addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}
		}
			
		private function onEnterFrame(e:Event):void
		{
			sort();
			battleRule.validate();
		}
		protected function initializeHandler():void
		{
			configSkill();
			configTop();
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
			bottomLine = scenebackSkin.height *0.65;
			battleRule.cScale = backScale;
		}
		
		public var battleTop:BattleTopPart;
		private function configTop():void
		{
			if(!battleTop){
				battleTop = new BattleTopPart();
			}
			uiLayer.addChild(battleTop);
		}
		
		private var skillButs:Array = [];
		private function configSkill():void
		{
			skillButs = [];
			var container:Sprite = new Sprite;
			var heroData:HeroData = battleRule.player.heroData
			var skills:Array = heroData.skills;
			var spec:SkillItemSpec;
			var curIndex:int = 0;
			var but:HeroSkillButton;
			var side:Number = Configrations.ViewPortWidth *0.1;
			var bottom:Number = Configrations.ViewPortHeight*0.98 -  side ;
			
			var heroCool:Number = 1 - (heroData.curWisdomCD/100);
			var cL:int = heroData.getSkillItem("31006").count;
			var coolCDMagic:Number = Configrations.skill31006Point[cL];
			
			var aL:int = heroData.getSkillItem("30006").count;
			var coolCDArrow:Number = Configrations.skillP30006Point[aL];
			
			for each(var id:String in skills){
				spec = SpecController.instance.getItemSpec(id) as SkillItemSpec;
				if(spec){
					var newCycle:int ;
					if(spec.type == "magic"){
						newCycle = Math.floor(spec.recycle*(1-coolCDMagic) *heroCool);
					}else{
						newCycle = Math.floor(spec.recycle*(1-coolCDArrow) *heroCool);
					}
					but = new HeroSkillButton(spec,side,newCycle);
					container.addChild(but);
					skillButs.push(but);
					but.x = curIndex*(side*1.3);
					curIndex++;
				}
			}
			uiLayer.addChild(container);
			container.x = Configrations.ViewPortWidth/2 - container.width/2;
			container.y = bottom;
		}
		
		
		public function onTouch(evt:TouchEvent):void{
			
			var beginTouch:Touch = evt.getTouch(this,TouchPhase.BEGAN);
			if(beginTouch){
				var p:Point = beginTouch.getLocation(bgLayer);
				if(battleRule.curSkillBut){
					battleRule.useSkill(p);
				}else{
					battleRule.heroEntity.setDirection(beginTouch.getLocation(bgLayer));
				}
				
			}else{
				var touches:Vector.<Touch> = evt.getTouches(this, TouchPhase.HOVER);
				if (touches.length >= 1){
					var hovertouch:Touch = touches[0] as Touch;
					battleRule.heroEntity.setDirection(hovertouch.getLocation(bgLayer));
				}else{
					touches = evt.getTouches(this, TouchPhase.MOVED);
					if (touches.length >= 1){
						var movetouch:Touch = touches[0] as Touch;
						battleRule.heroEntity.setDirection(movetouch.getLocation(bgLayer));
					}
				}
			}
		}
		private var entityVec:Vector.<GameEntity>;
		public function addEntity(entity:GameEntity ,hN:Number, isLeft:Boolean = false):void
		{
			if(entityVec.indexOf(entity)<=-1){
				if(isLeft ){
					entity.x = heroPoint.x;
				}else{
					entity.x = scenewidth * 0.8;
				}
				entity.y = bottomLine + (hN - 0.5) * bottomLine*3 /4;
				entityVec.push(entity);
				entityLayer.addChild(entity);
			}
		}
		public function removeEntity(entity:GameEntity):void
		{
			if(entityVec.indexOf(entity)>=0){
				entityVec.splice(entityVec.indexOf(entity),1);
			}
			entity.removeFromParent(true);
		}
		public function addHurtBar(bar:HurtTip):void
		{
			uiLayer.addChild(bar);
		}
		
		private var _heroPoint:Point;
		private function get heroPoint():Point
		{
			if(!_heroPoint){
				_heroPoint = new Point(scenewidth * 0.1,bottomLine);
			}
			return _heroPoint;
		}
		
		public function addArm(arm:ArmObject):void
		{
			armLayer.addChild(arm);
		}
		
		private function sort():void
		{
			entityVec.sort(sortY);
			var entity:GameEntity;
			var i:int = 0;
			var l:int = entityVec.length ;
			for(i;i<l;i++){
				entityLayer.addChildAt(entityVec[i],i);
			}
		}
		private function sortY(arg1:GameEntity,arg2:GameEntity):Number
		{
			if (arg1.y < arg2.y)
			{
				return -1;
			}
			else if (arg1.y > arg2.y)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
	}
}