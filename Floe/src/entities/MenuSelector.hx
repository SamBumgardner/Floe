package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import com.haxepunk.HXP;

class MenuSelector extends Entity
{

	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////

	private var moveDisabled:Bool;
	private var horizontalMove:Int;
	private var pageSelect:Bool;
	private var popUp:Entity; //Reference to an entity that will be removed later.
	private var page1:Image;
	private var page2:Image;
	
	private var moveDistance:Int;
	private var verticalMove:Int;
	
	private var menuMove:Sfx;
	private var menuSelect:Sfx;
	
	private var userSeed:String;
	private var txtReference:Entity;
	private var displayUserSeed:Text;
	
	private var currentPos:Int; //Used to determine what to do when the player presses spacebar
	private var numOfPos:Int; //Used to determine the boundaries of MenuSelector's movement.

	
	// Constructor
	
	public function new( x:Int, y:Int ){
		super(x, y);
		
		// layer is implicitly 0
		moveDisabled = false;
		horizontalMove = 0;
		moveDistance = 50;
		
		graphic = new Image("graphics/MenuSelector.png");
		page1 = new Image("graphics/infoGraphic_p1.png");
		page2 = new Image("graphics/infoGraphic_p2.png");
		page1.visible = false;
		page2.visible = false;
		
		currentPos = 1;
		numOfPos = 4;
		
		menuMove = new Sfx("audio/menuMove.mp3");
		menuSelect = new Sfx("audio/menuSelect.mp3");
		
		userSeed = "";
		keyboardListener();
	}
	
	
	// added()
	//
	// Called when the entity is added to a scene.
	
	public override function added(){
		scene.addGraphic(page1, -1);
		scene.addGraphic(page2, -1);
	}
	
	// removed()
	//
	// Called when this entity is removed from the scene.
	
	public override function removed(){
		flash.Lib.current.stage.removeEventListener(
                flash.events.KeyboardEvent.KEY_DOWN, keyDown
		);
	}
	
	///////////////////////////////////////////
	//           SELECTOR  ACTIONS           //
	///////////////////////////////////////////
	
	// selectOption()
	//
	// Executes the some actions when the player selects/exits
	// a menu option.
	
	private function selectOption(){
		// 1 = Play Game
		// 2 = How To Play
		// 3 = Set Random Seed
		// 4 = Credits

		if(moveDisabled){
			// Back out of current menu
			switch currentPos{
				case 2: removeInfographic();
				case 3: removeSeedSelection();
				case 4: removeCredits();
			}
		}
		
		else{
			menuSelect.play(HXP.engine.sfxVolume);
			// Start selected option
			switch currentPos{
				case 1: HXP.engine.startGame(userSeed);
				case 2: displayInfographic();
				case 3: displaySeedSelection();
				case 4: displayCredits();
			}
		}
	}
	
	
	// displayInfographic()
	//
	// Disables control of menu movement.
	// Renders the first page of the "how to play" infographic to the screen.
	
	private function displayInfographic(){
		horizontalMove = -1;
		page1.visible=true;
		pageSelect = true;
		moveDisabled = true;
	}
	
	
	// removeInfographic()
	//
	// Re-enables control of menu movement.
	// Stops rendering the "how to play" infographic
	
	private function removeInfographic(){
		page1.visible = false;
		page2.visible = false;
		pageSelect = false;
		moveDisabled = false;
	}
	
	
	// displaySeedSelection()
	//
	// Disables control of menu movement.
	// Renders the RNG seed select graphic to the screen.
	
	private function displaySeedSelection(){
		userSeed = "";
		displayUserSeed = new Text("", 300, 480, 0, 0);
		displayUserSeed.setTextProperty("color", 0);
		displayUserSeed.setTextProperty("size", 48);
		popUp = scene.addGraphic( new Image("graphics/rngSeed.png"));
		txtReference = scene.addGraphic(displayUserSeed);
		moveDisabled = true;
	}
	
	
	// removeSeedSelection()
	//
	// Re-enables control of menu movement.
	// Removes the seed selection graphic & text from the scene.
	
