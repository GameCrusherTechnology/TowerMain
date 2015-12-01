package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.display.Image;
	
	import view.entity.GameEntity;
	import view.entity.HeroEntity;
	import view.entity.MonsterEntity;
	
	public class fireBullet extends ArmObject
	{
		private var arrowSpeed:int ;
		private var range:int =2000;
		private var showFrame:int = 20;
		private var sx:Number;
		private var sy:Number;
		public function fireBullet(_fromPoint:Point,_hurtV:int,_level:int,_rotate:Number,_isleft:Boolean=true)
		{
			super(_fromPoint,_hurtV,1,_isleft);
			
			armSurface = new Image(Game.assets.getTexture("fireBullet"));
			
			armSurface.pivotX = armSurface.width;
			armSurface.pivotY =  armSurface.height/2;
			
			armSurface.scaleX = rule.cScale*0.3;
			armSurface.scaleY = rule.cScale*0.3;
			
			armSurface.rotation = _rotate;
			
			arrowSpeed = 10 *rule.cScale;
			sx = arrowSpeed * Math.cos(_rotate);
			sy = arrowSpeed * Math.sin(_rotate);
			
			
		}
		
		private var curTarget:GameEntity;
		override public function refresh():void
		{
			if(showFrame ==0){
				addChild(armSurface);
				showFrame -- ;
			}
			else if(showFrame<0){
				move();
				if(range > 0 ){
					findTarget();
				}else{
					dispose();
				}
			}else{
				showFrame -- ;
			}
		}
		private function findTarget():void
		{
			if(isLeft){
				var vec:Array = rule.monsterVec;
				var entity:MonsterEntity;
				for each(entity in vec){
					if(!entity.isDead && entity.beInRound(curRect)){
						curTarget = entity;
						attack();
						break;
					}
				}
			}else{
				var heroEntity:HeroEntity = rule.heroEntity;
				if(!heroEntity.isDead && heroEntity.beInRound(curRect)){
					curTarget = heroEntity;
					attack();
				}
			}
		}
		private function move():void
		{
			x += sx;
			y += sy;
			range -= arrowSpeed;
		}
		
		override public function attack():void
		{
			if(curTarget){
				playSound();
				var hurt:int = heroData.curAttackPoint;
				curTarget.beAttacked(hurt,Game.assets.getTexture("skillIcon/arrow"),"attack");
			}
			dispose();
		}
		
		override protected function get soundName():String
		{
			return "baozha"
		}
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
	}
}

