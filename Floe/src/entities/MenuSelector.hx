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
	
	private var moveDisabled:Bool;
	private var popUp:Entity; //Reference to an entity that will be removed later.
	
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
		moveDistance = 50;
		graphic = new Image("graphics/menuSelector.png");
		
		currentPos = 1;
		numOfPos = 4;
		
		menuMove = new Sfx("audio/menuMove.mp3");
		menuSelect = new Sfx("audio/menuSelect.mp3");
		
		keyboardListener();
		
	
	}
	
	private function selectOption(){
		// 1 = Play Game
		// 2 = How To Play
		// 3 = Set Random Seed
		// 4 = Credits
		//I'm not quite sure how enums work in Haxe, but using it would be better, I think.
	
		if(moveDisabled){
			switch currentPos{
				case 2: removeInfographic();
				//case 3 is ended by pressing enter instead of spacebar.
				case 4: removeCredits();
			}
		}
		else{
			menuSelect.play(.5);
			
			switch currentPos{
				case 1: HXP.engine.startGame(userSeed);
				case 2: displayInfographic();
				case 3: displaySeedSelection();
				case 4: displayCredits();
			}
		}
		
	
	}
	
	
	
	private function displayInfographic(){
		popUp = HXP.scene.addGraphic( new Image("graphics/infographic.png"), -1);
		moveDisabled = true;
	}
	private function removeInfographic(){
		HXP.scene.remove(popUp);
		moveDisabled = false;
	}
	
	private function displaySeedSelection(){
		userSeed = "";
		displayUserSeed = new Text("", 350, 480, 0, 0);
		displayUserSeed.setTextProperty("color", 0);
		displayUserSeed.setTextProperty("size", 48);
		popUp = HXP.scene.addGraphic( new Image("graphics/rngSeed.png"));
		txtReference = HXP.scene.addGraphic(displayUserSeed);
		moveDisabled = true;
	}
	private function removeSeedSelection(){
		HXP.scene.remove(popUp);
		HXP.scene.remove(txtReference);
		moveDisabled = false;
	}
	
	
	//The code below is kinda redundant now, but the infographic and credits behavior
	// will likely diverge as the project approaches completion.
	
	private function displayCredits(){
		popUp = HXP.scene.addGraphic( new Image("graphics/credits.png"), -1);
		moveDisabled = true;
	}
	private function removeCredits(){
		HXP.scene.remove(popUp);
		moveDisabled = false;
	}
	
	
	
	/// Adapted from Byron's code for Vocabulistics.
	
	function keyboardListener()
    {
           // -- Listens for keyboard input --
           
            flash.Lib.current.stage.addEventListener(
                flash.events.KeyboardEvent.KEY_DOWN, keyDown
            );
        
    }
    
    function keyDown(event: flash.events.KeyboardEvent)
    {
		// -- handles numeric input --
	
		if(moveDisabled && currentPos == 3){
			var code = event.keyCode;
			
			// Check if the input string isn't too big, and that the key was a number
			if (userSeed.length < 5 && ((code >= 48 && code < 58) || (code >= 96 && code < 106))){   
				if(code > 95){
					code -= 48;
				}
				userSeed += String.fromCharCode(code);
			}
			else if (code == 8){    // if the input is backspace
				userSeed = userSeed.substring(0, userSeed.length - 1);
			}
			if (code == 13){   // if the input is 'enter'
				removeSeedSelection(); //stop accepting input.
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
	
	
	
	
	public override function update()
	{
	
		if (Input.pressed(Key.UP)){ verticalMove--; }
		if (Input.pressed(Key.DOWN)){ verticalMove++; }
	
		if(!moveDisabled && ((verticalMove == -1 && currentPos != 1) || (verticalMove == 1 && currentPos != numOfPos))){
			moveBy(0, verticalMove * moveDistance);
			currentPos += verticalMove;
			
			menuMove.play(.5);
			
		}
		verticalMove = 0;
		
		
		if(Input.pressed(Key.SPACE)){
			selectOption();
		}
		
		super.update();
	}
		

}