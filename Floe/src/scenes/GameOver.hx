package scenes;

import com.haxepunk.HXP; //for debug
import com.haxepunk.Scene;
import entities.GameOverSplash;
import entities.Player;

class GameOver extends Scene
{
	public function new()
	{
		super();
	}
	public override function begin()
	{
		
		HXP.console.log(["GameOver Scene executed!"]);
		
		add(new GameOverSplash(0,0));
		
	}
}