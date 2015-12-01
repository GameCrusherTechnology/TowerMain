package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	import view.entity.GameEntity;
	import view.entity.HeroEntity;
	import view.entity.MonsterEntity;

	public class zhangxinlei extends ArmObject
	{
		private var range:int = 1000;
		private var speed:int = 0;
		private var sx:Number;
		private var sy:Number;
		public function zhangxinlei(tPoint:Point,_level:int,_isleft:Boolean)
		{
			
			super(tPoint,1,_level,_isleft);
			
			var bPoint:Point = rule.heroEntity.attackPoint;
			var r:Number = Math.atan2((tPoint.y - bPoint.y),(tPoint.x-bPoint.x));
			
			armSurface = new MovieClip(Game.assets.getTextures("zhangxinlei"));
			armSurface.scaleX = armSurface.scaleY = rule.cScale/3;
			
			addChild(armSurface);
			armSurface.x = -armSurface.width/2;
			armSurface.y = -armSurface.height/2;
			
			speed = 5 *rule.cScale;
			sx = speed * Math.cos(r);
			sy = speed * Math.sin(r);
			
			x = bPoint.x;
			y = bPoint.y;
			
			rectW = armSurface.width ;
			rectH = armSurface.height;
			
			Starling.juggler.add(armSurface as MovieClip);
			
		}
		private var curTarget:GameEntity;
		override public function refresh():void
		{
			move();
			if(range > 0 ){
				findTarget();
			}else{
				dispose();
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
			range -= speed;
		}
		private function gethurt():int 
		{
			return Math.round(hurt*(0.5*level/10+1.5));
		}
		override public function attack():void
		{
			if(curTarget){
				playSound();
				curTarget.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/zhangxinlei"));
			}
			dispose();
		}
		override protected function get soundName():String
		{
			return "xuanwo"
		}
		override public function dispose():void
		{
			Starling.juggler.remove(armSurface as MovieClip);
			removeFromParent();
			super.dispose();
		}
		
	}
}


