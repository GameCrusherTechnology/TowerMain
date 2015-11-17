package view.compenent
{
	import controller.VoiceController;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;

	public class LevelUpEffect extends Sprite
	{
		private var mc:MovieClip;
		public function LevelUpEffect()
		{
			mc = new MovieClip(Game.assets.getTextures("levelup"));
			addChild(mc);
			mc.x = -mc.width/2;
			mc.y = -mc.height/4*3;
			Starling.juggler.add(mc);
			mc.addEventListener(Event.ENTER_FRAME,onframeEnd);
			totalCounr = mc.numFrames *2;
			VoiceController.instance.playSound(VoiceController.LOSE);
		}
		private var totalCounr:int;
		private function onframeEnd(e:Event):void
		{
			if(totalCounr <=0){
				mc.removeEventListener(Event.ENTER_FRAME,onframeEnd);
				Starling.juggler.remove(mc);
				removeFromParent(true);
			}
			totalCounr --;
		}
	}
}