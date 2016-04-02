package entities;

/* GameOverSplash casts HXP.scene to scenes.GameOver to access the public field GM at:
 *
 * 	Line 35
 *
 * 
 *
 *
*/

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import com.haxepunk.HXP;

class GameOverSplash extends Entity{

	private var gameOverTag:Sfx;
	
	private var scoreInfo:Text;

	public function new(x:Int, y:Int)
	{
		super(x,y);
		
		graphic = new Image("graphics/gameOver.png");
		
		gameOverTag = new Sfx("audio/got.mp3");
		gameOverTag.play(HXP.engine.musicVolume);
		
		scoreInfo = new Text("Your score was: " + cast(HXP.scene, scenes.GameOver).GM.getScore(), 70, 410);
		scoreInfo.setTextProperty("size", 32);
		HXP.scene.addGraphic(scoreInfo, -1);
		
	}

	public override function update(){
		
		if(Input.pressed(Key.SPACE)){
			gameOverTag.stop();
			HXP.engine.returnToMenu();
		}
	}
	
}