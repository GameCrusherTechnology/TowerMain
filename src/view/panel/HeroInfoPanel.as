package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.LocalData;
	
	import model.gameSpec.ItemSpec;
	import model.item.HeroData;
	import model.item.OwnedItem;
	import model.player.GameUser;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.compenent.GreenProgressBar;
	import view.render.HeroItemRender;
	
	public class HeroInfoPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var oldCoin:int;
		private var oldData:HeroData;
		private var coinText:TextField;
		
		private var coinBut:Button;
		public function HeroInfoPanel()
		{
			oldCoin = player.coin;
			oldData = player.heroData;
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
			backSkin.width = panelwidth*0.8;
			backSkin.height = panelheight*0.8;
			backSkin.x = panelwidth*0.1;
			backSkin.y = panelheight*0.1;
			
			var titleSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelTitle"),new Rectangle(15,14,70,20)));
			addChild(titleSkin);
			titleSkin.width = backSkin.width;
			titleSkin.height = panelheight*0.08;
			titleSkin.x =backSkin.x;
			titleSkin.y = backSkin.y;
			
			var titleText:TextField = FieldController.createNoFontField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("hero"),0x000000,titleSkin.height*0.6,true);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			configContainer();
			
			var backBut:Button = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = titleSkin.x-backBut.width/2;
			backBut.y = titleSkin.y - backBut.height + titleSkin.height;
			backBut.addEventListener(Event.TRIGGERED,onTriggerOut);
			
		}
		private function configContainer():void
		{
			var headIcon:Image = new Image(Game.assets.getTexture("sheshouHeadIcon"));
			addChild(headIcon);
			headIcon.height = panelheight*0.15;
			headIcon.scaleX = headIcon.scaleY;
			
			headIcon.x = panelwidth *0.2;
			headIcon.y = panelheight*0.18;
			
			var expBar:GreenProgressBar  = new GreenProgressBar(panelwidth*0.3,panelheight*0.05,2);
			addChild(expBar);
			var nextExp:int = Configrations.gradeToExp(player.heroData.level+1);
			expBar.x = panelwidth *0.45;
			expBar.y = panelheight*0.23;
			expBar.comment = player.heroData.exp +"/" + nextExp;
			expBar.progress = player.heroData.exp/nextExp;
			
			var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
			expIcon.width = expIcon.height = panelheight *0.08;
			addChild(expIcon);
			expIcon.x = panelwidth *0.45 - expIcon.width/2;
			expIcon.y = panelheight*0.21;
			
			var expLevel:TextField = FieldController.createNoFontField(panelwidth,expIcon.height,""+player.heroData.level,0x000000,0,true);
			expLevel.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(expLevel);
			expLevel.x = expIcon.x + expIcon.width/2 - expLevel.width/2;
			expLevel.y = expIcon.y;
			
			configPropertyPart();
			configWeaponPart();
			configDefencePart();
			
		}
		
		private function configPropertyPart():void
		{
			var container:Sprite = new Sprite;
			addChild(container);
			container.x = panelwidth * 0.25;
			container.y = panelheight*0.35;
			
			var b:Number = 0;
			
			var healPart:Sprite = creatPropertyP("healthIcon","health","" + player.heroData.curHealth);
			container.addChild(healPart);
			
			var attackPart:Sprite = creatPropertyP("powerIcon","power","" + player.heroData.curAttackPower);
			container.addChild(attackPart);
			attackPart.x = panelwidth * 0.3;
			
			var attackSpeedPart:Sprite = creatPropertyP("agilityIcon","agility","" + player.heroData.curAttackSpeed+"%");
			container.addChild(attackSpeedPart);
			attackSpeedPart.y = panelheight *0.06;
			
			
			var critPart:Sprite = creatPropertyP("critIcon","crit","" + player.heroData.curCritRate+"%");
			container.addChild(critPart);
			critPart.y = panelheight *0.12;
			
			var critHurtPart:Sprite = creatPropertyP("critIcon","crit","" + player.heroData.curCritHurt+"%");
			container.addChild(critHurtPart);
			critHurtPart.x = panelwidth * 0.3;
			critHurtPart.y = panelheight *0.12;
			
			var defencePart:Sprite = creatPropertyP("defenseIcon","defense","" + player.heroData.curDefense*100 +"%");
			container.addChild(defencePart);
			defencePart.y = panelheight *0.18;
			
			var wisdomPart:Sprite = creatPropertyP("wisdomIcon","wisdom","" + player.heroData.curWisdomCD +"%");
			container.addChild(wisdomPart);
			wisdomPart.x = panelwidth * 0.3;
			wisdomPart.y = panelheight *0.18;
			
		}
		
		private var weaponContainer:Sprite;
		private var weaponicon:MovieClip;
		private var weaponBut:Button;
		private function configWeaponPart():void
		{
			if(weaponContainer){
				if(weaponBut){
					weaponBut.removeEventListener(Event.TRIGGERED,onTriggerWeapon);
					weaponBut.removeFromParent(true);
				}
				weaponContainer.removeFromParent(true);
			}
			weaponContainer = new Sprite;
			addChild(weaponContainer);
			weaponContainer.x = panelwidth*0.2;
			weaponContainer.y = panelheight *0.6;
			
			var skin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BPanelSkin"),new Rectangle(10,10,70,70)));
			skin.width = panelwidth*0.25;
			skin.height = panelheight*0.2;
			weaponContainer.addChild(skin);
			
			var nameText:TextField = FieldController.createNoFontField(skin.width,panelheight*0.05,LanguageController.getInstance().getString("weapon"),0x000000,0,true);
			weaponContainer.addChild(nameText);
			
			if(player.heroData.curWeapon){
				var weaponSpec:ItemSpec = SpecController.instance.getItemSpec(player.heroData.curWeapon);
				if(weaponSpec){
					weaponicon = new MovieClip(Game.assets.getTextures(weaponSpec.name));
					weaponicon.width  = panelwidth *0.2;
					weaponicon.scaleY = weaponicon.scaleX ;
					weaponContainer.addChild(weaponicon);
					weaponicon.x = skin.width*0.5 - weaponicon.width/2;
					weaponicon.y = skin.height*0.5 - weaponicon.height/2;
					Starling.juggler.add(weaponicon);
					
					var nameText1:TextField = FieldController.createNoFontField(skin.width,panelheight*0.05,weaponSpec.cname,0x000000,0,true);
					weaponContainer.addChild(nameText1);
					nameText1.y = skin.height - nameText1.height;
					
				}
			}
				weaponBut = new Button;
				
				var skin1:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BPanelSkin"),new Rectangle(10,10,70,70)));
				skin1.width = panelwidth*0.25;
				skin1.height = panelheight*0.25;
				skin1.alpha = 0;
				weaponBut.defaultSkin = skin1;
			weaponContainer.addChild(weaponBut);
			weaponBut.addEventListener(Event.TRIGGERED,onTriggerWeapon);
		}
		private function onTriggerWeapon(e:Event):void
		{
			showList("weapon");
		}
		
		
		private var itemList:List;	
		private function showList(type:String):void
		{
			var listCol:ListCollection = getProplistData(type);
			if(listCol.length >=1){
				if(!itemList){
					var listLayout:TiledRowsLayout = new TiledRowsLayout();
					listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
					listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
					listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
					listLayout.useSquareTiles = false;
					listLayout.horizontalGap = panelwidth*0.03;
					listLayout.verticalGap = 	panelheight*0.02;
					itemList = new List;
					itemList.layout = listLayout;
					itemList.width =  panelwidth*0.8;
					itemList.height =  panelheight *0.18;
					itemList.backgroundSkin = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackSkin"),new Rectangle(2,2,60,60)));

					itemList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FLOAT;
					itemList.verticalScrollPolicy = List.SCROLL_POLICY_AUTO;
					itemList.itemRendererFactory =function tileListItemRendererFactory():HeroItemRender
					{
						var renderer:HeroItemRender = new HeroItemRender();
						var skin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BPanelSkin"),new Rectangle(10,10,70,70)));
						renderer.defaultSkin = skin;
						renderer.width = panelwidth*0.25;
						renderer.height = panelheight *0.18;
						return renderer;
					}
					itemList.snapToPages = true;
					itemList.x = panelwidth*0.1;
					itemList.y = panelheight*0.82;
					itemList.addEventListener(Event.CHANGE,onListChanged);
				}
				itemList.dataProvider = listCol;
				addChild(itemList);
			}
		}
		private function onListChanged(e:Event):void
		{
			if(itemList){
				var item:OwnedItem = itemList.selectedItem as OwnedItem;
				if(item && item.count >0){
					player.heroData.curWeapon = item.item_id;
					configWeaponPart();
				}
				itemList.removeFromParent(true);
				itemList.removeEventListener(Event.CHANGE,onListChanged);
				itemList = null;
			}
		}
		private function getProplistData(type:String):ListCollection
		{
			var wholeArr:Array = player.heroData.owneditems;
			var arr:Array = [];
			for each(var item:OwnedItem in wholeArr){
				if(item.count > 0 && item.itemSpec.type == type ){
					arr.push(item);
				}
			}
			return new ListCollection(arr);
		}
		private var defenceContainer:Sprite;
		private function configDefencePart():void
		{
			if(defenceContainer){
				defenceContainer.removeFromParent(true);
			}
			defenceContainer = new Sprite;
			addChild(defenceContainer);
			defenceContainer.x = panelwidth*0.55;
			defenceContainer.y = panelheight *0.6;
			
			var skin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BPanelSkin"),new Rectangle(10,10,70,70)));
			skin.width = panelwidth*0.25;
			skin.height = panelheight*0.2;
			defenceContainer.addChild(skin);
			
			var nameText:TextField = FieldController.createNoFontField(skin.width,panelheight*0.05,LanguageController.getInstance().getString("defense"),0x000000,0,true);
			defenceContainer.addChild(nameText);
			
			if(player.heroData.curDefence){
				var defenceSpec:ItemSpec = SpecController.instance.getItemSpec(player.heroData.curDefence);
				if(defenceSpec){
					var defenceicon:Image = new Image(Game.assets.getTexture(defenceSpec.name));
					defenceicon.width  = panelwidth *0.2;
					defenceicon.scaleY = defenceicon.scaleX ;
					defenceContainer.addChild(defenceicon);
					defenceicon.x = skin.width*0.5 - defenceicon.width/2;
					defenceicon.y = skin.height*0.5 - defenceicon.height/2;
					
					var nameText1:TextField = FieldController.createNoFontField(skin.width,panelheight*0.05,defenceSpec.cname,0x000000,0,true);
					defenceContainer.addChild(nameText1);
					nameText1.y = skin.height - nameText1.height;
					
				}
			}
			var weaponBut:Button = new Button;
			
			var skin1:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BPanelSkin"),new Rectangle(10,10,70,70)));
			skin1.width = panelwidth*0.25;
			skin1.height = panelheight*0.25;
			skin1.alpha = 0;
			weaponBut.defaultSkin = skin1;
			defenceContainer.addChild(weaponBut);
			weaponBut.addEventListener(Event.TRIGGERED,onTriggerWeapon);
			
		}
		private function creatPropertyP(iconcls:String,nameStr:String,proper:String):Sprite
		{
			var container:Sprite = new Sprite;
			
			var icon:Image = new Image(Game.assets.getTexture(iconcls));
			icon.width = icon.height = panelheight*0.05;
			container.addChild(icon);
			
			var nameText:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.05,LanguageController.getInstance().getString(nameStr)+":",0x000000);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(nameText);
			nameText.x = icon.width;
			
			var properText:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.05," "+proper,0xBCEE68,panelheight*0.04,true);
			properText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(properText);
			properText.x = icon.width + nameText.width;
			
			return container;	
		}
		
		
		private function onTriggerOut(e:Event):void
		{
			LocalData.instance.savePlayer();
			dispose();
		}
		private function get player():GameUser
		{
			return GameController.instance.localPlayer;
		}
		override public function dispose():void
		{
			if(itemList){
				itemList.removeFromParent(true);
				itemList.removeEventListener(Event.CHANGE,onListChanged);
			}
			if(weaponicon){
				Starling.juggler.remove(weaponicon);
			}
			removeFromParent();
			super.dispose();
		}
		
	}
}
