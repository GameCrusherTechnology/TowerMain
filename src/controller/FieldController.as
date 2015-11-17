package controller{
	import starling.text.TextField;
	
    public class FieldController {

		public static function get  FONT_FAMILY():String
		{
			
			return "myFonts_0";
		}
		
		
		public static function createNoFontField(width:Number,height:Number,txt:String, _color:uint, _size:Number = 0,_bold:Boolean = false,useFont:Boolean = true):TextField{
			var size:int;
			
			var scaleF:Number = 1;
			if(width>2048){
				scaleF = width /2048;
				width = 2048;
				height = height/scaleF;
			}
			
			if(_size > 0){
				size= Math.round(_size);
			}else{
				if(scaleF >1 ){
					size= Math.round(height*0.5);
				}else{
					size= Math.round(height*0.7);
				}
			}
			
			var _local4:TextField = new TextField(width,height,txt);
			if(useFont){
				_local4.fontName = FONT_FAMILY;
			}
			_local4.bold = _bold;
			_local4.scaleX = _local4.scaleY = scaleF;
			_local4.touchable = false;
			_local4.color = _color;
			_local4.fontSize = size;
			return (_local4);
		}
		
		

    }
}