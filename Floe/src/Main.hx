import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Stamp;

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
	}
	
	public function nextLevel(){

		HXP.scene = new scenes.MainScene();
	}
	
}
