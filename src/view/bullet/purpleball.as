package view.bullet
{
	import flash.geom.Point;
	
	import gameconfig.Configrations;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	import view.entity.GameEntity;
	import view.entity.MonsterEntity;
	
	public class purpleball extends ArmObject
	{
		private var arrowSpeed:int;
		private var range:int =2000;
		private var showFrame:int = 20;
		private var sx:Number;
		private var sy:Number;
		public function purpleball(_fromPoint:Point,_hurt:int,_rotate:Number = 0)
		{
			super(_fromPoint,_hurt,1,true);
			
			armSurface = new MovieClip(Game.assets.getTextures("purpleball"));
			
			armSurface.pivotX = armSurface.width;
			armSurface.pivotY =  armSurface.height/2;
			
			armSurface.scaleY = armSurface.scaleX = rule.cScale*0.3;
			
			armSurface.rotation = 0;
			
			
			arrowSpeed = 15 *rule.cScale;
			_rotate = 0;
			rectW = armSurface.width;
			rectH = armSurface.height;
			
			Starling.juggler.add(armSurface as MovieClip);
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
					dispose();
				}
			}else{
				showFrame -- ;
			}
		}
		
		private function findTarget():void
		{
			var entity:GameEntity = rule.monsterVec[0];
			if(entity){
				rotation = Math.atan2((entity.y - y),(entity.x-x));
			}
			sx = arrowSpeed * Math.cos(rotation);
			sy = arrowSpeed * Math.sin(rotation);
		}
		private function move():void
		{
			findTarget();
			x += sx;
			y += sy;
			range -= arrowSpeed;
		}
		
		override public function attack():void
		{
			if(curTarget){
				playSound();
				curTarget.beAttacked(hurt,Game.assets.getTexture("skillIcon/arrow"),"attack");
				//眩晕 
				var sL:int = heroData.getSkillItem("30003").count;
				var slRate:Number = Configrations.skillP30003Rate[sL];
				var bool:Boolean = Math.random()<= slRate;
				if(bool){
					curTarget.beBuffed("30003");
				}
				
				//吸血
				var xL:int = heroData.getSkillItem("30009").count;
				var xlRate:Number = Configrations.skillP30009Point[xL];
				var n:int = Math.floor(xlRate * hurt);
				if(n > 0){
					rule.heroEntity.beBuffed("30009",n);
				}
				
			}
			dispose();
		}
		
		override protected function get soundName():String
		{
			return "arrow"
		}
		override public function dispose():void
		{
			Starling.juggler.remove(armSurface as MovieClip);
			removeFromParent();
			super.dispose();
		}
		
	}
}


