// Description:  Displays one heart for each health of the player.
// Note:  Should use 'playerHealth' from 'GameManager.hx' by using
//   the new function 'getPlayerHealth()'. Or could get data from
//   'HUD.hx'.
package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class HUDHealth extends Entity
{
	// Initialize:  images, width, margins, and curse status.
	// imgBG:  Same color as the background. Replaces hearts when at low health.
	private var imgBG = new Image("graphics/bg_gray.png");
	private var imgHeart = new Image("graphics/heart.png");
	private var imgHeartGreen = new Image("graphics/heartGreen.png");
	private var imgWidth:Int = 32;
	// imgMargin:  Pixels of space between hearts.
	private var imgMargin:Int = 4;
	// curse:  While true, use 'imgHeartGreen'. While false, use 'imgHeart'.
	private var curse:Bool = false;

	// Constructor
	// Q: Should the constructor require a starting amount of health?
	// A:
	public function new(x:Int, y:Int){
		super(x, y);
		initialize();
	}

	private function initialize():Void{
		// INSERT CODE HERE
	}

	public setHealth(health:Int){
		// TODO: Check if cursed,
		//   then set current heart image string,
		//   then set/add images.
		for (index in 0..health){
			if (index < health) {
				// TODO: Set/Add heart image
				;
			} else {
				// TODO: Set/Add bg image
				;
			}
		}
	}

	public setCurse(isCursed:Boolean){
		curse = isCursed;
	}

	public toggleCurse(){
		curse = !curse;
	}
}
