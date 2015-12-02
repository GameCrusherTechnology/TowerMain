package view.entity
{
	import flash.geom.Point;
	
	import controller.GameController;
	
	import gameconfig.EntityState;
	
	import model.entity.HeroItem;
	import model.item.HeroData;
	
	import starling.textures.Texture;
	
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
			super.validate();
		}
		
		protected function attack():void
		{
			showState(EntityState.ATTACK);
			attackCD = item.attackCycle;
			rule.addArm(new HeroArrow(attackPoint,item.hurtPoint,armDirection));
		}
		override public function beAttacked(hurt:Number, texture:Texture, type:String="skill"):void
		{
			var curHurt:int = Math.floor(hurt*(1-heroData.curDefense));
			super.beAttacked(curHurt,texture,type);
		}
		override public function get attackPoint():Point
		{
			return new Point(x+item.entitySpec.attackx*rule.cScale*0.7,y - item.entitySpec.recty/2*rule.cScale*0.7);
		}
		override public function get centerPoint():Point
		{
			return new Point(x ,y - item.entitySpec.recty/2*rule.cScale*0.7);
		}
		
		override protected function beDead():void
		{
			super.beDead();
		}
		
	}
}