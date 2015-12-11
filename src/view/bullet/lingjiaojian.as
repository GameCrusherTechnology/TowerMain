package view.bullet
{
	import flash.geom.Point;
	
	import gameconfig.Configrations;
	
	import starling.core.Starling;
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
		private var sx:Number;
		private var sy:Number;
		private var curR:Number;
		public function lingjiaojian(tPoint:Point,_level:int,_isleft:Boolean)
		{
			var curhurt:int = Configrations.hurt30004Arr[_level];
			super(tPoint,curhurt,_level,_isleft);
			
			var bPoint:Point = rule.heroEntity.attackPoint;
			curR = Math.atan2((tPoint.y - bPoint.y),(tPoint.x-bPoint.x));
			
			
			armSurface = new MovieClip(Game.assets.getTextures("jiguangjian"));
			addChild(armSurface);
			Starling.juggler.add(armSurface as MovieClip);
			
			armSurface.pivotX = armSurface.width;
			armSurface.pivotY =  armSurface.height/2;
			
			armSurface.scaleX  = _isleft?rule.cScale*0.3:-rule.cScale*0.3;
			armSurface.scaleY = rule.cScale*0.5;
			
			armSurface.rotation = curR;
			
			speed = 20 *rule.cScale;
			sx = speed * Math.cos(curR);
			sy = speed * Math.sin(curR);
			
			x = bPoint.x;
			y = bPoint.y;
			
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
				curTarget.beAttacked(hurt,Game.assets.getTexture("skillIcon/lingjiaojian"));
				//fen lie
				var l:int = heroData.getSkillItem("30005").count;
				if(l>0){
					var newH:int = Math.floor(Configrations.skillP30005Point[l]*hurt);
					var curP:Point = new Point(x,y);
					rule.addArm(new lingjiaofenlie(curTarget,curP,newH,level,curR-0.2));
					rule.addArm(new lingjiaofenlie(curTarget,curP,newH,level,curR+0.2));
				}
			}
		}
		
	}
}
