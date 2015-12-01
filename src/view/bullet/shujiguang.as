package view.bullet
{
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	
	import view.entity.GameEntity;
	
	public class shujiguang extends ArmObject
	{
		private var range:int = 300;
		public function shujiguang(tPoint:Point,_level:int,_isleft:Boolean)
		{
			
			super(tPoint,1,_level,_isleft);
			
			armSurface = new MovieClip(Game.assets.getTextures("shujiguang"));
			armSurface.scaleX= armSurface.scaleY = rule.cScale;
			
			addChild(armSurface);
			armSurface.x = -armSurface.width/2;
			armSurface.y = -armSurface.height/4*3;
			
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
			
		}
		private function onAdd(e:Event):void
		{
			Starling.juggler.add(armSurface as MovieClip);
			armSurface.addEventListener(Event.COMPLETE,onEnterComplete);
		}
		private function onEnterComplete(e:Event):void
		{
			armSurface.removeEventListener(Event.COMPLETE,onEnterComplete);
			Starling.juggler.remove(armSurface as MovieClip);
			findTarget();
			dispose();
		}
		
		private function inRange(entity:GameEntity):Boolean
		{
			var l:Number = fromPoint.subtract(entity.posPoint).length;
			if(l< range*rule.cScale){
				return true
			}
			return false;
		}
		
		private function gethurt():int 
		{
			return Math.round(hurt*(1*level/10+1));
		}
		private function findTarget():void
		{
			playSound();
			var targetSoldier:GameEntity ;
			var targets:Array;
				targets = rule.monsterVec;
			for (var i:int = 0;i<targets.length;i++){
				targetSoldier = targets[i] ;
				if(targetSoldier && inRange(targetSoldier)){
					targetSoldier.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/shujiguang"));
				}
			}
		}
		
		override protected function get soundName():String
		{
			return "jiguang"
		}
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
		
	}
}

