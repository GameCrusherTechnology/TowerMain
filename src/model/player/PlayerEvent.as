package model.player
{
	import starling.events.Event;

	public class PlayerEvent extends Event
	{
		public static const CoinChange:String = "coin_change";
		public static const GemChange:String = "gem_change";
		public function PlayerEvent(type:String)
		{
			super(type);
		}
	}
}