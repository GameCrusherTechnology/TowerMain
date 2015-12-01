package view.bullet
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	import view.entity.GameEntity;
	import view.entity.HeroEntity;
	import view.entity.MonsterEntity;
	
	public class longjuanfeng extends ArmObject
	{
		private var speed:int = 5;
		private var range:int = 1000;
		private var targets:Array = [];
		private var sx:Number;
		private var sy:Number;
		public function longjuanfeng(tPoint:Point,_level:int,_isleft:Boolean)
		{
			
			super(tPoint,1,_level,_isleft);
			
			var bPoint:Point = rule.heroEntity.attackPoint;
			var r:Number = Math.atan2((tPoint.y - bPoint.y),(tPoint.x-bPoint.x));
			
			
			armSurface = new MovieClip(Game.assets.getTextures("longjuanfeng"));
			armSurface.scaleX = armSurface.scaleY = rule.cScale*0.6;
			addChild(armSurface);
			
			armSurface.x = -armSurface.width/2;
			armSurface.y = -armSurface.height/4*3;
			
			speed = 5 *rule.cScale;
			sx = speed * Math.cos(r);
			sy = speed * Math.sin(r);
			
			x = bPoint.x;
			y = bPoint.y;
			
			rectW = armSurface.width /2;
			rectH = armSurface.height/2;
			
			Starling.juggler.add(armSurface as MovieClip);
			
			playSound();
		}
		private var curTarget:GameEntity;
		override public function refresh():void
		{
			move();
			if(range > 0 ){
				findTarget();
			}else{
				end();
			}
		}
		private function findTarget():void
		{
			if(isLeft){
				var vec:Array = rule.monsterVec;
				var entity:MonsterEntity;
				for each(entity in vec){
					if(targets.indexOf(entity)<=-1){
						if(!entity.isDead && entity.beInRound(curRect)){
							curTarget = entity;
							attack();
							break;
						}
					}
				}
			}else{
				var heroEntity:HeroEntity = rule.heroEntity;
				if(targets.indexOf(heroEntity)<=-1){
					if(!heroEntity.isDead && heroEntity.beInRound(curRect)){
						curTarget = heroEntity;
						attack();
					}
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
			return Math.round(hurt*(1*level/10+1.5));
		}
		private function end():void
		{
			removeFromParent(true);
			Starling.juggler.remove(armSurface as MovieClip);
			targets = [];
			curTarget = null;
			super.dispose();
		}
		override protected function get soundName():String
		{
			return "longjuanfeng"
		}
		
		override protected function get curRect():Rectangle
		{
			if(!rect){
				rect = new Rectangle(x-rectW/2,y-rectH/4*3,rectW,rectH);
			}else{
				rect.x = x-rectW/2;
				rect.y = y-rectH/4*3;
			}
			return rect;
		}
		
		override public function attack():void
		{
			if(curTarget ){
				targets.push(curTarget);
				playSound();
				curTarget.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/longjuanfeng"));
			}
		}
		
	}
}

