package view.bullet
{
	import flash.geom.Point;
	
	import starling.display.Image;
	
	import view.entity.GameEntity;
	import view.entity.MonsterEntity;

	public class HeroArrow extends ArmObject
	{
		private var arrowSpeed:int;
		private var range:int =600;
		private var showFrame:int = 20;
		private var rotate:Number;
		private var sx:Number;
		private var sy:Number;
		public function HeroArrow(_fromPoint:Point,_hurtV:int,_rotate:Number = 0)
		{
			rotate = _rotate;
			super(_fromPoint,_hurtV,1,true);
			
			armSurface = new Image(Game.assets.getTexture("SimpleArrow"));
			armSurface.scaleX = rule.cScale*0.5;
			armSurface.scaleY = rule.cScale;
			
			armSurface.rotation = _rotate;
			
			if(_rotate > 0){
				armSurface.y =  -armSurface.height;
			}else{
				armSurface.y =  armSurface.height;
			}
			armSurface.x = - armSurface.width;
			
			
			arrowSpeed = 20 *rule.cScale;
			sx = arrowSpeed * Math.cos(rotate);
			sy = arrowSpeed * Math.sin(rotate);
			
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
					var vec:Vector.<MonsterEntity> = rule.monsterVec;
					var entity:MonsterEntity;
					for each(entity in vec){
						if(!entity.isDead && entity.beInRound(x,y)){
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
				curTarget.beAttacked(hurt,Game.assets.getTexture("skillIcon/arrow"),"attack");
			}
			dispose();
		}
		
		override protected function get soundName():String
		{
			return "arrow"
		}
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
		
	}
}


