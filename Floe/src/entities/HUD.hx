package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Image;

class HUD extends Entity {
	private var textScore = new Text("000000000", 465, 15, 0, 0);
	private var textLevel = new Text("Lake 1", 260, 15, 0, 0);
	private var textHealth = new Text("x 3", 75, 15, 0, 0);

	// Heart images
	private var imgHeart = new Image("graphics/heart.png");
	private var imgHeartGreen = new Image("graphics/heartGreen.png");

	// Background image

	private var imgBackground = new Image("graphics/levelBackground.png");

	// Constructor
	public function new(x:Int, y:Int, startHP:Int){
		super(x, y);

		textScore.size = 30;
		textScore.align = JUSTIFY;
		textLevel.size = 30;
		textHealth.size = 30;

		imgHeart.scale = 1.5;
	}

	public override function added(){
		HXP.scene.addGraphic(textScore);
		HXP.scene.addGraphic(textLevel);
		HXP.scene.addGraphic(textHealth);

		HXP.scene.addGraphic(imgHeart, 0, 7, 7);
		HXP.scene.addGraphic(imgBackground, 100, 0, 0);
	}

	public function updateScore(score:Int):Void{
		// Add leading zeroes to score
		var zeroes:String = "";
		var scoreString:String = Std.string(score);
		for (i in 0...(9-scoreString.length)){
			zeroes += "0";
		}
		textScore.text = zeroes + scoreString;
	}

	public function updateLake(lakeID:Int):Void{
		textLevel.text = "Lake " + Std.string(lakeID);
	}

	public function updateHealth(hp:Int):Void{
		textHealth.text = "x " + Std.string(hp);
	}

	/* ONLY IMPLEMENT WHEN ALL ELSE IS WORKING
	public function setCurse(status:Bool){
		if (status){
			imgHeart = imgHeartGreen;
		}
	}
	*/
}
