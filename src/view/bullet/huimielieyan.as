package view.bullet
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import gameconfig.Configrations;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	
	import view.entity.GameEntity;
	
	public class huimielieyan extends ArmObject
	{
		private const range:int = 400;
		
		public function huimielieyan(tPoint:Point,_level:int,_isleft:Boolean)
		{
			var curHurt:int = Configrations.hurt31004Arr[_level];
			super(tPoint,curHurt,_level,_isleft);
			
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
		
		override protected function get soundName():String
		{
			return "lieyan"
		}
		override public function attack():void
		{
			var targetSoldier:GameEntity ;
			var targets:Array;
			playSound();
			targets = rule.monsterVec;
			
			//燃烧
			var sL:int = heroData.getSkillItem("31005").count;
			var slRate:Number = Configrations.skill31005Point[sL];
			var slHurt:int = Math.floor(slRate*hurt);
			
			
			for each(targetSoldier in targets){
				if(!targetSoldier.isDead && inRange(targetSoldier)){
					targetSoldier.beAttacked(hurt,Game.assets.getTexture("skillIcon/huimielieyan"));
					if(slHurt > 0){
						targetSoldier.beBuffed("31005",slHurt);
					}
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

