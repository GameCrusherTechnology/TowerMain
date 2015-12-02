package view.bullet
{
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	
	import view.entity.GameEntity;
	
	public class LiuxingyuArm extends ArmObject
	{
		private var targets:Array = [];
		public function LiuxingyuArm(tPoint:Point,hurt:int,arr:Array)
		{
			targets = arr;
			super(tPoint,hurt,1);
			
			armSurface = new MovieClip(Game.assets.getTextures("liuxingyu"));
			armSurface.scaleX = armSurface.scaleY = rule.cScale*0.5;
			
			addChild(armSurface);
			
			armSurface.x = -armSurface.width/2;
			armSurface.y = -armSurface.height/3*2;
			Starling.juggler.add(armSurface as MovieClip);
			armSurface.addEventListener(Event.COMPLETE,onEnterComplete);
			
		}
		
		private function onEnterComplete(e:Event):void
		{
			attack();
			dispose();
		}
		
		
		private var curTarget:GameEntity;
		override public function attack():void
		{
			var targetSoldier:GameEntity ;
			playSound();
			for each(targetSoldier in targets){
				if(!targetSoldier.isDead){
					targetSoldier.beAttacked(hurt,Game.assets.getTexture("skillIcon/liuxingyu"));
				}
			}
		}
		
		override protected function get soundName():String
		{
			return "yunshi"
		}
		override public function dispose():void
		{
			armSurface.removeEventListener(Event.COMPLETE,onEnterComplete);
			removeFromParent();
			Starling.juggler.remove(armSurface as MovieClip);
			super.dispose();
		}
		
	}
}
