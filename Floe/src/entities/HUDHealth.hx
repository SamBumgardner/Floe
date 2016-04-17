// Description:  Displays one heart for each health of the player.
// Note:  Should use 'playerHealth' from 'GameManager.hx' by using
//   the new function 'getPlayerHealth()'. Or could get data from
//   'HUD.hx'.
package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class HUDHealth extends Entity
{
	// Initialize images.
	// imgBG:  Same color as the background. Replaces hearts when at low health.
	private var imgBG = new Image("graphics/bg_gray.png");
	private var imgHeart = new Image("graphics/heart.png");
	private var imgHeartGreen = new Image("graphics/heartGreen.png");

	// Initialize width, margin between hearts, and curse status.
	private var imgWidth:Int = 32;
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

	public function setHealth(health:Int){
		// Check if cursed, set appropriate hearts, then hide missing health.
		// Set/Add current health
		if(curse){
			for (index in 0...health){
				// TODO: Set/Add green heart image
				// graphic[index] = new Image("graphics/heartGreen.png");
				// graphic[index] = imgHeartGreen;
			}
		} else {
			for (index in 0...health){
				// TODO: Set/Add red heart image
				// graphic[index] = new Image("graphics/heart.png");
				// graphic[index] = imgHeart;
			}
		}
		// Hide missing health
		for (index in health...5){
			// TODO: Set/Add bg image
			// graphic[index] = imgBG;
		}
	}

	public function setCurse(isCursed:Bool){
		curse = isCursed;
	}

	public function toggleCurse(){
		curse = !curse;
	}
}
