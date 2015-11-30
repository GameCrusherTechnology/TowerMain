package view.entity
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.GameController;
	import controller.VoiceController;
	
	import gameconfig.Configrations;
	import gameconfig.EntityState;
	
	import model.battle.BattleRule;
	import model.entity.EntityItem;
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
		}
		public function beAttacked(hurt:Number, texture:Texture, type:String="skill"):void
		{
			if(!isDead){
				
				item.beAttack(hurt);
				showLife();
				showHurtBar(texture,hurt,type);
				if(item.isDead){
					beDead();
				}
			}
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
			addChild(bar);
			bar.x = 0;
			bar.y = -item.entitySpec.recty +(item.entitySpec.recty- item.entitySpec.runy) - bar.height - 10;
		}
		
		public function beInRound(posx:Number,posy:Number):Boolean{
			var rect:Rectangle = item.getRect();
			return rect.containsPoint(new Point((posx - x)/rule.cScale,(posy - y)/rule.cScale));
		}
		
		public function get attackPoint():Point
		{
			if(isLeft){
				return new Point(x+item.entitySpec.attackx*rule.cScale,y - item.entitySpec.recty/2*rule.cScale);
			}else{
				return new Point(x-item.entitySpec.attackx*rule.cScale,y - item.entitySpec.recty/2*rule.cScale);
			}
		}
		
		public function get centerPoint():Point
		{
			return new Point(x ,y - item.entitySpec.recty/2*rule.cScale);
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
		
	}
}