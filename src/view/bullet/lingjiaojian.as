package view.bullet
{
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	
	import view.entity.GameEntity;
	import view.entity.HeroEntity;
	import view.entity.MonsterEntity;
	
	public class lingjiaojian extends ArmObject
	{
		private var speed:int ;
		private var endP:Number = 0;
		private var range:int = 3000;
		private var entitys:Array = [];
		private var curHurt:int;
		private var sx:Number;
		private var sy:Number;
		public function lingjiaojian(tPoint:Point,_level:int,_isleft:Boolean)
		{
			
			super(tPoint,1,_level,_isleft);
			
			var bPoint:Point = rule.heroEntity.attackPoint;
			var r:Number = Math.atan2((tPoint.y - bPoint.y),(tPoint.x-bPoint.x));
			
			
			armSurface = new MovieClip(Game.assets.getTextures("lingjiaojian"));
			addChild(armSurface);
			Starling.juggler.add(armSurface as MovieClip);
			
			armSurface.pivotX = armSurface.width;
			armSurface.pivotY =  armSurface.height/2;
			
			armSurface.scaleX  = _isleft?rule.cScale*0.5:-rule.cScale*0.5;
			armSurface.scaleY = rule.cScale*0.5;
			
			armSurface.rotation = r;
			
			speed = 5 *rule.cScale;
			sx = speed * Math.cos(r);
			sy = speed * Math.sin(r);
			
			x = bPoint.x;
			y = bPoint.y;
			
			rectW = armSurface.width /3;
			rectH = armSurface.height/2;
			
			var image:Image= new Image(Game.assets.getTexture("PanelRenderSkin"));
			image.width = rectW;
			image.height = rectH;
			addChildAt(image,0);
			image.x = -rectW;
			image.y = -rectH/2;
			
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
				curTarget.beAttacked(curHurt,Game.assets.getTexture("skillIcon/lingjiaojian"));
			}
		}
		
	}
}
