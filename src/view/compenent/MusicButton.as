package view.compenent
{
	import controller.VoiceController;
	
	import feathers.controls.Button;
	
	import gameconfig.Configrations;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class MusicButton extends Sprite
	{
		private var side:Number = 100;
		public function MusicButton(_side:Number)
		{
			side = _side;
			
			var bool:Boolean = VoiceController.MUSIC_DISABLE;
			
			var icon:Image = new Image(Game.assets.getTexture("musicIcon"));
			icon.width = icon.height = side;
			
			
			var but:Button = new Button();
			but.defaultSkin = icon;
			addChild(but);
			but.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			
			if(!bool){
				filter = Configrations.grayscaleFilter;
			}
		}
		
		private function onTriggerConfirm(e:Event):void
		{
			if(VoiceController.MUSIC_DISABLE){
				VoiceController.instance.setMusic(false);
				filter = Configrations.grayscaleFilter;
			}else{
				VoiceController.instance.setMusic(true);
				filter = null;
			}
			
		}
		
	}
}
