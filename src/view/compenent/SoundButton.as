package view.compenent
{
	import controller.VoiceController;
	
	import feathers.controls.Button;
	
	import gameconfig.Configrations;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class SoundButton extends Sprite
	{
		private var side:Number = 100;
		public function SoundButton(_side:Number)
		{
			side = _side;
			
			var bool:Boolean = VoiceController.SOUND_DISABLE;
			
			var icon:Image = new Image(Game.assets.getTexture("soundIcon"));
			icon.width = icon.height = side;
			addChild(icon);
			
			
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
			if(VoiceController.SOUND_DISABLE){
				VoiceController.instance.setSound(false);
				filter = Configrations.grayscaleFilter;
			}else{
				VoiceController.instance.setSound(true);
				filter = null;
			}
			
		}
		
	}
}

