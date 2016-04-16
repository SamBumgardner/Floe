// Description:  Displays one heart for each health of the player.
// Note:  Should use 'playerHealth' from 'GameManager.hx' by using
//   the new function 'getPlayerHealth()'. Or could get data from
//   'HUD.hx'.
package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class HUDHealth extends Entity
{
	// Initialize heart image
	private var imgHeart = new Image("graphics/heart.png");

	// Constructor
	public function new(x:Int, y:Int){
		super(x, y);
		initialize();
	}

	private function initialize():Void{
		//addGraphic(imgHeart);
		/*
		// Idea: Create the 0-5 hearts with a for-loop.
		for (val in 0..5){
			addGraphic(imgHeart);
		}
		*/
	}
}
