package view.bullet
{
	import flash.geom.Point;
	
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
		protected var rotate:Number;
		public function ArmObject(_fromPoint:Point,_hurtV:int,_level:int,_rotate:Number = 0,_isLeft:Boolean = true)
		{
			rule = GameController.instance.curBattleRule;
			level = _level;
			hurt = _hurtV;
			fromPoint = _fromPoint;
			isLeft = _isLeft;
			rotate = _rotate;
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