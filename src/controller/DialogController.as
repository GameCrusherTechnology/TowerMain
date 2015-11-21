package controller
{
	import flash.geom.Point;
	
	import feathers.controls.PanelScreen;
	
	import model.gameSpec.SkillItemSpec;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	import view.panel.SkillInfoPanel;

	public class DialogController
	{
		private static var _controller:DialogController;
		private var layer:Sprite;
		public static function get instance():DialogController
		{
			if(!_controller){
				_controller = new DialogController();
			}
			return _controller;
		}
		public function DialogController()
		{
			
		}
		public function showPanel(panel:Sprite,exclusive:Boolean=false):void
		{
			if(exclusive){
				destroy();
			}
			layer.addChild(panel);
			VoiceController.instance.playSound(VoiceController.NPC_TIPS);
		}
		
		private var sPanel:SkillInfoPanel;
		public function showSkillMPanel(spec:SkillItemSpec,pos:Point=null,exclusive:Boolean=false):void
		{
			if(exclusive){
				destroy();
			}
			if(!sPanel){
				sPanel = new SkillInfoPanel(spec,pos);
			}else{
				sPanel.reset(spec,pos);
			}
			layer.addChild(sPanel);
			VoiceController.instance.playSound(VoiceController.NPC_TIPS);
		}
		
		public function destroy():void
		{
			var displayObj:DisplayObject;
			while(layer.numChildren>0){
				displayObj = layer.getChildAt(0);
				displayObj.removeFromParent(true);
			}
		}
		
		public function levelUp():void
		{
			
		}
			
		public function setLayer(_la:Sprite):void
		{
			layer = _la;
		}
		public function get hasPanel():Boolean
		{
			return layer && (layer.numChildren >=1) ;
		}
		
	}
}