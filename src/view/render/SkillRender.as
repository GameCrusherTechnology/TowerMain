package view.render
{
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.SkillItemSpec;
	import model.item.OwnedItem;
	import model.player.GameUser;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

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
			var oitem:OwnedItem = user.heroData.getSkillItem(item.item_id);
			var typeCount:int = user.heroData.getSkillTypePoint(item.type);
			var skin:Image ;
			if(typeCount >= item.typeNeed){
				skin = new Image(Game.assets.getTexture("BPanelSkin"));
			}else{
				skin = new Image(Game.assets.getTexture("DPanelSkin"));
			}
			skin.width = renderwidth;
			skin.height = renderheight;
			container.addChild(skin);
			
			var icon:Image = new Image(item.iconTexture);
			icon.width = renderwidth*0.8;
			icon.scaleY = icon.scaleX;
			container.addChild(icon);
			icon.x = renderwidth*0.1;
			icon.y = renderheight*0.1;
			
			if(typeCount < item.typeNeed){
				icon.filter = Configrations.grayscaleFilter;
			}
			
			if(oitem.count >0){
				var oText:TextField = FieldController.createNoFontField(renderwidth,renderheight*0.3,"("+oitem.count+"/"+Configrations.SKILL_MAX_LEVEL+")",0xFF3030,0,true);
				oText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(oText);
				oText.x = renderwidth *0.9 - oText.width;
				oText.y = renderheight*0.7;
			}
			
		}
		
		private function get user():GameUser
		{
			return GameController.instance.localPlayer;
		}
	}
}