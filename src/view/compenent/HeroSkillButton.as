package view.compenent
{
	import controller.GameController;
	
	import feathers.controls.Button;
	
	import model.battle.BattleRule;
	import model.gameSpec.SkillItemSpec;
	import model.item.HeroData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class HeroSkillButton extends Sprite
	{
		public var skillspec:SkillItemSpec;
		private var skillCD:int = 0;
		private var totalCD:int;
		private var backmode:Image;
		private var side:Number;
		public function HeroSkillButton(skillSpec:SkillItemSpec,_side:Number,_totalCD:int)
		{
			side = _side;
			skillspec = skillSpec;
			totalCD = _totalCD;
			var back:Image = new Image(Game.assets.getTexture("DPanelSkin"));
			back.width = back.height = side;
			addChild(back);
			
			backmode = new Image(Game.assets.getTexture("BPanelSkin"));
			backmode.width = backmode.height = side;
			addChild(backmode);
			
			var icon:Image = new Image(skillSpec.iconTexture);
			icon.width = icon.height = side*0.8;
			addChild(icon);
			icon.x = icon.y = side*0.1;
			
			
			var but:Button = new Button();
			var butSKin:Image = new Image(Game.assets.getTexture("BlackSkin"));
			butSKin.width = butSKin.height = side;
			butSKin.alpha = 0;
			but.defaultSkin = butSKin;
			addChild(but);
			but.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			
		}
		
		private function onTriggerConfirm(e:Event):void
		{
			GameController.instance.curBattleRule.skillItemSpec = skillspec;
			skillCD = 0;
			removeEvent();
		}
		
		
		
		public function onEnterFrame(e:Event):void
		{
			if(skillCD<=totalCD){
				showcd();
				if(skillCD == totalCD){
					addEvenet(); 
				}
			}
			skillCD++;
		}
		
		private function addEvenet():void
		{
			touchable = true;
		}
		private function removeEvent():void
		{
			touchable = false;
		}
		private function get rule():BattleRule
		{
			return GameController.instance.curBattleRule;
		}
		private function get heroData():HeroData
		{
			return GameController.instance.localPlayer.heroData;
		}
		public function showcd():void
		{
			backmode.height = side*(skillCD/totalCD);
			backmode.y = side - backmode.height;
		}
		
	}
}