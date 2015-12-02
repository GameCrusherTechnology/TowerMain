package view.bullet
{
	import flash.geom.Point;
	
	import gameconfig.Configrations;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	import view.entity.GameEntity;
	import view.entity.HeroEntity;
	import view.entity.MonsterEntity;
	
	public class longjuanfeng extends ArmObject
	{
		private var speed:int = 5;
		private var range:int = 500;
		private var moverange:int = 1200;
		private var targets:Array = [];
		private var sx:Number;
		private var sy:Number;
		public function longjuanfeng(tPoint:Point,_level:int,_isleft:Boolean)
		{
			var curHurt:int = Configrations.hurt31007Arr[_level];
			super(tPoint,curHurt,_level,_isleft);
			
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
			
			var sL:int = heroData.getSkillItem("31009").count;
			if(sL > 0){
				var slRate:Number = Configrations.skill31009Point[sL];
				rainHurt = Math.floor(slRate * hurt);
			}
			
			Starling.juggler.add(armSurface as MovieClip);
			playSound();
		}
		
		private var rainHurt:int;
		
		private var curTarget:GameEntity;
		override public function refresh():void
		{
			move();
			if(moverange > 0 ){
				findTarget();
			}else{
				end();
			}
			
			pullEntitys();
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
					if(!heroEntity.isDead && inRange(heroEntity)){
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
			moverange -= speed;
		}
		
		private function end():void
		{
			removeFromParent(true);
			Starling.juggler.remove(armSurface as MovieClip);
			targets = [];
			curTarget = null;
			
			var entity:GameEntity;
			for each(entity in rangeTargets){
				entity.setSpeed();
			}
			
			
			super.dispose();
		}
		override protected function get soundName():String
		{
			return "longjuanfeng"
		}
		
		private function inRange(entity:GameEntity):Boolean
		{
			var nP:Point = new Point(entity.x - x,entity.y-y);
			if(nP.length< range*rule.cScale){
				return true
			}
			return false;
		}
		
		private var rangeTargets:Array = [];
		private var rainCount:int = 30;
		private function pullEntitys():void
		{
			if(rainHurt){
				rainCount --;
				if(rainCount <=0){
					rainCount = 30;
					rule.addArm(new LiuxingyuArm(new Point(x,y),rainHurt,rangeTargets));
				}
			}
			var entity:GameEntity;
			var px:Number;
			var py:Number;
			var r:Number;
			for each(entity in rangeTargets){
				r = Math.atan2((y - entity.y),(x-entity.x));
				px = speed * Math.cos(r)*1.5;
				py = speed * Math.sin(r)*1.5;
				entity.x += px;
				entity.y += py;
				
			}
		}
		override public function attack():void
		{
			if(curTarget ){
				
				//吸引
				var sL:int = heroData.getSkillItem("31008").count;
				var slRate:Number = Configrations.skill31008Rate[sL];
				var bool:Boolean = Math.random()<= slRate;
				if(bool){
					rangeTargets.push(curTarget);
				}
				
				targets.push(curTarget);
				playSound();
				curTarget.beAttacked(hurt,Game.assets.getTexture("skillIcon/longjuanfeng"));
			}
		}
		
	}
}

