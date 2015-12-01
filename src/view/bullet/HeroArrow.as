package view.bullet
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	
	import view.entity.GameEntity;
	import view.entity.MonsterEntity;

	public class HeroArrow extends ArmObject
	{
		private var arrowSpeed:int;
		private var range:int =600;
		private var showFrame:int = 20;
		private var sx:Number;
		private var sy:Number;
		public function HeroArrow(_fromPoint:Point,_hurt:int,_rotate:Number = 0)
		{
			super(_fromPoint,_hurt,1,true);
			
			armSurface = new Image(Game.assets.getTexture("SimpleArrow"));
			
			armSurface.pivotX = armSurface.width;
			armSurface.pivotY =  armSurface.height/2;
			
			armSurface.scaleX = rule.cScale*0.3;
			armSurface.scaleY = rule.cScale;
			
			armSurface.rotation = _rotate;
			
			
			arrowSpeed = 5 *rule.cScale;
			sx = arrowSpeed * Math.cos(_rotate);
			sy = arrowSpeed * Math.sin(_rotate);
			
			rectW = armSurface.width;
			rectH = armSurface.height;
			
//			var image:Image= new Image(Game.assets.getTexture("PanelRenderSkin"));
//			image.width = armSurface.width;
//			image.height = armSurface.height;
//			addChild(image);
//			image.x = -image.width;
//			image.y = -image.height/2;
			
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


