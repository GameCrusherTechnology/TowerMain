package view.bullet
{
	import flash.geom.Point;
	
	import view.entity.GameEntity;
	
	public class Sword extends ArmObject
	{
		private const RANGE:int = 300;
		private var arrowSpeed:int = 2;
		public function Sword(_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean=true)
		{
			super(_fromPoint,_hurtV,_level,_isleft);
			attack();
			
		}
		
		private function inRange(entity:GameEntity):Boolean
		{
			if(Math.abs(fromPoint.x - entity.x)< RANGE*rule.cScale){
				return true
			}
			return false;
		}
		override public function attack():void
		{
			var targetSoldier:GameEntity ;
			if(!isLeft){
				targetSoldier = rule.heroEntity;
			}else{
				targetSoldier = rule.monsterVec[0];
			}
			if(targetSoldier && inRange(targetSoldier)){
				playSound();
				targetSoldier.beAttacked(hurt,Game.assets.getTexture("skillIcon/sword"),"attack");
			}
			
			removeFromParent(true);
			super.dispose();
		}
		
	}
}
