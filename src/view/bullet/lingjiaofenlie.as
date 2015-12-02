package view.bullet
{
	import flash.geom.Point;
	
	import gameconfig.Configrations;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	
	import view.entity.GameEntity;
	import view.entity.HeroEntity;
	import view.entity.MonsterEntity;
	
	public class lingjiaofenlie extends ArmObject
	{
		private var speed:int ;
		private var endP:Number = 0;
		private var range:int = 500;
		private var entitys:Array = [];
		private var sx:Number;
		private var sy:Number;
		private var curR:Number;
		private var oldEntity:GameEntity;
		public function lingjiaofenlie(old:GameEntity,tPoint:Point,hurt:int,_level:int,rotate:Number)
		{
			oldEntity = old;
			var curhurt:int = hurt;
			super(tPoint,curhurt,_level);
			
			curR = rotate;
			
			
			armSurface = new MovieClip(Game.assets.getTextures("jiguangjian"));
			addChild(armSurface);
			Starling.juggler.add(armSurface as MovieClip);
			
			armSurface.pivotX = armSurface.width;
			armSurface.pivotY =  armSurface.height/2;
			
			armSurface.scaleY = armSurface.scaleX  = rule.cScale*0.2;
			
			armSurface.rotation = rotate;
			
			speed = 20 *rule.cScale;
			sx = speed * Math.cos(rotate);
			sy = speed * Math.sin(rotate);
			
			x = tPoint.x;
			y = tPoint.y;
			
			rectW = armSurface.width /3;
			rectH = armSurface.height/2;
			
			
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
		
		private var targets:Array = [];
		private function findTarget():void
		{
			if(isLeft){
				var vec:Array = rule.monsterVec;
				var entity:MonsterEntity;
				for each(entity in vec){
					if(entity != oldEntity && targets.indexOf(entity)<=-1){
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
		
		private function end():void
		{
			removeFromParent(true);
			Starling.juggler.remove(armSurface as MovieClip);
			entitys = [];
			curTarget = null;
			super.dispose();
		}
		override protected function get soundName():String
		{
			return "arrow"
		}
		override public function attack():void
		{
			if(curTarget){
				targets.push(curTarget);
				playSound();
				curTarget.beAttacked(hurt,Game.assets.getTexture("skillIcon/lingjiaojian"));
				
				if(level > 1){
					var curP:Point = new Point(x,y);
					var newhurt:int = Math.max(1,Math.floor(hurt*0.5));
					rule.addArm(new lingjiaofenlie(curTarget,curP,newhurt,level-1,curR-0.2));
					rule.addArm(new lingjiaofenlie(curTarget,curP,newhurt,level-1,curR+0.2));
				}
			}
			end();
		}
		
	}
}

