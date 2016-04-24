import com.haxepunk.Engine;
import com.haxepunk.Scene;
import com.haxepunk.HXP;

import entities.GameManager;

class Main extends Engine
{

	public var musicVolume:Float = .5;
	public var sfxVolume:Float = .25;

	
	// init()
	//
	// Initializes the game, creating the first MainMenu scene.
	
	override public function init()
	{
#if debug
		HXP.console.enable();
#end
		
		HXP.scene = new scenes.MainMenu();
	}

	
	// main()
	//
	// Calls Main's constructor, setting everything into motion.
	
	public static function main() { new Main(); }
	
	
	// new()
	//
	// Main's constructor. Simply passes off values to its parent class' constructor.
	
	public function new(width:Int = 0, height:Int = 0)
	{
		super(width, height, 60, false);
	}
	
	
	// returnToMenu()
	//
	// Makes MainMenu the current scene.
	
	public function returnToMenu(){
		//HXP.console.log(["Returning to main menu..."]);
		HXP.scene.end();
		
		HXP.scene = new scenes.MainMenu();
	}
	
	
	// startGame()
	//
	// Randomizes HXP's RNG seed, creates a GameManager,
	// and makes an instance of GameScene the active scene.
	
	public function startGame(seed:String){
		// --- Sets up manager and RNG for the new game ---
		
		if(seed != ""){
			HXP.randomSeed = Std.parseInt(seed);
		}
		else{
			HXP.randomizeSeed();
		}
		
		//HXP.console.log(["The random seed is: ", HXP.randomSeed]);
		
		var gm:GameManager = new entities.GameManager();
		
		HXP.scene = new scenes.GameScene(gm);
	}
	
	
	// nextLevel()
	// 
	// Makes a new GameScene the active scene.
	
	public function nextLevel(){
		HXP.scene = new scenes.GameScene();
	}
	
	
	// gameOver()
	//
	// Makes a new GameOver scene the active scene.
	
	public function gameOver(){

		//HXP.console.log(["Game Over!"]);
		var gm:GameManager = (cast HXP.scene).gameOver(); 
		HXP.scene = new scenes.GameOver(gm);
	
	}
	
}
