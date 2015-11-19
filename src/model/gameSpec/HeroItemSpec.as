package model.gameSpec
{
	import starling.textures.Texture;

	public class HeroItemSpec extends SoldierItemSpec
	{
		public function HeroItemSpec(data:Object)
		{
			super(data);
		}
		
		override public function get iconTexture():Texture
		{
			return Game.assets.getTexture(name+"Icon");
		}
		
	}
}