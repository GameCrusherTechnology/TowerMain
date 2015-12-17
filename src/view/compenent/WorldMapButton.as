package view.compenent
{
	import controller.DialogController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.MapItemSpec;
	import model.player.GameUser;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import view.panel.MapPanel;

	public class WorldMapButton extends Sprite
	{
		public var id:String;
		private var mapSpec:MapItemSpec;
		private var skin:MovieClip;
		private var but:Button;
		public function WorldMapButton(side:Number,index:int,isOpen:Boolean)
		{
			id = String(40000 + index);
			mapSpec = SpecController.instance.getItemSpec(id) as MapItemSpec;
			if(player.heroData.curmap == index){
				skin = new MovieClip(Game.assets.getTextures("Crystal"));
				skin.width = side*2;
				skin.scaleY = skin.scaleX;
				addChild(skin);
				Starling.juggler.add(skin);
				skin.x = - side*0.5;
				skin.y = side*1.8 - skin.height;
			}
			
			var icon:Image = new Image(Game.assets.getTexture("ClanBigIcon"));
			icon.width = side;
			icon.scaleY = icon.scaleX;
			addChild(icon);
			
			var bar :GreenProgressBar = new GreenProgressBar(side,side/4,1,0xCD950C,0x00CED1);
			addChild(bar);
			bar.x =  0;
			bar.y = side - bar.height/2;
			var totalMaps:int = mapSpec.totalT.length;
			var threeNumbers:int = player.heroData.getThreeMaps(index);
			bar.comment = threeNumbers + " /" + totalMaps;
			bar.progress = threeNumbers/totalMaps;
			
			but = new Button();
			var butSKin:Image = new Image(Game.assets.getTexture("BlackSkin"));
			butSKin.width = butSKin.height = side;
			butSKin.alpha = 0;
			but.defaultSkin = butSKin;
			addChild(but);
			if(isOpen){
				but.addEventListener(Event.TRIGGERED,onTroggered);
			}else{
				filter = Configrations.grayscaleFilter;
			}
		}
		
		private function get player():GameUser
		{
			return GameController.instance.localPlayer;
		}
		
		private function onTroggered(e:Event):void
		{
			DialogController.instance.showPanel(new MapPanel(mapSpec));
		}
		
		override public function dispose():void
		{
			if(skin){
				Starling.juggler.remove(skin);
			}
			if(but){
				but.removeEventListener(Event.TRIGGERED,onTroggered);
			}
			super.dispose();
		}
		
	}
}