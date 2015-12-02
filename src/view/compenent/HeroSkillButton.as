package view.compenent
{
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	
	import model.battle.BattleRule;
	import model.gameSpec.SkillItemSpec;
	import model.item.HeroData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

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
			
			cdText = FieldController.createNoFontField(side,side/2,String(Math.floor(totalCD/30)),0x000000,0,true);
			addChild(cdText);
			
			var but:Button = new Button();
			var butSKin:Image = new Image(Game.assets.getTexture("BlackSkin"));
			butSKin.width = butSKin.height = side;
			butSKin.alpha = 0;
			but.defaultSkin = butSKin;
			addChild(but);
			but.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			
		}
		private var cdText:TextField;
		private function onTriggerConfirm(e:Event):void
		{
			var curSkillBut:HeroSkillButton = GameController.instance.curBattleRule.curSkillBut;
			if(curSkillBut){
				if(curSkillBut == this){
					GameController.instance.curBattleRule.curSkillBut = null;
					hideClick();
				}else{
					curSkillBut.hideClick();
					if(canUse){
						GameController.instance.curBattleRule.curSkillBut = this;
						showClick();
					}
				}
			}else{
				if(canUse){
					GameController.instance.curBattleRule.curSkillBut = this;
					showClick();
				}
			}
			
		}
		
		private function get canUse():Boolean
		{
			return skillCD >= totalCD;
		}
		public function showClick():void
		{
			
		}
		public function hideClick():void
		{
			
		}
		public function userSkill(p:Point):void
		{
			var skillClss:Class = getDefinitionByName("view.bullet."+skillspec.name) as Class;
			var lv:int = heroData.getSkillItem(skillspec.item_id).count;
			rule.addArm(new skillClss(p,lv,true));
			skillCD = 0;
		}
		
		public function onEnterFrame(e:Event):void
		{
			if(skillCD<=totalCD){
				showcd();
			}
			skillCD++;
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
			
			if(totalCD > skillCD){
				cdText.text = String(Math.floor((totalCD -skillCD) /30));
			}else{
				cdText.text ="";
			}
		}
		
	}
}