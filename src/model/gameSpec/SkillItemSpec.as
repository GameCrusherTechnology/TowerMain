package model.gameSpec
{
	import starling.textures.Texture;

	public class SkillItemSpec extends ItemSpec
	{
		public function SkillItemSpec(data:Object)
		{
			super(data);
		}
		
		public var buffName:String;
		
		override public function get iconTexture():Texture
		{
			return Game.assets.getTexture("skillIcon/" + name);
		}
	}
}