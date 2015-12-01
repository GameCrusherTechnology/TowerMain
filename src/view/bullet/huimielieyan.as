package view.bullet
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	
	import view.entity.GameEntity;
	
	public class huimielieyan extends ArmObject
	{
		private const RANGE:int = 250;
		public function huimielieyan(tPoint:Point,_level:int,_isleft:Boolean)
		{
			
			super(tPoint,1,_level,_isleft);
			
			armSurface = new MovieClip(Game.assets.getTextures("huimielieyan"));
			armSurface.scaleX = rule.cScale;
			armSurface.scaleY = rule.cScale;
			
			addChild(armSurface);
			armSurface.x = -armSurface.width/2;
			armSurface.y = -armSurface.height/2;
			
			Starling.juggler.add(armSurface as MovieClip);
			armSurface.addEventListener(Event.COMPLETE,onEnterComplete);
			
			attack();
		}
		
		private function onEnterComplete(e:Event):void
		{
			armSurface.removeEventListener(Event.COMPLETE,onEnterComplete);
			removeFromParent();
			Starling.juggler.remove(armSurface as MovieClip);
			super.dispose();
		}
		
		private function gethurt():int 
		{
			return Math.round(hurt*(1*level/10+1.5));
		}
		override protected function get soundName():String
		{
			return "lieyan"
		}
		override public function attack():void
		{
			var targetSoldier:GameEntity ;
			var targets:Array;
			var tween:Tween;
			playSound();
			targets = rule.monsterVec;
			for each(targetSoldier in targets){
				if(!targetSoldier.isDead && targetSoldier.beInRound(curRect)){
					targetSoldier.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/huimielieyan"));
				}
			}
		}
		
		override protected function get curRect():Rectangle
		{
			if(!rect){
				rect = new Rectangle(x-rectW/2,y-rectH/2,rectW,rectH);
			}else{
				rect.x = x-rectW/2;
				rect.y = y-rectH/2;
			}
			return rect;
		}
		
	}
}

