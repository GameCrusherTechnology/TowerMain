package view.entity
{
	import flash.geom.Point;
	
	import gameconfig.Configrations;
	import gameconfig.EntityState;
	
	import model.entity.MonsterItem;
	
	import starling.textures.Texture;

	public class MonsterEntity extends GameEntity
	{
		private var curTarget:GameEntity;
		private var targetPoint:Point;
		public function MonsterEntity(soItem:MonsterItem)
		{
			super(soItem);
			curTarget = rule.heroEntity;
			targetPoint = new Point(curTarget.x,curTarget.y); 
			scaleY = scaleX = 0.8*rule.cScale;
		}
		override protected function check():void
		{
			setSpeed();
		}
		private function setSpeed():void
		{
			var a:Number = Math.atan2(targetPoint.y - y,targetPoint.x - x);
			sx = soldierItem.speed * Math.cos(a);
			sy = soldierItem.speed * Math.sin(a);
		}
		private var sx:Number;
		private var sy:Number;
		protected function walk():void
		{
			showState(EntityState.WALK);
			x +=(sx*rule.cScale);
			y +=(sy*rule.cScale);
		}
		public function move(p:Point):void
		{
			x = x+p.x;
			y = y+p.y;
		}
		
		private var attackCD:int;
		override public function validate():void
		{
			attackCD --;
			if(curTarget || !curTarget.isDead ){
				if(!inRange()){
					if(canMove){
						walk();
					}
				}else{
					if(attackCD <=0){
						if(canAttack){
							attack();
						}
					}else{
						showState(EntityState.ATTACK,false);
					}
				}
				validateSkill();
			}
		}
		
		private function canMove():Boolean
		{
			return false;
		}
		private function canAttack():Boolean
		{
			return false;
		}
		protected function attack():void
		{
			showState(EntityState.ATTACK);
			attackCD = soldierItem.attackCycle;
			
//			if(curSkill && curSkill.canUse()){
//				useSkill();
//			}else{
//				if(!curSkill){
//					checkSkill();
//				}
			rule.addArm(new item.armClass(attackPoint,item.hurtPoint,1,armDirection,isLeft));
//			}
		}
		
		private function get armDirection():Number
		{
			var tarPos:Point = rule.heroEntity.centerPoint;
			return Math.atan2((tarPos.y - attackPoint.y),(tarPos.x-attackPoint.x));
		}
		override public function beAttacked(hurt:Number, texture:Texture, type:String="skill"):void
		{
			super.beAttacked(hurt,texture,type);
			checkSkill();
		}
		
		private function inRange():Boolean
		{
				return Point.distance(targetPoint,new Point(x,y)) < item.range*rule.cScale;
		}
		
		private function validateSkill():void
		{
		}
//		protected function useSkill():void
//		{
//			battleRule.addArm(new curSkill.skillCls(battleRule,new Point(x,y - item.itemSpec.recty/2),getCurAttackPoint(),curSkill.level,isLeft));
//			curSkill.useTime = 0;
//			curSkill = null;
//		}
		
		protected function checkSkill():void
		{
//			if(!curSkill || !curSkill.canUse()){
//				
//				if(item.life <= item.totalLife && (item as SoldierItem).skills.length>0)
//				{
//					for each(var skillData:SkillData in (item as SoldierItem).skills)
//					{
//						if(skillData.canUse()){
//							curSkill = skillData;
//							break;
//						}
//					}
//				}
//			}
		}
		
		private function get soldierItem():MonsterItem
		{
			return item as MonsterItem;
		}
		
		override public function get attackPoint():Point
		{
			return new Point(x-item.entitySpec.attackx*rule.cScale*0.8,y - item.entitySpec.recty/2*rule.cScale*0.8);
		}
		
		
		override protected function beDead():void
		{
			super.beDead();
			rule.removeMonster(this);
		}
	}
}