package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import com.haxepunk.HXP;

class GameOverSplash extends Entity{

	public function new(x:Int, y:Int)
	{
		super(x,y);
		
		graphic = new Image("graphics/gameOver.png");
		
		var gameOverTag = new Sfx("audio/got.mp3");
		gameOverTag.play();
		
	}

	public override function update(){
		if(Input.pressed(Key.SPACE)){HXP.engine.nextLevel();}
	}
	
}