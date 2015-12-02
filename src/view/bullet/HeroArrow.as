package view.bullet
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import gameconfig.Configrations;
	
	import model.item.HeroData;
	
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
			removeFromParent();
			super.dispose();
		}
		
	}
}


