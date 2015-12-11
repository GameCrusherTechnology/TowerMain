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
			var i:int = Math.round(int(id)/10000);
			if(i == 8){
				return true;
			}
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
		
		private var icon:MovieClip;
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
				
				
				icon = new MovieClip(Game.assets.getTextures(itemspec.name));
				icon.width  = renderwidth *0.8;
				icon.scaleY = icon.scaleX ;
				container.addChild(icon);
				icon.x = renderwidth*0.5 - icon.width/2;
				icon.y = renderHeight*0.3 - icon.height/2;
				Starling.juggler.add(icon);
				
				
				if(itemspec.message){
					var mesText:TextField = FieldController.createNoFontField(renderwidth*0.9,renderHeight*0.1,LanguageController.getInstance().getString(itemspec.message),0x8B5742);
					container.addChild(mesText);
					mesText.y =   renderHeight*0.5 ;
				}
					
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
						useBut.addEventListener(Event.TRIGGERED,onTriggedUse);
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
		private function onTriggedUse(e:Event):void
		{
			if(!isCommanding){
			}
		}
		
		
		private function onUsed():void
		{
			isCommanding = false;
			refreshData();
		}
		private var isCommanding:Boolean;
		private function onTriggedBuyCoin(e:Event):void
		{
			if(hero.coin >= itemspec.coin){
				if(!isCommanding){
				}
			}else{
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningCoinTip")));
			}
		}
		
		private function onTriggedBuyGem(e:Event):void
		{
			if(hero.gem >= itemspec.gem){
				if(!isCommanding){
					isCommanding = true;
				}
			}else{
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningGemTip")));
			}
		}
		override public function dispose():void
		{
			Starling.juggler.remove(icon);
			if(container){
				container.removeFromParent(true);
				container = null;
			}
			super.dispose();
		}
	}
}
