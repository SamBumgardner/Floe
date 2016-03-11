package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import com.haxepunk.HXP;

class GameOverSplash extends Entity{

	private var gameOverTag:Sfx;
	
	private var scoreInfo:Text = new Text("Your score was: " + HXP.engine.gm.getScore(), 70, 410);

	public function new(x:Int, y:Int)
	{
		super(x,y);
		
		graphic = new Image("graphics/gameOver.png");
		
		gameOverTag = new Sfx("audio/got.mp3");
		gameOverTag.play();
		
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