package entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import com.haxepunk.HXP;

class MenuSelector extends Entity
{
	private var moveDisabled:Bool;
	private var horizontalMove:Int;
	private var pageSelect:Bool;
	private var popUp:Entity; //Reference to an entity that will be removed later.
	private var page1:Graphic;
	private var page2:Graphic;
	
	private var moveDistance:Int;
	private var verticalMove:Int;
	
	private var menuMove:Sfx;
	private var menuSelect:Sfx;
	
	private var userSeed:String;
	private var txtReference:Entity;
	private var displayUserSeed:Text;
	
	private var currentPos:Int; //Used to determine what to do when the player presses spacebar
	private var numOfPos:Int; //Used to determine the boundaries of MenuSelector's movement.

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
	
	private function selectOption(){
		// 1 = Play Game
		// 2 = How To Play
		// 3 = Set Random Seed
		// 4 = Credits
		//I'm not quite sure how enums work in Haxe, but using it would be better, I think.
	
		if(moveDisabled){
			// Back out of current menu
			switch currentPos{
				case 2: removeInfographic();
				case 3: removeSeedSelection();
				case 4: removeCredits();
			}
		}
		
		else{
			menuSelect.play(.5);
			// Start selected option
			switch currentPos{
				case 1: HXP.engine.startGame(userSeed);
				case 2: displayInfographic();
				case 3: displaySeedSelection();
				case 4: displayCredits();
			}
		}
	}
	
	private function displayInfographic(){
		scene.addGraphic(page1, -1);
		scene.addGraphic(page2, -1);
		horizontalMove = -1;
		page1.visible=true;
		pageSelect = true;
		moveDisabled = true;
	}
	
	private function removeInfographic(){
		page1.visible = false;
		page2.visible = false;
		pageSelect = false;
		moveDisabled = false;
	}
	
	private function displaySeedSelection(){
		userSeed = "";
		displayUserSeed = new Text("", 300, 480, 0, 0);
		displayUserSeed.setTextProperty("color", 0);
		displayUserSeed.setTextProperty("size", 48);
		popUp = scene.addGraphic( new Image("graphics/rngSeed.png"));
		txtReference = scene.addGraphic(displayUserSeed);
		moveDisabled = true;
	}
	
	private function removeSeedSelection(){
		scene.remove(popUp);
		scene.remove(txtReference);
		moveDisabled = false;
	}
	
	//The code below is kinda redundant now, but the infographic and credits behavior
	// will likely diverge as the project approaches completion.
	private function displayCredits(){
		popUp = scene.addGraphic( new Image("graphics/credits.png"), -1);
		moveDisabled = true;
	}
	
	private function removeCredits(){
		scene.remove(popUp);
		horizontalMove = 0;
		moveDisabled = false;
	}
	
	/// Adapted from Byron's code for Vocabulistics.
	function keyboardListener(){
    // -- Listens for keyboard input --
     
		flash.Lib.current.stage.addEventListener(
			flash.events.KeyboardEvent.KEY_DOWN, keyDown
		);
	}
    
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
				menuMove.play(.5);
		}
		verticalMove = 0;
		
		// Check for user input: SPACE, ENTER
		if(Input.pressed(Key.SPACE) || Input.pressed(Key.ENTER)){
			selectOption();
		}
		
		horizontalMove = 0;
		super.update();
	}
	
	public function destroy(){
		flash.Lib.current.stage.removeEventListener(
                flash.events.KeyboardEvent.KEY_DOWN, keyDown
		);
	}
}
