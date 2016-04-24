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
			HXP.randomSeed = (cast Math.random() * 1000000000); //Generates, at most, a 9-digit number.
		}
		
		HXP.console.log(["The random seed is: ", HXP.randomSeed]);
		
		var gm:GameManager = new entities.GameManager();
		
		HXP.scene = new scenes.GameScene(gm);
	}
	
	public function nextLevel(){
		HXP.scene = new scenes.GameScene();
	}
	
	public function gameOver(){

		HXP.console.log(["Game Over!"]);
		var gm:GameManager = cast(HXP.scene, scenes.GameScene).gameOver(); //ends the looping music.
		HXP.scene = new scenes.GameOver(gm);
	
	}
	
}
