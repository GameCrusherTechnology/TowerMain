package view.render
{
	import controller.GameController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.SkillItemSpec;
	import model.item.TreasureItem;
	import model.player.GameUser;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class SkillRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderheight:Number;
		public function SkillRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var item:SkillItemSpec;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderheight = height;
			super.data = value;
			item = value as SkillItemSpec;
			if(item){
				if(container){
					container.removeFromParent(true);
				}
				configContainer();
			}
		}
		
		private function configContainer():void
		{
			container = new Sprite;
			addChild(container);
			
			var icon:Image = new Image(item.iconTexture);
			icon.width = renderwidth*0.8;
			icon.scaleY = icon.scaleX;
			container.addChild(icon);
			icon.x = renderwidth*0.1;
			icon.y = renderheight*0.1;
			
		}
		
		private function get user():GameUser
		{
			return GameController.instance.localPlayer;
		}
	}
}