package view.render
{
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.text.BitmapFontTextFormat;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.ItemSpec;
	import model.item.OwnedItem;
	import model.player.GameUser;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	import view.panel.WarnnigTipPanel;
	
	public class SpecialItemRender extends DefaultListItemRenderer
	{
		private var hero:GameUser;
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		private var itemspec:ItemSpec;
		private function canUseArr(id:String):Boolean
		{
//			= ["80000","80001","80002","80003","80004"];
//			var i:int = Math.round(int(id)/10000);
//			if(i == 8){
//				return true;
//			}
			return false;
		}
		public function SpecialItemRender()
		{
			super();
			scale = Configrations.ViewScale;
			hero = GameController.instance.localPlayer;
		}
		
		private var container:Sprite;
		private var itemId:String;
		private var ownedItem:OwnedItem;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			if(value){
				itemId = String(value) ;
				refreshData();
			}
		}
		
		private function refreshData():void{
			if(container){
				container.removeFromParent(true);
				container = null;
			}
			configContainer();
		}
		
		private var icon:Image;
		private function configContainer():void
		{
			container = new Sprite;
			addChild(container);
			ownedItem = hero.heroData.getItem(itemId);
			
			itemspec = ownedItem.itemSpec;
			if(itemspec){
				
				var nameText:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.15,itemspec.cname,0x000000,0,true);
				nameText.autoSize = TextFieldAutoSize.VERTICAL;
				container.addChild(nameText);
				nameText.y =  5*scale;
				
				if(itemspec.type == "weapon"){
					icon = new MovieClip(Game.assets.getTextures(itemspec.name));
					icon.width  = renderwidth *0.8;
					icon.scaleY = icon.scaleX ;
					container.addChild(icon);
					icon.x = renderwidth*0.5 - icon.width/2;
					icon.y = renderHeight*0.3 - icon.height/2;
					Starling.juggler.add(icon as MovieClip);
				}else{
					icon = new Image(Game.assets.getTexture(itemspec.name));
					icon.width  = renderwidth *0.5;
					icon.scaleY = icon.scaleX ;
					container.addChild(icon);
					icon.x = renderwidth*0.5 - icon.width/2;
					icon.y = renderHeight*0.3 - icon.height/2;
				}
				
				
				configMes();
					
				if(ownedItem.count > 0){
					if(canUseArr(ownedItem.item_id)){
						var useBut:Button = new Button();
						useBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
						useBut.label = LanguageController.getInstance().getString("use");
						useBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, renderHeight*0.08, 0x000000);
						useBut.paddingLeft =useBut.paddingRight =  20;
						useBut.paddingTop = useBut.paddingBottom =  5;
						container.addChild(useBut);
						useBut.validate();
						useBut.x =  renderwidth/2 - useBut.width/2;
						useBut.y =	renderHeight*0.95 - useBut.height;
					}else{
						var boughtBut:Button = new Button();
						boughtBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
						boughtBut.label = LanguageController.getInstance().getString("Bought").toUpperCase();
						boughtBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, renderHeight*0.08, 0x000000);
						boughtBut.paddingLeft =boughtBut.paddingRight =  20;
						boughtBut.paddingTop = boughtBut.paddingBottom =  5;
						container.addChild(boughtBut);
						boughtBut.validate();
						boughtBut.x =  renderwidth/2 - boughtBut.width/2;
						boughtBut.y =	renderHeight*0.95 - boughtBut.height;
						boughtBut.filter = Configrations.grayscaleFilter;
						boughtBut.touchable = false;
					}
				}else{
				
					var sp:Sprite = new Sprite;
					container.addChild(sp);
					
					var leftBound:int ;
					if(itemspec.gem > 0){
						var gemBut:Button = new Button();
						gemBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
						gemBut.label = "×"+itemspec.gem;
						var iconM:Image = new Image(Game.assets.getTexture("GemIcon"));
						iconM.width = iconM.height = renderHeight *0.1;
						gemBut.defaultIcon = iconM;
						gemBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, renderHeight*0.08, 0x000000);
						gemBut.paddingLeft =gemBut.paddingRight =  10*scale;
						gemBut.paddingTop =gemBut.paddingBottom =  5*scale;
						sp.addChild(gemBut);
						gemBut.validate();
						leftBound = gemBut.width + renderwidth *0.05;
						
						gemBut.addEventListener(Event.TRIGGERED,onTriggedBuyGem);
					}
					if(itemspec.coin > 0){
						var coinBut:Button = new Button();
						coinBut.defaultSkin = new Image(Game.assets.getTexture("blueButtonSkin"));
						coinBut.label ="×"+itemspec.coin;
						var iconM1:Image = new Image(Game.assets.getTexture("CoinIcon"));
						iconM1.width = iconM1.height = renderHeight *0.1;
						coinBut.defaultIcon = iconM1;
						coinBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, renderHeight*0.08, 0x000000);
						coinBut.paddingLeft =coinBut.paddingRight =  10*scale;
						coinBut.paddingTop =coinBut.paddingBottom =  5*scale;
						sp.addChild(coinBut);
						coinBut.validate();
						coinBut.x = leftBound;
						coinBut.addEventListener(Event.TRIGGERED,onTriggedBuyCoin);
					}
					sp.x = renderwidth*0.5 - sp.width/2;
					sp.y = renderHeight*0.95 - sp.height;
				}
			}
		}
		private function configMes():void
		{
			var tip:Sprite;
			var deep:Number = renderHeight*0.5 ;
			switch(itemspec.item_id)
			{
				case "80000":
				{
					creatTip(container,deep,"powerIcon","power1"," 5");
					deep += renderHeight*0.08;
					creatTip(container,deep,"agilityIcon","agility1"," 10%");
					break;
				}
				case "80001":
				{
					creatTip(container,deep,"critIcon","crit1"," 5%");
					deep += renderHeight*0.08;
					creatTip(container,deep,"critHurtIcon","critHurt1"," 50%");
					break;
				}
				case "80002":
				{
					tip =  creatMesTip("skillIcon/frozen","icebirdMes");
					container.addChild( tip);
					tip.x = renderwidth*0.05;
					tip.y = deep;
					deep += tip.height + renderHeight*0.05;
					
					tip = creatMesTip("skillIcon/lingjiaojian","icebirdMes1");
					container.addChild( tip);
					tip.x = renderwidth*0.05;
					tip.y = deep;
					deep += tip.height;
					break;
				}
				case "80003":
				{
					tip =  creatMesTip("trackingIcon","purpleballMes");
					container.addChild( tip);
					tip.x = renderwidth*0.05;
					tip.y = deep;
					deep += tip.height + renderHeight*0.01;
					
					creatTip(container,deep,"powerIcon","power1"," 20");
					deep += renderHeight*0.08;
					creatTip(container,deep,"agilityIcon","agility1"," 50%");
					deep += renderHeight*0.08;
					creatTip(container,deep,"critIcon","crit1"," 10%");
					break;
				}
				case "80004":
				{
					creatTip(container,deep,"defenseIcon","defense"," 20%");
					break;
				}
				case "80005":
				{
					tip =  creatMesTip("skillIcon/vampiric","greenBuffMes");
					container.addChild( tip);
					tip.x = renderwidth*0.05;
					tip.y = deep;
					deep += tip.height + renderHeight*0.01;
					
					creatTip(container,deep,"healthIcon","health1"," 100");
					deep += renderHeight*0.08;
					creatTip(container,deep,"defenseIcon","defense"," 10%");
					break;
				}
					
					
				default:
				{
					break;
				}
			}
		}
		private function creatTip(c:Sprite,deep:Number,iconName:String,typeName:String,value:String ):void
		{
			var tipcontainer:Sprite = new Sprite;
			
			var icon:Image = new Image(Game.assets.getTexture(iconName));
			icon.width = icon.height = renderHeight*0.08;
			tipcontainer.addChild(icon);
			
			var nameText:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.08,LanguageController.getInstance().getString(typeName)+":",0x000000);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			tipcontainer.addChild(nameText);
			nameText.x = icon.width;
			
			var properText:TextField = FieldController.createNoFontField(renderwidth,renderHeight*0.08,value,0xBCEE68,0,true);
			properText.autoSize = TextFieldAutoSize.HORIZONTAL;
			tipcontainer.addChild(properText);
			properText.x = icon.width + nameText.width;
			
			if(tipcontainer.width > renderwidth *0.9){
				tipcontainer.width = renderwidth *0.9;
				tipcontainer.scaleY = tipcontainer.scaleX;
			}
			c.addChild(tipcontainer);
			tipcontainer.x = renderwidth *0.05;
			tipcontainer.y = deep;
		}
		private function creatMesTip(iconName:String,typeName:String):Sprite
		{
			var tipcontainer:Sprite = new Sprite;
			
			var icon:Image = new Image(Game.assets.getTexture(iconName));
			icon.width = icon.height = renderHeight*0.08;
			tipcontainer.addChild(icon);
			
			var nameText:TextField = FieldController.createNoFontField(renderwidth*0.9 - renderHeight*0.08,renderHeight,LanguageController.getInstance().getString(typeName),0x000000,renderHeight*0.05);
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			nameText.hAlign = HAlign.LEFT;
			tipcontainer.addChild(nameText);
			nameText.x = icon.width;
			
			if(nameText.height > icon.height){
				icon.y = nameText.height/2 - icon.height/2;
				nameText.y = 0;
			}else{
				icon.y = 0;
				nameText.y = icon.height/2 - nameText.height/2;
			}
			
			return tipcontainer;
		}
		private function onUsed():void
		{
			refreshData();
		}
		private function onTriggedBuyCoin(e:Event):void
		{
			if(hero.coin >= itemspec.coin){
				hero.addCoin(-itemspec.coin);
				hero.heroData.addItem(itemspec.item_id,1);
				if(itemspec.type == "weapon"){
					hero.heroData.curWeapon = itemspec.item_id;
				}else if(itemspec.type == "defence"){
					hero.heroData.curDefence = itemspec.item_id;
				}
				refreshData();
			}else{
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningCoinTip")));
			}
		}
		
		private function onTriggedBuyGem(e:Event):void
		{
			if(hero.gem >= itemspec.gem){
				hero.addGem(-itemspec.gem);
				hero.heroData.addItem(itemspec.item_id,1);
				if(itemspec.type == "weapon"){
					hero.heroData.curWeapon = itemspec.item_id;
				}else if(itemspec.type == "defence"){
					hero.heroData.curDefence = itemspec.item_id;
				}
				refreshData();
			}else{
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningGemTip")));
			}
		}
		override public function dispose():void
		{
			if(icon && icon is MovieClip){
				Starling.juggler.remove(icon as MovieClip);
			}
			if(container){
				container.removeFromParent(true);
				container = null;
			}
			super.dispose();
		}
	}
}
