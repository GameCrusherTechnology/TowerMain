package view.compenent
{
	import gameconfig.Configrations;
	
	import model.gameSpec.SoldierItemSpec;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class SoldierLifeProgressBar extends Sprite
	{
		private const barWidth:Number = 80;
		private const barHeight:Number = 20;
		private var bar:GreenProgressBar;
		public function SoldierLifeProgressBar(itemspec:SoldierItemSpec,isLeft:Boolean)
		{
			
			var s:Number = Configrations.ViewScale;
			
			var barcolor:uint = isLeft?0x7ee000:0xff00ff;
			
			bar = new GreenProgressBar(barWidth*s,barHeight*s,1,0xffffff,barcolor);
			addChild(bar);
			
			var icon:Image = new Image(itemspec.iconTexture);
			icon.height = barHeight*s;
			icon.scaleX = icon.scaleY;
			addChild(icon);
			icon.alpha = 0.8;
		}
		public function showProgress(nown:Number,total:Number):void
		{
			nown = Math.max(0,nown);
			bar.progress = nown/total;
			bar.comment = nown + "/" + total;
		}
	}
}