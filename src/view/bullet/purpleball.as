package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	import view.entity.GameEntity;
	import view.entity.SoldierEntity;
	
	public class purpleball extends ArmObject
	{
		private var speed:int = 10*BattleRule.cScale;
		private var Range:int = 100;
		public function purpleball(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean)
		{
			armSurface = new MovieClip(Game.assets.getTextures("purpleball"));
			armSurface.scaleX = _isleft?BattleRule.cScale*0.6:-BattleRule.cScale*0.8;
			armSurface.scaleY = BattleRule.cScale*0.8;
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
			
			addChild(armSurface);
			armSurface.x = _isleft?-armSurface.width/2:armSurface.width/2;
			armSurface.y = -armSurface.height/2;
			Starling.juggler.add(armSurface as MovieClip);
		}
		private var curTarget:GameEntity;
		override public function refresh():void
		{
			curTarget = isLeft?rule.monsterVec[0]:rule.soldierVec[0];
			if(curTarget){
				if(isLeft){
					x += speed;
					if(x > curTarget.x){
						attack();
					}
				}else{
					x -= speed;
					if(x < curTarget.x){
						attack();
					}
				}
			}else{
				dispose();
			}
			
		}
		private function gethurt():int 
		{
			return Math.round(hurt*(1*level/10+1));
		}
		override public function attack():void
		{
			if(curTarget){
				playSound();
				curTarget.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/purpleball"));
				var secTarget:GameEntity = isLeft?rule.monsterVec[1]:rule.soldierVec[1];
				if(secTarget is SoldierEntity && Math.abs(secTarget.x - curTarget.x)<Range*BattleRule.cScale){
					curTarget = secTarget;
					curTarget.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/purpleball"));
					secTarget = isLeft?rule.monsterVec[2]:rule.soldierVec[2];
					if(secTarget is SoldierEntity && Math.abs(secTarget.x - curTarget.x)<Range*BattleRule.cScale){
						curTarget.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/purpleball"));
					}
					
				}
			}
			dispose();
		}
		override protected function get soundName():String
		{
			return "jiguang"
		}
		
		override public function dispose():void
		{
			Starling.juggler.remove(armSurface as MovieClip);
			removeFromParent();
			super.dispose();
		}
		
	}
}


