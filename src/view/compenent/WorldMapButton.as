package view.compenent
{
	import controller.DialogController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	
	import model.gameSpec.MapItemSpec;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import view.panel.MapPanel;

	public class WorldMapButton extends Sprite
	{
		public var id:String;
		public function WorldMapButton(side:Number,index:int)
		{
			id = String(40000 + index);
			var icon:Image = new Image(Game.assets.getTexture("ClanBigIcon"));
			icon.width = side;
			icon.scaleY = icon.scaleX;
			addChild(icon);
			
			var but:Button = new Button();
			var butSKin:Image = new Image(Game.assets.getTexture("BlackSkin"));
			butSKin.width = butSKin.height = side;
			butSKin.alpha = 0;
			but.defaultSkin = butSKin;
			addChild(but);
			but.addEventListener(Event.TRIGGERED,onTroggered);
		}
		
		private function onTroggered(e:Event):void
		{
			var mapSpec:MapItemSpec = SpecController.instance.getItemSpec(id) as MapItemSpec;
			if(mapSpec)
			{
				DialogController.instance.showPanel(new MapPanel(mapSpec));
			}
		}
		
	}
}