	private function removeSeedSelection(){
		scene.remove(popUp);
		scene.remove(txtReference);
		moveDisabled = false;
	}
	
	
	// displayCredits()
	//
	// Disables control of menu movement.
	// Renders the credits graphic to the screen.
	
	private function displayCredits(){
		popUp = scene.addGraphic( new Image("graphics/credits.png"), -1);
		moveDisabled = true;
	}
	
	
	// removeCredits()
	//
	// Re-enables control of menu movement.
	// Removes the credits graphic from the scene.
	
	private function removeCredits(){
		scene.remove(popUp);
		horizontalMove = 0;
		moveDisabled = false;
	}
	
	
	///////////////////////////////////////////
	//            KEYBOARD  INPUT            //
	///////////////////////////////////////////
	
	
	// keyboardListener()
	//
	// Creates an event listener that fires after keyboard input.
	// Adapted from Byron's code for Vocabulistics.
	
	function keyboardListener(){
    // -- Listens for keyboard input --
     
		flash.Lib.current.stage.addEventListener(
			flash.events.KeyboardEvent.KEY_DOWN, keyDown
		);
	}
	
	
	// keyDown()
	//
	// Only active when the "set random seed" option is selected.
	// It interprets, tracks, and stores numeric keyboard inputs to set HaxePunk's
	// random number generator's seed.
    
    function keyDown(event: flash.events.KeyboardEvent){
		// -- handles numeric input --
	
		if(moveDisabled && currentPos == 3){
			var code = event.keyCode;
			
			// Check if the input string isn't too big, and that the key was a number
			if (userSeed.length < 9 && ((code >= 48 && code < 58) || (code >= 96 && code < 106))){   
				if(code > 95){
					code -= 48;
				}
				userSeed += String.fromCharCode(code);
			}
			else if (code == 8){    // if the input is backspace
				userSeed = userSeed.substring(0, userSeed.length - 1);
			}
			if (code == 13){   // if the input is 'enter'
				//The removeSeedSelection() function is called by selectOption()
			}
			else if(code == 27){ // if the input is 'escape'
				userSeed = "";
				removeSeedSelection();
			}
			else{
				displayUserSeed.text = userSeed;   // update the input string display
			}
		}
    }
	
	
	
	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////
	
	// update()
	//
	// Function that is called every frame.
	// Used here for gathering and applying player input.
	
	public override function update(){
		// Check for user input: UP, DOWN
		if (Input.pressed(Key.UP)){ verticalMove--; }
		if (Input.pressed(Key.DOWN)){ verticalMove++; }
		if (Input.pressed(Key.LEFT)){ horizontalMove = horizontalMove + 2; }
		if (Input.pressed(Key.RIGHT)){ horizontalMove = horizontalMove - 2; }
		
		// Calculate the next move location
		var tempPos:Int = currentPos + verticalMove;

		if(moveDisabled && pageSelect){
			if(horizontalMove < 0){
				page1.visible = false;
				page2.visible = true;
			}
			
			if(horizontalMove > 0){
				page2.visible = false;
				page1.visible = true;
			}
			
			if(Input.pressed(Key.ESCAPE)){
				removeInfographic();
			}
			
			horizontalMove = 0;
		}
	
		// If selector can move and location is valid, move the selector and play a SFX.
		if(!moveDisabled
			&& (0 != verticalMove)
			&& (0 < tempPos)
			&& (tempPos <= numOfPos)){
				moveBy(0, verticalMove * moveDistance);
				currentPos = tempPos;
				menuMove.play(HXP.engine.sfxVolume);
		}
		verticalMove = 0;
		
		// Check for user input: SPACE, ENTER
		if(Input.pressed(Key.SPACE) || Input.pressed(Key.ENTER)){
			selectOption();
		}
		
		horizontalMove = 0;
		super.update();
	}
	
}
