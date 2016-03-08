package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
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
		
	
	}
	
	private function selectOption(){
	
	
		if(moveDisabled){
			switch currentPos{
				case 2: removeInfographic();
				case 3: HXP.console.log(["Stop selecting Random Seed."]);
				case 4: removeCredits();
			}
		}
		else{
			menuSelect.play(.5);
			
			switch currentPos{
				case 1: HXP.engine.nextLevel();
				case 2: displayInfographic();
				case 3: HXP.console.log(["Select Random Seed"]);
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