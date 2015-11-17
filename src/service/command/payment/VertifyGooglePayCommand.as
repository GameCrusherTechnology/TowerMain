package service.command.payment
{
	import controller.DialogController;
	import controller.GameController;
	
	import gameconfig.LanguageController;
	
	import model.item.OwnedItem;
	import model.player.GameUser;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	import view.panel.WarnnigTipPanel;
	
	public class VertifyGooglePayCommand extends AbstractCommand
	{
		private var onBack:Function;
		private var onError:Function;
		public function VertifyGooglePayCommand(param:Object,callBack:Function,onerror:Function)
		{
			onBack =callBack;
			onError = onerror;
			super(Command.GOOGLEPAY,onResult,param)
		}
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				var hero:GameUser = GameController.instance.localPlayer;
				if(result.item){
					var itemArr:Array = [];
					var item:OwnedItem;
					for each(var obj:Object in result.item){
						item = new OwnedItem(obj["item_id"],obj["count"]);
						itemArr.push(item);
						if(obj["item_id"] == "coin"){
//							GameController.instance.localPlayer.changeCoin(obj["count"]);
						}else if(obj["item_id"] == "gem"){
//							GameController.instance.localPlayer.changeGem(obj["count"]);
						}else if(obj["item_id"] == "exp"){
//							hero.addExp(obj["count"]);
						}else if(obj["item_id"] == "vip"){
						}else{
//							hero.addItem(obj["item_id"],obj["count"]);
						}
					}
//					DialogController.instance.showPanel(new RewardsPanel(itemArr));
				}
				else{
					DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningPay01")));
				}
			}else{
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningPay01")));
				onError();
			}
		}
	}
}

