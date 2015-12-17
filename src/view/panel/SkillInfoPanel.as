package view.panel
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.ItemSpec;
	import model.gameSpec.SkillItemSpec;
	import model.player.GameUser;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;

	public class SkillInfoPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var backBut:Button;
		private var itemspec:SkillItemSpec;
		private var posi:Point;
		public function SkillInfoPanel(spec:SkillItemSpec,pos:Point = null)
		{
			itemspec = spec;
			posi = pos;
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		public function reset(spec:SkillItemSpec,pos:Point = null):void
		{
			itemspec = spec;
			posi = pos;
			config();
		}
		protected function initializeHandler(event:Event):void
		{
			removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			panelScale = Configrations.ViewScale;
			
			config();
			
		}
		private var container:Sprite;
		private function config():void
		{
			if(container){
				if(addBut){
					addBut.removeEventListener(Event.TRIGGERED,onAdded);
				}
				container.removeFromParent(true);
			}
			
			container = new Sprite;
			addChild(container);
			
			var curlevel:int = player.heroData.getSkillItem(itemspec.item_id).count;
			var leftPoint:int = player.heroData.skillPoints;
			
			var blackSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackSkin"),new Rectangle(2,2,60,60)));
			container.addChild(blackSkin);
			blackSkin.alpha = 1;
			blackSkin.width = panelwidth*0.9;
			blackSkin.height = panelheight*0.3;
			
			var typeCount:int = player.heroData.getSkillTypePoint(itemspec.type);
			
			var icon:Image = new Image(itemspec.iconTexture);
			icon.width = icon.height = panelheight*0.1;
			container.addChild(icon);
			icon.x = panelwidth *0.1;
			icon.y = panelheight*0.02;
			
			var nameText:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.04,itemspec.cname,0xCDCD00,panelheight*0.035,true);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(nameText);
			nameText.x = icon.x + icon.width + panelwidth*0.02;
			nameText.y = 0;
			
			var levelTextL:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.04,"(",0xCDCD00,panelheight*0.035,true);
			levelTextL.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(levelTextL);
			levelTextL.x = nameText.x + nameText.width + panelwidth*0.05;
			levelTextL.y = nameText.y;
			
			var levelText:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.04,""+curlevel,0xADFF2F,panelheight*0.035,true);
			levelText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(levelText);
			levelText.x = levelTextL.x + levelTextL.width ;
			levelText.y = nameText.y;
			
			var levelTextR:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.04,"/" +Configrations.SKILL_MAX_LEVEL + ")",0xCDCD00,panelheight*0.035,true);
			levelTextR.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(levelTextR);
			levelTextR.x = levelText.x + levelText.width ;
			levelTextR.y = levelText.y;
			
			var typeName:String ; 
			if(itemspec.recycle > 0){
				typeName = "activeskill";
			}else{
				typeName = "passiveskill";
			}
			var typeText:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.03,typeName,0xffffff,panelheight*0.025);
			typeText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(typeText);
			typeText.x = nameText.x ;
			typeText.y = nameText.y+nameText.height;
			
			var deep:Number = typeText.y + typeText.height + panelheight*0.01;
			
			if(curlevel >=1){
				var mesText:TextField = FieldController.createNoFontField(panelwidth*0.8 - nameText.x ,panelheight*0.15,"-"+LanguageController.getInstance().getString(itemspec.name+"Mes",getSkillInfoData(itemspec,curlevel)),0xffffff,panelheight*0.025);
				mesText.autoSize = TextFieldAutoSize.VERTICAL;
				mesText.hAlign = HAlign.LEFT;
				container.addChild(mesText);
				mesText.x = nameText.x ;
				mesText.y = deep;
				deep = mesText.y + mesText.height + panelheight*0.01;
			}
			
			if(curlevel < Configrations.SKILL_MAX_LEVEL){
				var nextText:TextField = FieldController.createNoFontField(panelwidth,panelheight*0.04,LanguageController.getInstance().getString("nextLevel")+":",0xADFF2F,panelheight*0.035,true);
				nextText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(nextText);
				nextText.x = nameText.x ;
				nextText.y = deep;
				
				var nextmesText:TextField = FieldController.createNoFontField(panelwidth*0.8 - nameText.x,panelheight*0.15,"-"+LanguageController.getInstance().getString(itemspec.name+"Mes",getSkillInfoData(itemspec,curlevel+1)),0xADFF2F,panelheight*0.025);
				nextmesText.autoSize = TextFieldAutoSize.VERTICAL;
				nextmesText.hAlign = HAlign.LEFT;
				container.addChild(nextmesText);
				nextmesText.x = nameText.x ;
				nextmesText.y = nextText.y+nextText.height;
				
				deep = nextmesText.y + nextmesText.height + panelheight*0.01;
				
				if(typeCount >= itemspec.typeNeed){
					addBut = new Button;
					
					var butImg :Image = new Image(Game.assets.getTexture("AddIcon"));
					butImg.width = butImg.height = panelheight *0.05;
					addBut.defaultIcon = butImg;
					addBut.defaultSkin = new Image(Game.assets.getTexture("PanelBackSkin"));
					addBut.padding = panelheight *0.01;
					addBut.width =addBut.height = panelheight *0.08;
					container.addChild(addBut);
					addBut.x = blackSkin.x + blackSkin.width - addBut.width - panelwidth*0.02 ;
					addBut.y = icon.y;
					if(leftPoint>0){
						addBut.addEventListener(Event.TRIGGERED,onAdded);
					}else{
						addBut.touchable = false;
						addBut.filter = Configrations.grayscaleFilter;
						addBut.isEnabled = false;
					}
				}
			}
			if(itemspec.recycle > 0)
			{
				var heroCool:Number = 1 - (player.heroData.curWisdomCD/100);
				var coolCD:Number;
				var cL:int;
				if(itemspec.type != "arrow"){
					cL = player.heroData.getSkillItem("31006").count;
					coolCD = Configrations.skill31006Point[cL];
				}else{
					cL = player.heroData.getSkillItem("30006").count;
					coolCD = Configrations.skillP30006Point[cL];
				}
				
				
				var newCycle:int = Math.floor(itemspec.recycle*(1-coolCD) *heroCool/30);
				var coolDownText:TextField =  FieldController.createNoFontField(panelwidth,panelheight*0.03,LanguageController.getInstance().getString("cooldown") +": " +newCycle,0xCDCD00,panelheight*0.025);
				coolDownText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(coolDownText);
				coolDownText.x = typeText.x ;
				coolDownText.y = deep;
				deep = coolDownText.y + coolDownText.height + panelheight*0.01;
			}
			
			if(typeCount < itemspec.typeNeed){
				
				var needText:TextField =  FieldController.createNoFontField(panelwidth,panelheight*0.03,"#"+LanguageController.getInstance().getString("skillNeed",[itemspec.typeNeed,LanguageController.getInstance().getString(itemspec.type)]),0xCD3333,panelheight*0.025);
				needText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(needText);
				needText.x = typeText.x ;
				needText.y = deep;
				
			}
				
			
			var outBut:Button = new Button;
			outBut.defaultSkin = new Image(Game.assets.getTexture("closeButtonIcon"));
			outBut.width = outBut.height = panelheight *0.08;
			container.addChild(outBut);
			outBut.x = blackSkin.x + blackSkin.width - outBut.width - panelwidth*0.02;
			outBut.y = blackSkin.y + blackSkin.height - outBut.height - panelheight*0.02;
			outBut.addEventListener(Event.TRIGGERED,onTrigged);
			
			if(!posi){
				posi = new Point(panelwidth*0.05,panelheight * 0.7);
			}
			x = posi.x;
			y = posi.y;
			
		}
		private function getSkillInfoData(spec:ItemSpec,level):Array
		{
			var arr:Array = [];
			switch(spec.item_id)
			{
				case "30001":
				{
					arr = [Configrations.count30001Arr[level],Configrations.hurt30001Arr[level]];
					break;
				}
				case "30002":
				{
					arr = [Configrations.skill30002Point[level]*100];
					break;
				}
				case "30003":
				{
					arr = [Configrations.skillP30003Rate[level]];
					break;
				}
				case "30004":
				{
					arr = [Configrations.hurt30004Arr[level]];
					break;
				}
				case "30005":
				{
					arr = [Configrations.skillP30005Point[level]*100];
					break;
				}
				case "30006":
				{
					arr = [LanguageController.getInstance().getString(spec.type),Configrations.skillP30006Point[level]*100];
					break;
				}
				case "30007":
				{
					arr = [Configrations.hurt30007Arr[level]];
					break;
				}
				case "30008":
				{
					arr = [Configrations.skillP30008Point[level]*100];
					break;
				}
				case "30009":
				{
					arr = [Configrations.skillP30009Point[level]*100];
					break;
				}
				case "31001":
				{
					arr = [Configrations.hurt31001Arr[level]];
					break;
				}
				case "31002":
				{
					arr = [Configrations.skill31002Point[level]*100];
					break;
				}
				case "31003":
				{
					arr = [Configrations.skill31003Point[level]*100];
					break;
				}
				case "31004":
				{
					arr = [Configrations.hurt31004Arr[level]];
					break;
				}
				case "31005":
				{
					arr = [Configrations.skill31005Point[level]*100];
					break;
				}
				case "31006":
				{
					arr = [LanguageController.getInstance().getString(spec.type),Configrations.skill31006Point[level]*100];
					break;
				}
				case "31007":
				{
					arr = [Configrations.hurt31007Arr[level]];
					break;
				}
				case "31008":
				{
					arr = [Configrations.skill31008Rate[level]*100];
					break;
				}
				case "31009":
				{
					arr = [Configrations.skill31009Point[level]*100];
					break;
				}
				
					
					
				default:
				{
					break;
				}
			}
			return arr;
		}
		private function onTrigged(e:Event):void
		{
			DialogController.instance.hideSkillMPanel();
		}
		private var addBut:Button;
		private function onAdded(e:Event):void
		{
			player.heroData.addSkillItem(itemspec.item_id,1);
			config();
		}
		
		private function get player():GameUser
		{
			return GameController.instance.localPlayer;
		}
		
	}
}