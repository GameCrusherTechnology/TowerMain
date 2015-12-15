package view.entity
{
	import flash.geom.Point;
	
	import gameconfig.EntityState;
	
	import model.entity.HeroItem;
	
	import starling.textures.Texture;
	
	import view.bullet.HeroArrow;
	import view.bullet.fireball;
	import view.bullet.guangjian;
	import view.bullet.icebird;
	import view.bullet.purpleball;

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
			rule.addArm(new getArrowClass(attackPoint,item.hurtPoint,armDirection));
		}
		
		private function get getArrowClass():Class
		{
			var cls:Class = HeroArrow;
			switch(heroData.curWeapon)
			{
				case "80000":
				{
					cls = guangjian;
					break;
				}
				case "80001":
				{
					cls = fireball;
					break;
				}
				case "80002":
				{
					cls = icebird;
					break;
				}
				case "80003":
				{
					cls = purpleball;
					break;
				}
				default:
				{
					cls = HeroArrow;
					break;
				}
			}
			return cls;
		}
		public function revive():void
		{
			(item as HeroItem).revive();
			isDead = false;
			showLife();
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
			rule.loseGame();
		}
		
		public function get heroItem():HeroItem
		{
			return item as HeroItem;
		}
		
	}
}