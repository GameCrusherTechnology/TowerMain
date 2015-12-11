package view.compenent
{
	import controller.DialogController;
	import controller.FieldController;
	
	import feathers.controls.Button;
	
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.panel.ShopPanel;
	
	public class ShopButton extends Sprite
	{
		private var side:Number = 100;
		public function ShopButton(_side:Number)
		{
			side = _side;
			
			var container:Sprite = new Sprite;
			var skin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			skin.width = skin.height = side;
			container.addChild(skin);
			
			var icon:Image = new Image(Game.assets.getTexture("ChestIcon"));
			icon.width = icon.height = side*0.8;
			container.addChild(icon);
			icon.x = side*0.1;
			
			var label:TextField = FieldController.createNoFontField(300,side/4,LanguageController.getInstance().getString("Shop"),0x000000,0,true);
			label.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			container.addChild(label);
			label.x = side/2 - label.width/2;
			label.y = side*0.75;
			container.touchable = false;
			
			var but:Button = new Button();
			but.defaultSkin = container;
			addChild(but);
			but.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			
		}
		
		private function onTriggerConfirm(e:Event):void
		{
			DialogController.instance.showPanel(new ShopPanel());
			
		}
		
	}
}
