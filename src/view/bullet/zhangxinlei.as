package view.bullet
{
	import flash.geom.Point;
	
	import gameconfig.Configrations;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	import view.entity.GameEntity;
	import view.entity.HeroEntity;
	import view.entity.MonsterEntity;

	public class zhangxinlei extends ArmObject
	{
		private var range:int = 400;
		private var speed:int = 0;
		private var sx:Number;
		private var sy:Number;
		public function zhangxinlei(tPoint:Point,_level:int,_isleft:Boolean)
		{
			var curHurt:int = Configrations.hurt31001Arr[_level];
			super(tPoint,curHurt,_level,_isleft);
			
			var bPoint:Point = rule.heroEntity.attackPoint;
			var r:Number = Math.atan2((tPoint.y - bPoint.y),(tPoint.x-bPoint.x));
			
			armSurface = new MovieClip(Game.assets.getTextures("zhangxinlei"));
			armSurface.scaleX = armSurface.scaleY = rule.cScale/3;
			
			addChild(armSurface);
			armSurface.x = -armSurface.width/2;
			armSurface.y = -armSurface.height/2;
			
			speed = 10 *rule.cScale;
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
		
		private function inRange(entity:GameEntity):Boolean
		{
			var nP:Point = new Point(entity.x - x,entity.y-y);
			if(nP.length< range*rule.cScale){
				return true
			}
			return false;
		}
		
		private function move():void
		{
			x += sx;
			y += sy;
			range -= speed;
		}
		
		override public function attack():void
		{
			if(curTarget){
				// 标记
				var bL:int = heroData.getSkillItem("31003").count;
				var blRate:Number = Configrations.skill31003Point[bL];
				
				playSound();
				curTarget.beAttacked(hurt,Game.assets.getTexture("skillIcon/zhangxinlei"));
				if(blRate >0){
					curTarget.beBuffed("31003");
				}
				//范围 
				var sL:int = heroData.getSkillItem("31002").count;
				if(sL >=1){
					var slRate:Number = Configrations.skill31002Point[sL];
					var newH:int = Math.floor(slRate*hurt);
					var vec:Array = rule.monsterVec;
					
					for each(var monster:GameEntity in vec){
						if(!monster.isDead && inRange(monster) && monster != curTarget){
							monster.beAttacked(newH,Game.assets.getTexture("skillIcon/huimielieyan"));
							monster.beBuffed("31003");
						}
					}
					
				}
				
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


