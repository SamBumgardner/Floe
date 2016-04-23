package scenes;

import com.haxepunk.HXP; //for debug
import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.Sfx;

import entities.MenuSelector;


class MainMenu extends Scene
{
	
	private var music:Sfx;
	
	
	// Constructor
	
	public function new()
	{
		super();
	}
	
	
	// begin()
	//
	// Called when the scene becomes the current scene.
	
	public override function begin()
	{
		//HXP.console.log(["MainMenu scene executed!"]);
		
		
		music = new Sfx("audio/bgm.mp3");
		music.loop(HXP.engine.musicVolume);
		
		addGraphic(new Image("graphics/mainMenu.png"), 2);
		addGraphic(new Image("graphics/playGameButton.png"), 1, 280, 380);
		addGraphic(new Image("graphics/howToPlayButton.png"), 1, 280, 430);
		addGraphic(new Image("graphics/randomSeedButton.png"), 1, 280, 480);
		addGraphic(new Image("graphics/creditsButton.png"), 1, 280, 530);
		
		add(new MenuSelector(310, 388));
		
		
		
	}
	
	
	// end()
	//
	// Called after the scene is no longer the current scene.
	
	public override function end(){
	
		music.stop();
		removeAll();
		super.end();
	
	}
}