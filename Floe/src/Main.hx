import com.haxepunk.Engine;
import com.haxepunk.Scene;
import com.haxepunk.HXP;

import entities.GameManager;

class Main extends Engine
{

	public var musicVolume:Float = .5;
	public var sfxVolume:Float = .25;

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
			HXP.randomSeed = Std.parseInt(seed);
		}
		else{
			HXP.randomizeSeed();
		}
		
		HXP.console.log(["The random seed is: ", HXP.randomSeed]);
		
		var gm:GameManager = new entities.GameManager();
		
		HXP.scene.end();
		HXP.scene = new scenes.GameScene(gm);
	}
	
	public function nextLevel(){
		//This is somewhat irresponsible. 
		//need to clean up memory used by a scene before switching to new one.
		HXP.scene.end();
		HXP.scene = new scenes.GameScene();
	}
	
	public function gameOver(){
		HXP.console.log(["Game Over!"]);
		var gm:GameManager = cast(HXP.scene, scenes.GameScene).gameOver(); //ends the looping music.
		HXP.scene.end();
		HXP.scene = new scenes.GameOver(gm);
	}
	
}
