package model.entity
{
	import flash.geom.Rectangle;
	
	import controller.SpecController;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.SoldierItemSpec;
	
	import view.bullet.Sword;

	public class EntityItem
	{
		protected var curMode:String;
		public function EntityItem(data:Object,mode:String = Configrations.Battle_Normal)
		{
			curMode = mode;
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in EntityItem: EntityItem["+str+"]="+data[str]);
				}
			}
			init();
			
		}
		
		private function init():void
		{
			curLife = totalLife;
		}
		
		public var id:String;
		public var level:int;
		
		private var _spec:SoldierItemSpec;
		public function get entitySpec():SoldierItemSpec
		{
			if(!_spec){
				_spec = SpecController.instance.getItemSpec(id) as SoldierItemSpec;
			}
			return _spec;
		}
		
		public var curLife:int;
		public function get totalLife():int
		{
			var l:int = entitySpec.baseLife + level * entitySpec.lifeUp;;
			if(curMode == Configrations.Battle_Easy){
				l = Math.floor(l*0.8);
			}else if(curMode == Configrations.Battle_Hard){
				l = Math.floor(l*1.2);
			}
			return l;
		}
		
		public function get texturecls():String
		{
			return entitySpec.name;
		}
		
		public function get range():Number
		{
			return entitySpec.range;
		}
		
		public function get attackCycle():int
		{
			return entitySpec.attackCycle;
		}
		
		public function get armClass():Class {
			return  Sword;
		}
		
		
		public function get hurtPoint():int
		{
			var h:int =  entitySpec.baseAttack + level * entitySpec.attackUp;
			if(curMode == Configrations.Battle_Easy){
				h = Math.floor(h*0.8);
			}else if(curMode == Configrations.Battle_Hard){
				h = Math.floor(h*1.2);
			}
			return h;
		}
		
		public function beAttack(p:int):void
		{
			curLife -=p;
			curLife = Math.max(0,curLife);
		}
		
		public function beHealth(p:int):void
		{
			curLife = Math.min(totalLife,curLife+p);
		}
			
			
		
		public function get isDead():Boolean
		{
			return curLife <=0;
		}
			
		
	}
}