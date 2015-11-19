package view.entity
{
	import flash.geom.Point;
	
	import controller.GameController;
	
	import gameconfig.Configrations;
	import gameconfig.EntityState;
	
	import model.entity.HeroItem;
	
	import view.bullet.HeroArrow;

	public class HeroEntity extends GameEntity
	{
		public function HeroEntity(heroItem:HeroItem)
		{
			super(heroItem);
			scaleY = scaleX = 0.7*rule.cScale;
		}
		
		override protected function initFace():void
		{
			showState(GameEntity.ATTACK);
			showSound();
		}
		
		public var armDirection:Number = 0;
		public function setDirection(pos:Point):void
		{
			armDirection =Math.min( Math.max(-1.5,Math.atan2((pos.y - attackPoint.y),(pos.x-attackPoint.x))),1.5);
		}
		
		private var attackCD:int;
		override public function validate():void
		{
			attackCD --;
			if(attackCD <=0){
				attack();
			}else{
				showState(EntityState.ATTACK,false);
			}
		}
		
		protected function attack():void
		{
			showState(EntityState.ATTACK);
			attackCD = item.attackCycle;
			rule.addArm(new HeroArrow(attackPoint,item.hurtPoint,armDirection));
		}
		
		private var _attackP:Point;
		public function get attackPoint():Point
		{
			if(!_attackP){
				_attackP = new Point(x,y - item.entitySpec.recty/2*Configrations.ViewScale);
			}
			return _attackP;
		}
		override protected function beDead():void
		{
			super.beDead();
		}
		
	}
}