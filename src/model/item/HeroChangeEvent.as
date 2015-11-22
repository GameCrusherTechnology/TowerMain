package model.item
{
	import starling.events.Event;

	public class HeroChangeEvent extends Event
	{
		public static const HEROSKILLCHANGE:String = "hero_skill_change";
		public function HeroChangeEvent(type:String)
		{
			super(type);
		}
	}
}