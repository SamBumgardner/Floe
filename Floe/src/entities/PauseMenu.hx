package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import com.haxepunk.HXP;
import scenes.GameScene;

class PauseMenu extends Entity
{

	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	private static var moveDistance:Int = 50;
	private static var verticalMove:Int = 0;
	
	private static var menuMove:Sfx;
	private static var menuPaused:Sfx;
	private static var menuUnpaused:Sfx;
	
	private static var assetsInitialized;
	
	private static var containerImg:Image;
	private static var selectorImg:Image;
	private static var pausedTextImg:Text;
	private static var resumeTextImg:Text;
	private static var quitTextImg:Text;
	private static var seedTextImg:Text;
	
	private var containerEnt:Entity;
	private var pausedTextEnt:Entity;
	private var resumeTextEnt:Entity;
	private var quitTextEnt:Entity;
	private var seedTextEnt:Entity;
	
	private var currentPos:Int; // Used to determine what to do when the player presses spacebar
	private var numOfPos:Int; // Used to determine the boundaries of the selector's movement.
	
	private var playUnpauseSound:Bool = true; 

	
	// new()
	//
	// Constructor for the PauseMenu class.
	
	public function new(){
		super(265, 300);
		
		layer = -1000; //Must always be at the very front.
		
		if( assetsInitialized == false ){
			menuMove = new Sfx("audio/menuMove.mp3");
			menuPaused = new Sfx("audio/pause.mp3");
			menuUnpaused = new Sfx("audio/unpause.mp3");
			
			containerImg = new Image("graphics/pauseMenu.png");
			selectorImg = new Image("graphics/MenuSelector.png");
			
			pausedTextImg = new Text("PAUSED");
			pausedTextImg.setTextProperty("size", 48);
			resumeTextImg = new Text("Resume");
			resumeTextImg.setTextProperty("size", 24);
			quitTextImg = new Text("Quit");
			quitTextImg.setTextProperty("size", 24);
			seedTextImg = new Text("");
			seedTextImg.setTextProperty("size", 16);
			
			assetsInitialized = true;
		}
		graphic = selectorImg;
		
	}
	
	
	// added()
	//
	// Function from the Entity class. Is called when this is added to the scene.
	
	public override function added(){
		seedTextImg.text = "Seed: " + HXP.randomSeed;
	
		containerEnt = HXP.scene.addGraphic(containerImg, -999, 160, 220);
		pausedTextEnt = HXP.scene.addGraphic(pausedTextImg, -1000, 320 - (pausedTextImg.width)/2, 230);
		resumeTextEnt = HXP.scene.addGraphic(resumeTextImg, -1000, 300 , 300);
		quitTextEnt = HXP.scene.addGraphic(quitTextImg, -1000, 300 , 350);
		seedTextEnt = HXP.scene.addGraphic(seedTextImg, -1000, 320 - (seedTextImg.width)/2, 385);
		currentPos = 1;
		numOfPos = 2;
		y = 300;
		playUnpauseSound = true; 
		
		menuPaused.play(.5);
		super.added();
	}
	
	
	// removed()
	//
	// Called when this entity is removed from the scene.
	
	public override function removed(){
		if( playUnpauseSound ){ menuUnpaused.play(.5); }
		
		HXP.scene.remove( containerEnt );
		HXP.scene.remove( resumeTextEnt );
		HXP.scene.remove( quitTextEnt );
		HXP.scene.remove( pausedTextEnt );
		HXP.scene.remove( seedTextEnt );
		super.removed();
	}
	
	
	///////////////////////////////////////////
	//           PAUSE MENU ACTIONS          //
	///////////////////////////////////////////
	
	private function selectOption(){
		// 1 = Resume Game
		// 2 = Quit
		// Start selected option
		switch currentPos{
			case 1: (cast HXP.scene).unpauseGame();
			case 2: {
				playUnpauseSound = false;
				HXP.engine.gameOver();
			}
		}

	}
	

	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////
	
	// update()
	//
	// Called every frame to update the entity.
	
	public override function update(){
		// Check for user input: UP, DOWN
		if (Input.pressed(Key.UP)){ verticalMove--; }
		if (Input.pressed(Key.DOWN)){ verticalMove++; }
		// Calculate the next move location
		var tempPos:Int = currentPos + verticalMove;

		// If selector can move and location is valid, move the selector and play a SFX.
		if( (0 != verticalMove)
			&& (0 < tempPos)
			&& (tempPos <= numOfPos)){
				moveBy(0, verticalMove * moveDistance);
				currentPos = tempPos;
				menuMove.play(.5);
		}
		verticalMove = 0;
		
		// Check for user input: SPACE, ENTER
		if(Input.pressed(Key.SPACE) || Input.pressed(Key.ENTER)){
			selectOption();
		}
			
		super.update();
	}
		
}
