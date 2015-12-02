package view.bullet
{
	import flash.geom.Point;
	
	import gameconfig.Configrations;
	
	import starling.events.Event;
	
	public class baoshe extends ArmObject
	{
		private const RANGE:int = 600;
		private const arrowRotate:Array = [[],[0,-0.3,0.3],[0,-0.2,-0.4,0.2,0.4],[0,-0.2,-0.4,-0.5,0.2,0.4,0.5],[0,-0.1,-0.2,-0.3,-0.4,0.1,0.2,0.3,0.4],[0,-0.1,-0.2,-0.3,-0.4,-0.5,0.1,0.2,0.3,0.4,0.5]];
		public function baoshe(tPoint:Point,_level:int,_isleft:Boolean)
		{
			var curHurt:int = Configrations.hurt30001Arr[_level];
			super(tPoint,curHurt,_level,_isleft);
			var rate:int = Math.round(Math.random()*4)+1;
			var arrows:Array = arrowRotate[rate];
			
			var bPoint:Point = rule.heroEntity.attackPoint;
			var r:Number = Math.atan2((tPoint.y - bPoint.y),(tPoint.x-bPoint.x));
			for each(var num:Number in arrows){
				rule.addArm(new arrow(bPoint,curHurt,_level,r+num,_isleft));
			}
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
		}
		
		private function onAdd(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			dispose();
		}
	}
}

