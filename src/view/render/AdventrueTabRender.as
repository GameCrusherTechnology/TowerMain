package view.render
{
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.MapItemSpec;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class AdventrueTabRender extends DefaultListItemRenderer
	{
		private var renderscale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		
		public function AdventrueTabRender()
		{
			super();
			renderscale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var itemList:List;
		
		private var mapSpec:MapItemSpec;
		
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			mapSpec = value as MapItemSpec;
			if(mapSpec ){
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
			
			var icon:Image = new Image(mapSpec.iconTexture);
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
			
			var nameText:TextField = FieldController.createNoFontField(400,renderHeight*0.2,mapSpec.cname,0xffffff);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild( nameText);
			nameText.x = renderwidth/2 - nameText.width/2;
			nameText.y = renderHeight *0.8;
			
			addChild(container);
			
		}
		
		
	}
}
