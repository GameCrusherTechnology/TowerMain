package view.render
{
	import controller.FieldController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.clan.ClanBossData;
	import model.clan.ClanData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class ClanListRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function ClanListRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var clanData:ClanData;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			if(value is ClanBossData){
				super.data = clanData = (value as ClanBossData).owner;
				if(container){
					container.removeFromParent(true);
				}
				
				configContainer();
			}
		}
		
		private function configContainer():void
		{
			renderwidth = width;
			renderHeight = height;
			container = new Sprite;
			addChild(container);
			
			var icon:Image = new Image(Game.assets.getTexture("expIcon"));
			icon.width = icon.height = renderHeight*0.8;
			container.addChild(icon);
			icon.x = 0;
			icon.y = renderHeight*0.1;
			
			
			if(clanData){
				var levelText:TextField = FieldController.createNoFontField(icon.width,icon.height,String(clanData.level),0x000000);
				container.addChild(levelText);
				levelText.x = icon.x;
				levelText.y = icon.y;
				
				var nameText:TextField = FieldController.createNoFontField(renderwidth/3,renderHeight,clanData.name,0x000000,0,false,false);
				nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(nameText);
				nameText.x = icon.x + icon.width + 5*scale;
				
				
				var memberText:TextField = FieldController.createNoFontField(renderwidth/3,renderHeight,(clanData.memberCount)+"/"+clanData.totalMember,0x000000);
				container.addChild(memberText);
				memberText.x = renderwidth/3*2;
			}
			
		}
	}
}
