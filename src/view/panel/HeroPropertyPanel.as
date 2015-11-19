package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	
	import view.render.PropertyRender;
	
	public class HeroPropertyPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		public function HeroPropertyPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			panelScale = Configrations.ViewScale;
			
			var blackSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackSkin"),new Rectangle(2,2,60,60)));
			addChild(blackSkin);
			blackSkin.alpha = 0.2;
			blackSkin.width = panelwidth;
			blackSkin.height = panelheight;
			
			var backSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("ListSkin"),new Rectangle(15,16,300,300)));
			addChild(backSkin);
			backSkin.width = panelwidth;
			backSkin.height = panelheight;
			backSkin.x = 0;
			backSkin.y = 0;
			
			var titleSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelTitle"),new Rectangle(15,14,70,20)));
			addChild(titleSkin);
			titleSkin.width = backSkin.width;
			titleSkin.height = panelheight*0.08;
			titleSkin.x =backSkin.x;
			titleSkin.y = 0;
			
			var titleText:TextField = FieldController.createNoFontField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("hero")+" "+LanguageController.getInstance().getString("property"),0x000000,titleSkin.height*0.6,true);
			addChild(titleText);
			titleText.y =  0;
			
			configModeContainer();
			
			var cancleBut:Button = new Button();
			cancleBut.defaultSkin = new Image(Game.assets.getTexture("R_button"));
			cancleBut.label = LanguageController.getInstance().getString("cancel");
			cancleBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
			cancleBut.paddingLeft = cancleBut.paddingRight = 20*panelScale;
			cancleBut.height = panelheight*0.08;
			addChild(cancleBut);
			cancleBut.validate();
			cancleBut.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			cancleBut.x = panelwidth/2 - cancleBut.width - panelwidth*0.05;
			cancleBut.y = panelheight*0.9;
			
			var confirmBut:Button = new Button();
			confirmBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			confirmBut.label = LanguageController.getInstance().getString("confirm");
			confirmBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
			confirmBut.paddingLeft = confirmBut.paddingRight = 20*panelScale;
			confirmBut.height = panelheight*0.08;
			addChild(confirmBut);
			confirmBut.validate();
			confirmBut.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			confirmBut.x = panelwidth/2 + panelwidth*0.05;
			confirmBut.y = panelheight*0.9;
			
			var backBut:Button = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = 0;
			backBut.y = 0;
			backBut.addEventListener(Event.TRIGGERED,onTriggerOut);
			
		}
		private function configModeContainer():void
		{
			const listLayout1: TiledRowsLayout= new TiledRowsLayout();
			listLayout1.tileHorizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout1.tileVerticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
			listLayout1.verticalGap = panelheight *0.05;
			listLayout1.horizontalGap = panelwidth * 0.05;
			listLayout1.paging = TiledRowsLayout.PAGING_NONE;
			listLayout1.useSquareTiles = false;
			
			modeList = new List();
			modeList.layout = listLayout1;
			modeList.dataProvider = new ListCollection(["health","power","agility","wisdom","crit","money"]);
			modeList.itemRendererFactory =function tileListItemRendererFactory():PropertyRender
			{
				var renderer:PropertyRender = new PropertyRender();
				renderer.defaultSkin = new Image(Game.assets.getTexture("SelectRenderSkin"));
				renderer.width =  panelwidth *0.35;
				renderer.height =  panelheight *0.2;
				return renderer;
			}
			
			modeList.width =  panelwidth*0.8;
			modeList.height =  panelheight*0.7;
			modeList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			addChild(modeList);
			modeList.x = panelwidth/2 - modeList.width/2;
			modeList.y = panelheight*0.15;
			modeList.addEventListener(Event.CHANGE,onModeChange);
			
		}
		private var modeList:List;
		private function onModeChange(e:Event):void
		{
			
		}
		
		
		
		private function onTriggerConfirm(e:Event):void
		{
			dispose();
		}
		private function onTriggerOut(e:Event):void
		{
			dispose();
		}
		override public function dispose():void
		{
			GameController.instance.showWorldScene();
			removeFromParent();
			super.dispose();
		}
		
	}
}

