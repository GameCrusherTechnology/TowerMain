package gameconfig
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import controller.GameController;
	
	import model.player.GameUser;

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
		private var randomItemFile:File;
		private var messageFile:File;
		private var fileStream:FileStream;
		public function LocalData()
		{
			var rootFile:File = File.userDirectory;
			heroFile =new File(rootFile.nativePath+ "/"  +Configrations.file_path+ "/" + "__h.txt");
			randomItemFile =new File(rootFile.nativePath+ "/"  +Configrations.file_path+ "/" + "__r.txt");
			messageFile =new File(rootFile.nativePath+ "/"  +Configrations.file_path+ "/" + "__m.txt");
			fileStream=new FileStream();
		}
		
		
		public function get localPlayer():GameUser
		{
			var user:GameUser;
			var info:Object;
			if(heroFile.exists){
				fileStream.open(heroFile,FileMode.READ);
				var readfilebyte:ByteArray=new ByteArray();
				fileStream.readBytes(readfilebyte);
				info = readfilebyte.readObject();
				fileStream.close();
			}
			if(!info){
				info = Configrations.INIT_USER;
				
				var filebyte:ByteArray=new ByteArray();
				filebyte.writeObject(info);
				fileStream.open(heroFile,FileMode.WRITE);
				fileStream.writeBytes(filebyte,0,filebyte.length);
				fileStream.close();
			}
			user = new GameUser(info);
			
			return user;
		}
		
		public function savePlayer():void
		{
			var curData:Object = GameController.instance.localPlayer.getSaveData();
			var filebyte:ByteArray=new ByteArray();
			filebyte.writeObject(curData);
			fileStream.open(heroFile,FileMode.WRITE);
			fileStream.writeBytes(filebyte,0,filebyte.length);
			fileStream.close();
		}
	
	}
}