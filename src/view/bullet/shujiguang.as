package view.bullet
{
	import flash.geom.Point;
	
	import gameconfig.Configrations;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	
	import view.entity.GameEntity;
	
	public class shujiguang extends ArmObject
	{
		private var oldtargets:Array = [];
		public function shujiguang(tPoint:Point,_level:int,_isleft:Boolean)
		{
			var newH:int = Configrations.hurt30007Arr[_level];
			super(tPoint,newH,_level,_isleft);
			
			armSurface = new MovieClip(Game.assets.getTextures("shujiguang"));
			armSurface.scaleX= armSurface.scaleY = rule.cScale;
			
			addChild(armSurface);
			armSurface.x = -armSurface.width/2;
			armSurface.y = -armSurface.height/4*3;
			
			var tar:GameEntity = findTarget();
			if(!tar){
				dispose();
			}
			
			Starling.juggler.add(armSurface as MovieClip);
			armSurface.addEventListener(Event.COMPLETE,onEnterComplete);
			
		}
		private function onEnterComplete(e:Event):void
		{
			var tar:GameEntity = findTarget();
			if(!tar){
				dispose();
			}
		}
		
		
		private function gethurt():int 
		{
			return Math.round(hurt*(1*level/10+1));
		}
		private function findTarget():GameEntity
		{
			var targetSoldier:GameEntity ;
			var targets:Array  = rule.monsterVec;
			for (var i:int = 0;i<targets.length;i++){
				targetSoldier = targets[i] ;
				if(targetSoldier && oldtargets.indexOf(targetSoldier)<=-1){
					x = targetSoldier.x;
					y = targetSoldier.y;
					targetSoldier.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/shujiguang"));
					oldtargets.push(targetSoldier);
					checkSkill(targetSoldier);
					playSound();
					return targetSoldier;
				}
			}
			return null;
		}
		
		private function checkSkill(tar:GameEntity):void
		{
			var l:int = heroData.getSkillItem("30008").count;
			if(l>0){
				tar.beBuffed("30008");
			}
		}
		override protected function get soundName():String
		{
			return "jiguang"
		}
		override public function dispose():void
		{
			Starling.juggler.remove(armSurface as MovieClip);
			armSurface.removeEventListener(Event.COMPLETE,onEnterComplete);
			removeFromParent();
			super.dispose();
		}
		
	}
}

