package scenes;


import com.haxepunk.HXP; //for debug
import com.haxepunk.Scene;
import entities.GameOverSplash;
import entities.Player;
import entities.GameManager;

class GameOver extends Scene
{

	public var GM:GameManager;

	
	// Constructor
	
	public function new(gm:GameManager)
	{
		super();
		GM = gm;
	}
	
	
	// begin()
	//
	// Called when the scene becomes the current scene.
	
	public override function begin()
	{
		//HXP.console.log(["GameOver Scene executed!"]);
		
		add(GM);
		
		add(new GameOverSplash(0,0));
		
	}
	
	
	// end()
	//
	// Called after the scene is no longer the current scene.
	
	public override function end(){
		removeAll();
		super.end();
	}
}