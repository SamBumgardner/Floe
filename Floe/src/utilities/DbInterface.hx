package utilities;

import flash.net.URLVariables;
import flash.net.URLRequestMethod;
import flash.net.URLLoader;
import flash.net.URLRequest;

/*example of sending scores later this function will come from another file
 *To use: 			put utilities folder in your source folder.
 *To import: 		import utilities.DbInterface;
 *To instantiate: 	var myDbInterface = new DbInterface([your games's name (no caps)])
 *To send: 			myDbInterface.sendDataToDb(initials:String, score:Int);
 */
class DbInterface{
	private var dataToSend:URLVariables;
	public function new(game:String):Void {
		this.dataToSend = new URLVariables();
		if(game == "vocabulistics") {
			this.dataToSend.game = "vocabulistics";
		}
		else if(game == "floe") {
			this.dataToSend.game = "floe";
		}
	}
	public function sendDataToDb(initials:String, score:Int) {
		this.dataToSend.initials = initials;
		this.dataToSend.score = score;
		
		//prepare the request
		var req:URLRequest = new URLRequest("scoreDump.php");
		req.method = URLRequestMethod.POST;
		req.contentType = "application/x-www-form-urlencoded";
		req.data = this.dataToSend;
		
		//send the request
		var sender:URLLoader = new URLLoader();
		sender.load(req);
	}
}