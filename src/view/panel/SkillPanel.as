package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledRowsLayout;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.item.HeroData;
	import model.player.GameUser;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	
	import view.render.SkillBigRender;
	
	public class SkillPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var titleText:TextField;
		private var panelScale:Number;
		private var backBut:Button;
		private var itemList:List;
		public function SkillPanel()
		{
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			panelScale = Configrations.ViewScale;
			
			var blackSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackSkin"),new Rectangle(2,2,60,60)));
			addChild(blackSkin);
			blackSkin.alpha = 0.5;
			blackSkin.width = panelwidth;
			blackSkin.height = panelheight;
			
			var backSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("ListSkin"),new Rectangle(15,16,300,300)));
			addChild(backSkin);
			backSkin.width = panelwidth*0.9;
			backSkin.height = panelheight;
			backSkin.x = panelwidth*0.05;
			backSkin.y = 0;
			
			var titleSkin:Scale9Image = new Scale9Image(Configrations.PanelTitleSkinTexture);
			addChild(titleSkin);
			titleSkin.width = panelwidth*0.9;
			titleSkin.height = panelheight*0.08;
			titleSkin.x = panelwidth*0.05;
			titleSkin.y = 0;
			
			titleText = FieldController.createNoFontField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("skill"),0xffffff,0,true);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			configList();
			
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.05;
			backBut.y = 0;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
			
			user.addEventListener(HeroData.HEROSKILLCHANGE,onSkillChange);
			
		}
		private function configList():void
		{
			if(itemList){
				itemList.removeFromParent(true);
				itemList = null;
			}
			itemList = new List();
			
			const listLayout:HorizontalLayout = new HorizontalLayout();
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.gap= panelwidth *0.02;
			
			itemList.layout = listLayout;
			itemList.dataProvider = new ListCollection(["arrow","magic"]);
			itemList.itemRendererFactory =function tileListItemRendererFactory():SkillBigRender
			{
				var renderer:SkillBigRender = new SkillBigRender();
				renderer.defaultSkin = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"),new Rectangle(12,12,40,40)));
				renderer.width = panelwidth *0.4;
				renderer.height = panelheight *0.7;
				return renderer;
			}
			itemList.width =  panelwidth*0.84;
			itemList.height =  panelheight *0.7;
			itemList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			itemList.horizontalScrollPolicy = List.SCROLL_POLICY_OFF;
			addChild(itemList);
			itemList.x = panelwidth*0.08;
			itemList.y = panelheight*0.1;
			itemList.selectedIndex = -1;
		}
		
		private function onSkillChange(e:Event):void
		{
			titleText.text = LanguageController.getInstance().getString("skill") + " ×"+user.heroData.skillPoints;
			configList();
		}
		
		private function onTriggerBack(e:Event):void
		{
			dispose();
		}
		
		private function get user():GameUser
		{
			return GameController.instance.localPlayer;
		}
		override public function dispose():void
		{
			user.removeEventListener(HeroData.HEROSKILLCHANGE,onSkillChange);
			removeFromParent();
			DialogController.instance.hideSkillMPanel();
			super.dispose();
		}
	}
}
