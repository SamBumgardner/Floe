package entities;


import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import com.haxepunk.HXP;

import utilities.DbInterface; // For high score reporting

class GameOverSplash extends Entity{

	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////

	private var gameOverTag:Sfx;
	
	private var scoreInfo:Text  = new Text("", 130, 460);
	private var entryField:Text = new Text("Type 3 initials: ", 130, 510, 0, 0);
	private var instructions:Text = new Text(
	"Press [Enter] to submit your score.\nPress [Esc] to return to the Main Menu.", 70, 560, 0, 0);
	
	private var seedTextImg:Text = new Text("Seed: " + HXP.randomSeed);
	
	private var playerScore:Int;
	private var input:String = "";

	public function new(x:Int, y:Int)
	{
		super(x,y);
		
		graphic = new Image("graphics/newGameOver.png");
		
		gameOverTag = new Sfx("audio/got.mp3");
		gameOverTag.play(HXP.engine.musicVolume);
		
		playerScore = (cast HXP.scene).GM.getScore();
		
		scoreInfo.text = "Your score was: " + playerScore;
		scoreInfo.size = 32;
		entryField.size = 25;
		instructions.size = 20;
		seedTextImg.size = 16;
		
		HXP.scene.addGraphic(scoreInfo, -1);
		HXP.scene.addGraphic(entryField, -1);
		HXP.scene.addGraphic(instructions, -1);
		HXP.scene.addGraphic(seedTextImg, -1, 320 - (seedTextImg.width)/2, 610);
		
		KeyboardListener();
	}

	
	///////////////////////////////////////////
	//            ENTITY  ACTIONS            //
	///////////////////////////////////////////
	
	// sendScore()
	//
	// uses the DbInterface object to send the user's score to the website's high score list.
	
	private function sendScore(){
	
		var myDbInterface = new DbInterface("floe");
		myDbInterface.sendDataToDb(entryField.text, playerScore);
	
	}

	
	
	///////////////////////////////////////////
	//             INPUT PARSING             // 
	///////////////////////////////////////////
	
	// This was taken directly from Vocabulistics, and was written by Byron Himes.
	
	
	 // This function is for attaching the keyboard listener and input callback.
    private function KeyboardListener()
    {
           // -- Listens for keyboard input --
           
            flash.Lib.current.stage.addEventListener(
                flash.events.KeyboardEvent.KEY_DOWN, keyDown
            );
        
    }
    
	
    // This is the callback function for the keyboard input
    private function keyDown(event: flash.events.KeyboardEvent)
    {
        // -- handles keyboard input --
        var code = event.keyCode;
        
        // if the input is a letter A-Z:
        if (code >= 65 && code < 91 && input.length < 3){
            input += String.fromCharCode(event.keyCode);
        }
        
        // Else if the input is BACKSPACE, delete last letter from tin/t.text;
        else if (code == 8){    // if the input is backspace
            input = input.substring(0, input.length - 1);
        }
        
        // Else if the input is ENTER and there are 3 initials entered, go to the main menu (TO BE CHANGED)
        else if (code == 13 && input.length == 3){   // if the input is 'enter'
            sendScore();
			flash.Lib.current.stage.removeEventListener(
                flash.events.KeyboardEvent.KEY_DOWN, keyDown
			);
			HXP.scene.addGraphic( new Image("graphics/scoreSubmitted.png"), -1, 100, 200);
            haxe.Timer.delay(
			function(){
				gameOverTag.stop();
				HXP.engine.returnToMenu();}, 2000);
        }
		else if (code == 27){
			gameOverTag.stop();
			flash.Lib.current.stage.removeEventListener(
                flash.events.KeyboardEvent.KEY_DOWN, keyDown
			);
            HXP.engine.returnToMenu();
		}
        
        // update gui display
        entryField.text = "Type 3 initials: " + input;
    }
    
   
}