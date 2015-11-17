package view.render
{
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.MapItemSpec;
	import model.item.OwnedItem;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class PieceRender extends DefaultListItemRenderer
	{
		private var renderscale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		
		public function PieceRender()
		{
			super();
			renderscale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var itemList:List;
		
		private var item:OwnedItem;
		
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			item = value as OwnedItem;
			if(item ){
				if(container){
					container.removeFromParent(true);
				}
				configLayout();
			}
		}
		
		
		
		private function configLayout():void
		{
			
			var hero:GamePlayer = GameController.instance.currentHero;
			var myLevel:int = hero.vipLevel;
			
			container = new Sprite;
			
			var skin:Image ;
			skin= new Image(Game.assets.getTexture("PanelRenderSkin"));
			skin.width = renderwidth;
			skin.height = renderHeight;
			container.addChild( skin);
			
			var icon:Image = new Image(Game.assets.getTexture("NewHeroIcon"));
			icon.width = renderwidth*0.8;
			icon.scaleY = icon.scaleX;
			container.addChild(icon);
			icon.x = renderwidth/2 - icon.width/2;
			icon.y = renderHeight/2 -icon.height/2;
			
			var textSkin:Image = new Image(Game.assets.getTexture( "TitleTextSkin"));
			textSkin.width = renderwidth*0.8;
			textSkin.x = renderwidth*0.1;
			textSkin.y = renderHeight *0.8;
			textSkin.height = renderHeight*0.2;
			container.addChild( textSkin);
			
			var nameText:TextField = FieldController.createNoFontField(400,renderHeight*0.2,LanguageController.getInstance().getString(item.item_id),0xffffff);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild( nameText);
			nameText.x = renderwidth/2 - nameText.width/2;
			nameText.y = renderHeight *0.8;
			
			
			var icon1:Image = new Image(Game.assets.getTexture("giftboxIcon"));
			icon1.width = renderwidth*0.5;
			icon1.scaleY = icon1.scaleX;
			container.addChild(icon1);
			icon1.x = renderwidth/2 - icon1.width/2;
			icon1.y = renderHeight/2 -icon1.height/2;
			
			var icon2:Image = new Image(Game.assets.getTexture("RankIcon"));
			icon2.width = renderwidth*0.3;
			icon2.scaleY = icon2.scaleX;
			container.addChild(icon2);
			icon2.x = renderwidth - icon2.width;
			icon2.y = 0;
			
			addChild(container);
			
		}
		
		
	}
}

