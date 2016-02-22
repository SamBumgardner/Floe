import com.haxepunk.Engine;
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

}
