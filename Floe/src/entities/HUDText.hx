// Description:  Displays current lake and score in the game.
// Notes:  Should use 'getScore()' from 'GameManager.hx'. Or
//   could get data from 'HUD.hx'.
// 'GameManager.hx' also needs to count the completion of
//   levels for use in this class.
package entities;

import com.haxepunk.Entity;

class HUDText extends Entity {
	// Initialize text fields
	//private var textScore = new Text("", 0, 0, 0, 0);
	//private var textLevel = new Text("", 0, 0, 0, 0);

	// Constructor
	public function new(x:Int, y:Int){
		super(x, y);
	}
}
