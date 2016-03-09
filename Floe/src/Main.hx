import com.haxepunk.Engine;
import com.haxepunk.Scene;
import com.haxepunk.HXP;


class Main extends Engine
{

	override public function init()
	{
#if debug
		HXP.console.enable();
#end


		
		HXP.scene = new scenes.MainMenu();
	}

	public static function main() { new Main(); }
	
	
	public function new(width:Int = 0, height:Int = 0)
	{
		super(width, height, 60, false);
	}
	
	public function returnToMenu(){
		HXP.console.log(["Returning to main menu..."]);
		HXP.scene.end();
		HXP.scene = new scenes.MainMenu();
	}
	
	public function startGame(seed:String){
		// --- Sets up manager and RNG for the new game ---
		
		if(seed != ""){
			HXP.console.log(["The random seed is: ", seed]);
			//This is a placeholder.
			//Should convert the Sring to Int
		}
		else{
			//Select a random seed automatically
		}
		//Create an instance of a game manager object
		HXP.scene.end();
		HXP.scene = new scenes.GameScene();
		
	}
	
	public function nextLevel(){
		//This is somewhat irresponsible. 
		//need to clean up memory used by a scene before switching to new one.
		HXP.scene.end();
		HXP.scene = new scenes.GameScene();
	}
	
	public function gameOver(){
		HXP.console.log(["Game Over!"]);
		HXP.scene.end();
		HXP.scene = new scenes.GameOver();
	}
	
}
