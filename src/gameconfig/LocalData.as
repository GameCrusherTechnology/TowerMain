package gameconfig
{
	import flash.filesystem.File;
	import flash.filesystem.FileStream;

	public class LocalData
	{
		private static var _controller:LocalData;
		public static function get instance():LocalData
		{
			if(!_controller){
				_controller = new LocalData();
			}
			return _controller;
		}
		private var heroFile:File;
		private var clanFile:File;
		private var randomItemFile:File;
		private var messageFile:File;
		private var fileStream:FileStream;
		public function LocalData()
		{
			var rootFile:File = File.userDirectory;
			heroFile =new File(rootFile.nativePath+ "/"  +Configrations.file_path+ "/" + "__h.txt");
			clanFile =new File(rootFile.nativePath+ "/"  +Configrations.file_path+ "/" + "__c.txt");
			randomItemFile =new File(rootFile.nativePath+ "/"  +Configrations.file_path+ "/" + "__r.txt");
			messageFile =new File(rootFile.nativePath+ "/"  +Configrations.file_path+ "/" + "__m.txt");
			fileStream=new FileStream();
		}
		
	
	}
}