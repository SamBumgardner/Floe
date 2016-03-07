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


		
		HXP.scene = new scenes.MainScene();
	}

	public static function main() { new Main(); }
	
	
	public function new(width:Int = 0, height:Int = 0)
	{
		super(width, height, 60, false);
	}
	
	public function gameOver(){
		HXP.console.log(["Game Over!"]);
		HXP.scene.end();
		HXP.scene = new scenes.GameOver();
	}
	
	public function nextLevel(){
		//This is somewhat irresponsible. 
		//need to clean up memory used by a scene before switching to new one.
		HXP.scene.end();
		HXP.scene = new scenes.MainScene();
	}
	
}
