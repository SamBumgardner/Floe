package scenes;


import com.haxepunk.HXP; //for debug
import com.haxepunk.Scene;
import entities.GameOverSplash;
import entities.Player;
import entities.GameManager;

class GameOver extends Scene
{

	public var GM:GameManager;

	public function new(gm:GameManager)
	{
		super();
		GM = gm;
	}
	public override function begin()
	{
		HXP.console.log(["GameOver Scene executed!"]);

		add(GM);

		add(new GameOverSplash(0,0));

	}
	public override function end(){
		removeAll();
	}
}