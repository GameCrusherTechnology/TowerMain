package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.LocalData;
	
	import model.gameSpec.ItemSpec;
	import model.item.TreasureItem;
	import model.player.GameUser;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	
	import view.render.SpecialItemRender;
	import view.render.TreasureItemRender;
	
	public class ShopPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var titleText:TextField;
		private var backBut:Button;
		private var curHero :GameUser;
		private var itemList:List;
		private var tabBar:TabBar;
		private var firstIndex:int = 0;
		
		
		public function ShopPanel(_index:int = 0)
		{
			firstIndex = _index;
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			curHero = GameController.instance.localPlayer;
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
			backSkin.width = panelwidth*0.8;
			backSkin.height = panelheight*0.8;
			backSkin.x = panelwidth*0.1;
			backSkin.y = panelheight*0.1;
			
			
			tabBar = new TabBar();
			var tabList:ListCollection =new ListCollection(
				[
					{ label: LanguageController.getInstance().getString("treasure").toUpperCase()},
					{ label: LanguageController.getInstance().getString("weapon").toUpperCase()},
					{ label: LanguageController.getInstance().getString("defense").toUpperCase()} 
				]);
			tabBar.dataProvider = tabList;
			tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			tabBar.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
			tabBar.tabFactory = function():Button
			{
				var tab:Button = new Button();
				tab.defaultSelectedSkin =  new Image(Game.assets.getTexture("TabButtonSelectedSkin"));
				tab.defaultSkin =  new Image(Game.assets.getTexture("TabButtonSkin"));
				tab.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
				return tab;
			}
			addChild(this.tabBar);
			tabBar.width = panelwidth*0.8;
			tabBar.height = panelheight*0.08;
			tabBar.x = panelwidth*0.1 ;
			tabBar.y = panelheight*0.1 ;
			
			
			configList();
			
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.08;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
			
			
			tabBar.selectedIndex = firstIndex;
		}
		
		private function configList():void
		{
			if(!itemList){
				itemList = new List();
				
				var listLayout:TiledRowsLayout = new TiledRowsLayout();
				listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
				listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
				listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
				listLayout.useSquareTiles = false;
				listLayout.horizontalGap = panelwidth*0.03;
				listLayout.verticalGap = 	panelheight*0.02;
				
				itemList.layout = listLayout;
				itemList.width =  panelwidth*0.8;
				itemList.height =  panelheight *0.7;
				itemList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FLOAT;
				itemList.verticalScrollPolicy = List.SCROLL_POLICY_AUTO;
				itemList.snapToPages = true;
				addChild(itemList);
				itemList.x = panelwidth*0.1;
				itemList.y = panelheight*0.2;
				
			}
			
			if(currentTabIndex == 1){
				
				itemList.dataProvider = proplistData;
				itemList.itemRendererFactory =function tileListItemRendererFactory():SpecialItemRender
				{
					var renderer:SpecialItemRender = new SpecialItemRender();
					var skin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BPanelSkin"),new Rectangle(10,10,70,70)));
					renderer.defaultSkin = skin;
					renderer.width = panelwidth *0.3;
					renderer.height = panelheight *0.6;
					return renderer;
				}
			}else if(currentTabIndex == 0){
				
				itemList.dataProvider = treasurelistData;
				itemList.itemRendererFactory =function tileListItemRendererFactory():TreasureItemRender
				{
					var renderer:TreasureItemRender = new TreasureItemRender();
					renderer.defaultSkin = new Image(Game.assets.getTexture("SelectRenderSkin"));
					renderer.width = panelwidth *0.23;
					renderer.height = panelheight *0.3;
					return renderer;
				}
			}else if(currentTabIndex == 2){
				
				itemList.dataProvider = proplistData;
				itemList.itemRendererFactory =function tileListItemRendererFactory():SpecialItemRender
				{
					var renderer:SpecialItemRender = new SpecialItemRender();
					var skin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BPanelSkin"),new Rectangle(10,10,70,70)));
					renderer.defaultSkin = skin;
					renderer.width = panelwidth *0.3;
					renderer.height = panelheight *0.6;
					return renderer;
				}
			}
			itemList.validate();
		}
		private function get proplistData():ListCollection
		{
			var spec:ItemSpec;
			var dicArr:Array = [];
			var groupDic : Object = SpecController.instance.getGroup("Item");
			for each(spec in groupDic){
				if(currentTabIndex == 1){
					if(spec.type == "weapon"){
						dicArr.push(spec.item_id);
					}
				}else{
					if(spec.type == "defence"){
						dicArr.push(spec.item_id);
					}
				}
			}
			
			return new ListCollection(dicArr);
		}
		private function get treasurelistData():ListCollection
		{
			var arr:Array = [];
			for each(var object:TreasureItem in Configrations.treasures){
				arr.push(object);
			}
			arr.sortOn("index",Array.NUMERIC);
			return new ListCollection(arr);
		}
		private var currentTabIndex:int;
		private function tabBar_changeHandler(event:Event):void
		{
			if(tabBar.selectedIndex != currentTabIndex){
				currentTabIndex = tabBar.selectedIndex;
				configList();
			}
		}
		
		
		public function get user():GameUser
		{
			return GameController.instance.localPlayer;
		}
		private function onTriggerBack(e:Event):void
		{
			LocalData.instance.savePlayer();
			dispose();
		}
		
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
	}
}
