package view.bullet
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.GameController;
	import controller.VoiceController;
	
	import model.battle.BattleRule;
	import model.item.HeroData;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class ArmObject extends Sprite
	{
		protected var armSurface:Image;
		protected var fromPoint:Point;
		protected var isLeft:Boolean;
		protected var rule:BattleRule;
		protected var level:int;
		protected var hurt:int;
		protected var rect:Rectangle;
		protected var rectW:Number = 100;
		protected var rectH:Number = 100;
		public function ArmObject(_fromPoint:Point,_hurtV:int,_level:int,_isLeft:Boolean = true)
		{
			rule = GameController.instance.curBattleRule;
			level = _level;
			hurt = _hurtV;
			fromPoint = _fromPoint;
			isLeft = _isLeft;
			x = fromPoint.x;
			y = fromPoint.y;
		}
		
		public function refresh():void
		{
			
		}
		public function attack():void
		{
			
		}
//		protected function get enemyCastle():GameEntity
//		{
//			if(isLeft){
//				return rule.enemyCastleEntity;
//			}else {
//				return rule.homeCastleEntity;
//			}
//		}
		protected function playSound():void
		{
			VoiceController.instance.playSound(soundName);
		}
		protected function get soundName():String
		{
			return "sword"
		}
		protected function get curRect():Rectangle
		{
			if(!rect){
				if(isLeft){
					rect = new Rectangle(x-rectW,y-rectH/2,rectW,rectH);
				}else{
					rect = new Rectangle(x,y-rectH/2,rectW,rectH);
				}
			}else{
				if(isLeft){
					rect.x = x-rectW;
					rect.y = y-rectH/2;
				}else{
					rect.x = x;
					rect.y = y-rectH/2;
				}
			}
			return rect;
		}
		protected function get heroData():HeroData
		{
			return GameController.instance.localPlayer.heroData;
		}
		override public function dispose():void
		{
			rule.removeArm(this);
			if(armSurface){
				armSurface.removeFromParent(true);
			}
			removeFromParent();
			super.dispose();
		}
		
	}
}