package view.entity
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.GameController;
	import controller.SpecController;
	import controller.VoiceController;
	
	import gameconfig.Configrations;
	import gameconfig.EntityState;
	
	import model.battle.BattleRule;
	import model.entity.EntityItem;
	import model.gameSpec.ItemSpec;
	import model.gameSpec.SkillItemSpec;
	import model.gameSpec.SoldierItemSpec;
	import model.item.HeroData;
	import model.item.SkillData;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import view.compenent.HurtTip;
	import view.compenent.SoldierLifeProgressBar;

	public class GameEntity extends Sprite
	{
		protected var item:EntityItem;
		protected var surface:DisplayObject;
		protected static const WALK:String = "run";
		protected static const STAND:String = "stand";
		protected static const ATTACK:String = "attack";
		
		private var state:String;
		protected var isLeft:Boolean;
		protected var rule:BattleRule;
		
		protected var sx:Number;
		protected var sy:Number;
		public function GameEntity(_item:EntityItem)
		{
			item = _item;
			isLeft = this is HeroEntity;
			rule = GameController.instance.curBattleRule;
			initFace();
			this.touchable = false;
			addEventListener(Event.ADDED_TO_STAGE,onADDToStage);
		}
		private function onADDToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onADDToStage);
			check();
		}
		protected function check():void
		{
			
		}
		
		public function setSpeed(ra:Number = 1):void
		{
		}
		
		protected function initFace():void
		{
			showState(STAND);
			showSound();
		}
		
		protected function showState(_state:String,animotion:Boolean = true):void
		{
			if(state != _state){
				state = _state;
				
				playAnimotion(state);
			}else if(_state == EntityState.ATTACK && animotion){
				(surface as MovieClip).currentFrame = 0;
				(surface as MovieClip).play();
			}
		}
		protected function playAnimotion(_state:String):void
		{
			if(surface){
				surface.removeFromParent(true);
				Starling.juggler.remove(surface as MovieClip);
			}
			surface = new MovieClip(Game.assets.getTextures(item.texturecls+"_"+_state),12);
			
			var px:Number = 0;
			var py:Number = 0;
			switch(_state){
				case EntityState.WALK:
					px = item.entitySpec.runx;
					py = item.entitySpec.runy;
					break;
				case EntityState.ATTACK:
					(surface as MovieClip).loop = false;
					px = item.entitySpec.attackx;
					py = item.entitySpec.attacky;
					break;
				case EntityState.STAND:
					px = item.entitySpec.standx;
					py = item.entitySpec.standy;
					break;
				
			}
			
			if(isLeft){
				surface.x = -px;
				surface.y = -py;
			}else{
				surface.scaleX = - 1;
				surface.x = px;
				surface.y = -py;
			}
			addChild(surface);
			Starling.juggler.add(surface as MovieClip);
			
		}
		
		private var curTarget:GameEntity;
		protected var curSkill:SkillData;
		
		public function validate():void
		{
			checkBuff();
		}
		public function beAttacked(hurt:Number, texture:Texture, type:String="skill"):void
		{
			if(!isDead){
				if(biaojiCount > 0){
					var l31003:int = heroData.getSkillItem("31003").count;
					if(l31003>0){
						var newR:Number = Configrations.skill31003Point[l31003];
						hurt = Math.floor(hurt*(1+newR));
					}
				}
				
				item.beAttack(hurt);
				showLife();
				showHurtBar(texture,hurt,type);
				if(item.isDead){
					beDead();
				}
			}
		}
		
		protected function canMove():Boolean
		{
			if(stopCount > 0){
				return false;
			}
			return true;
		}
		
		private var mc30003:MovieClip;
		private var stopCount:int;
		
		private var mc30008:MovieClip;
		private var slowCount:int;
		
		private var mc30009:MovieClip;
		private var healthCount:int;
		
		private var mc31003:MovieClip;
		private var biaojiCount:int;
		
		private var mc31005:MovieClip;
		private var fireBuffHurt:int;
		private var fireBuffIndex:int;
		private var fireBuffCount:int;
		
		public function beBuffed(typeId:String,add:int = 0):void
		{
			switch(typeId)
			{
				case "30003":
					if(!mc30003){
						mc30003 = creatBuffMC("greenBuff");
					}
					addChild(mc30003);
					stopCount = Configrations.skill30003Point;
					Starling.juggler.add(mc30003);
					break;
					
				case "30008":
					if(!mc30008){
						mc30008 = creatBuffMC("bingfengjian");
					}
					addChild(mc30008);
					slowCount = Configrations.skill30008Point;
					var l:int = heroData.getSkillItem("30008").count;
					if(l>0){
						setSpeed(Configrations.skillP30008Point[l]);
					}
					Starling.juggler.add(mc30008);
					break;
				case "30009":
					if(!mc30009){
						mc30009 = creatBuffMC("healthBuff");
					}
					addChild(mc30009);
					healthCount = Configrations.skill30009Point;
					
					item.beHealth(add);
					showLife();
					var spec:ItemSpec = SpecController.instance.getItemSpec("30009");
					showHurtBar(spec.iconTexture,add);
					
					Starling.juggler.add(mc30009);
					break;
				case "31003":
					if(!mc31003){
						mc31003 = creatBuffMC("thunder");
					}
					addChild(mc31003);
					biaojiCount = Configrations.skill31003Add;
					Starling.juggler.add(mc31003);
					break;
				
				case "31005":
					if(!mc31005){
						mc31005 = creatBuffMC("redBuff");
					}
					addChild(mc31005);
					fireBuffHurt = add;
					fireBuffIndex = 3;
					fireBuffCount = 30;
					
					
					Starling.juggler.add(mc31005);
					break;
				default:
				{
					break;
				}
			}
		}
		
		public function checkBuff():void
		{
			if(stopCount>0){
				stopCount --;
			}else{
				if(mc30003 && mc30003.parent){
					Starling.juggler.remove(mc30003);
					mc30003.removeFromParent();
				}
			}
			
			if(slowCount>0){
				slowCount --;
			}else{
				if(mc30008 && mc30008.parent){
					Starling.juggler.remove(mc30008);
					mc30008.removeFromParent();
					setSpeed();
				}
			}
			
			if(healthCount>0){
				healthCount --;
			}else{
				if(mc30009 && mc30009.parent){
					Starling.juggler.remove(mc30009);
					mc30009.removeFromParent();
				}
			}
			
			if(biaojiCount>0){
				biaojiCount --;
			}else{
				if(mc31003 && mc31003.parent){
					Starling.juggler.remove(mc31003);
					mc31003.removeFromParent();
				}
			}
			
			if(fireBuffCount >0){
				fireBuffCount --;
			}else{
				if(fireBuffIndex > 0){
					
					item.beAttack(fireBuffHurt);
					showLife();
					var spec1:ItemSpec = SpecController.instance.getItemSpec("31005");
					showHurtBar(spec1.iconTexture,fireBuffHurt);
					
					fireBuffCount = 30;
					fireBuffIndex--;
					
				}else{
					if(mc31005 && mc31005.parent){
						Starling.juggler.remove(mc31005);
						mc31005.removeFromParent();
						
					}
				}
			}
		}
		private function creatBuffMC(name:String):MovieClip
		{
			var spec:SoldierItemSpec = item.entitySpec;
			var mc:MovieClip = new MovieClip(Game.assets.getTextures(name));
			var s1:Number = Math.min(spec.rectw/mc.width,spec.recty/mc.height);
			mc.scaleX = mc.scaleY = s1;
			mc.x = 	-mc.width/2 ;
			mc.y =  -mc.height;
			return mc;
		}
		
		
		private var lifeBar:SoldierLifeProgressBar;
		protected function showLife():void
		{
			if(!lifeBar){
				lifeBar = new SoldierLifeProgressBar(item.entitySpec,isLeft);
				addChild(lifeBar);
				lifeBar.x = -lifeBar.width/2;
				lifeBar.y = -item.entitySpec.recty +(item.entitySpec.recty- item.entitySpec.runy) - lifeBar.height ;
			}
			lifeBar.showProgress(item.curLife,item.totalLife);
		}
		
		public function showHurtBar(texture:Texture,hurt:int,type:String="skill"):void
		{
			var bar:HurtTip = new HurtTip(texture,hurt,isLeft,type);
			bar.x = x;
			bar.y = y-item.entitySpec.recty*rule.cScale +(item.entitySpec.recty- item.entitySpec.runy)*rule.cScale - bar.height - 10;
			rule.showHurtBar(bar);
		}
		
		public function beInRound(rectArm:Rectangle):Boolean{
//			hitTest
			var rect:Rectangle = getRect();
			
			return rect.intersects(rectArm);
		}
		
		public function get attackPoint():Point
		{
			if(isLeft){
				return new Point(x+item.entitySpec.attackx*rule.cScale,y - item.entitySpec.recty/2*rule.cScale);
			}else{
				return new Point(x-item.entitySpec.attackx*rule.cScale,y - item.entitySpec.recty/2*rule.cScale);
			}
		}
		
		private var _runRect:Rectangle;
		public function getRect():Rectangle
		{
			var spec:SoldierItemSpec = item.entitySpec;
			var s:Number = rule.cScale;
			if(!_runRect){
				_runRect = new Rectangle(x-spec.rectw/2*s,y-spec.recty*s,spec.rectw*s,spec.recty*s);
			}else{
				_runRect.x = x-spec.rectw/2*s;
				_runRect.y = y-spec.recty*s;
			}
			return _runRect;
		}
		
		public function get centerPoint():Point
		{
			return new Point(x ,y - item.entitySpec.recty/2*rule.cScale);
		}
		public function get posPoint():Point
		{
			return new Point(x ,y);
		}
		protected function showSound():void
		{
			VoiceController.instance.playSound(item.entitySpec.sound);
		}
		
		protected function beDead():void
		{
			isDead = true;
			showSound();
		}
		public var  isDead:Boolean = false;
		protected function get heroData():HeroData
		{
			return GameController.instance.localPlayer.heroData;
		}
		override public function dispose():void
		{
			if(mc30003){
				mc30003.removeFromParent(true);
				Starling.juggler.remove(mc30003);
				mc30003 = null;
			}
			super.dispose();
		}
		
	}
}