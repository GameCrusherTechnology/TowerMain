package view.bullet
{
	import flash.geom.Point;
	
	import starling.display.Image;
	
	import view.entity.GameEntity;
	import view.entity.MonsterEntity;

	public class HeroArrow extends ArmObject
	{
		private var arrowSpeed:int = 20*rule.cScale;
		private var range:int =600;
		private var rotate:Number;
		private var sx:Number;
		private var sy:Number;
		public function HeroArrow(_fromPoint:Point,_hurtV:int,_level:int,_rotate:Number)
		{
			rotate = _rotate;
			armSurface = new Image(Game.assets.getTexture("SimpleArrow"));
			armSurface.scaleX = rule.cScale*0.5;
			armSurface.scaleY = rule.cScale;
			armSurface.rotation = _rotate;
			super(_fromPoint,_hurtV,_level,true);
			addChild(armSurface);
			armSurface.x = -armSurface.width/2;
			
			sx = arrowSpeed * Math.cos(rotate);
			sy = arrowSpeed * Math.sin(rotate);
			
		}
		
		private var curTarget:GameEntity;
		override public function refresh():void
		{
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


