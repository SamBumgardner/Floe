package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import openfl.events.KeyboardEvent;

class MenuSelector extends FlxSprite
{
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	private var moveDisabled:Bool;
	private var horizontalMove:Int;
	private var pageSelect:Bool;
	private var popUp:FlxSprite; // Reference to an entity that will be removed later.
	private var page1:FlxSprite;
	private var page2:FlxSprite;

	private var moveDistance:Int;
	private var verticalMove:Int;

	private var menuMove:FlxSound;
	private var menuSelect:FlxSound;

	private var currentUserSeed:String;
	private var tempUserSeed:String;
	private var txtReference:FlxSprite;
	private var displayTempUserSeed:FlxText;
	private var displayCurrentUserSeed:FlxText;

	private var currentPos:Int; // Used to determine what to do when the player presses spacebar
	private var numOfPos:Int; // Used to determine the boundaries of MenuSelector's movement.

	// Constructor

	public function new(x:Int, y:Int)
	{
		super(x, y);

		// layer is implicitly 0
		moveDisabled = false;
		verticalMove = 0;
		horizontalMove = 0;
		moveDistance = 50;

		loadGraphic(AssetPaths.MenuSelector__png);
		page1 = new FlxSprite(AssetPaths.infoGraphic_p1__png);
		page2 = new FlxSprite(AssetPaths.infoGraphic_p2__png);
		page1.visible = false;
		page2.visible = false;

		currentPos = 1;
		numOfPos = 4;

		menuMove = FlxG.sound.load(AssetPaths.menuMove__mp3);
		menuSelect = FlxG.sound.load(AssetPaths.menuSelect__mp3);

		currentUserSeed = (cast Math.floor(Math.random() * 1000000000));
		tempUserSeed = "";

		displayCurrentUserSeed = new FlxText(75, 610, "Seed: " + currentUserSeed);
		displayCurrentUserSeed.size = 16;

		keyboardListener();
	}

	// added()
	//
	// Called when the entity is added to a scene.
	public function added()
	{
		FlxG.state.add(page1);
		FlxG.state.add(page2);
		FlxG.state.add(displayCurrentUserSeed);
	}

	///////////////////////////////////////////
	//           SELECTOR  ACTIONS           //
	///////////////////////////////////////////
	// selectOption()
	//
	// Executes the some actions when the player selects/exits
	// a menu option.

	private function selectOption()
	{
		// 1 = Play Game
		// 2 = How To Play
		// 3 = Set Random Seed
		// 4 = Credits

		if (moveDisabled)
		{
			// Back out of current menu
			switch currentPos
			{
				case 2:
					removeInfographic();
				case 3:
					removeSeedSelection();
				case 4:
					removeCredits();
			}
		}
		else
		{
			menuSelect.play();
			// Start selected option
			switch currentPos
			{
				case 1:
					trace("going to start game!"); // HXP.engine.startGame(currentUserSeed);
				case 2:
					displayInfographic();
				case 3:
					displaySeedSelection();
				case 4:
					displayCredits();
			}
		}
	}

	// displayInfographic()
	//
	// Disables control of menu movement.
	// Renders the first page of the "how to play" infographic to the screen.

	private function displayInfographic()
	{
		horizontalMove = -1;
		page1.visible = true;
		pageSelect = true;
		moveDisabled = true;
	}

	// removeInfographic()
	//
	// Re-enables control of menu movement.
	// Stops rendering the "how to play" infographic

	private function removeInfographic()
	{
		page1.visible = false;
		page2.visible = false;
		pageSelect = false;
		moveDisabled = false;
	}

	// displaySeedSelection()
	//
	// Disables control of menu movement.
	// Renders the RNG seed select graphic to the screen.

	private function displaySeedSelection()
	{
		tempUserSeed = "";
		displayTempUserSeed = new FlxText(300, 480, 0, "");
		displayTempUserSeed.size = 48;
		popUp = new FlxSprite(AssetPaths.rngSeed__png);
		FlxG.state.add(popUp);
		FlxG.state.add(displayTempUserSeed);
		moveDisabled = true;
	}

	// removeSeedSelection()
	//
	// Re-enables control of menu movement.
	// Removes the seed selection graphic & text from the scene.

	private function removeSeedSelection()
	{
		FlxG.state.remove(popUp);
		FlxG.state.remove(txtReference);

		displayCurrentUserSeed.text = "Seed: " + currentUserSeed;
		displayTempUserSeed.text = "";

		moveDisabled = false;
	}

	// displayCredits()
	//
	// Disables control of menu movement.
	// Renders the credits graphic to the screen.

	private function displayCredits()
	{
		popUp = new FlxSprite(AssetPaths.credits__png);
		FlxG.state.add(popUp);
		moveDisabled = true;
	}

	// removeCredits()
	//
	// Re-enables control of menu movement.
	// Removes the credits graphic from the scene.

	private function removeCredits()
	{
		FlxG.state.remove(popUp);
		horizontalMove = 0;
		moveDisabled = false;
	}

	///////////////////////////////////////////
	//            KEYBOARD  INPUT            //
	///////////////////////////////////////////
	// keyboardListener()
	//
	// Creates an event listener that fires after keyboard input.
	// Adapted from Byron's code for Vocabulistics.

	function keyboardListener()
	{
		// -- Listens for keyboard input --

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
	}

	// keyDown()
	//
	// Only active when the "set random seed" option is selected.
	// It interprets, tracks, and stores numeric keyboard inputs to set HaxePunk's
	// random number generator's seed.

	function keyDown(event:KeyboardEvent)
	{
		// -- handles numeric input --
		if (moveDisabled && currentPos == 3)
		{
			var code = event.keyCode;
			// Check if the input string isn't too big, and that the key was a number
			if (tempUserSeed.length < 9 && ((code >= 48 && code < 58) || (code >= 96 && code < 106)))
			{
				if (code > 95)
				{
					code -= 48;
				}
				tempUserSeed += String.fromCharCode(code);
			}
			else if (code == 8)
			{ // if the input is backspace
				tempUserSeed = tempUserSeed.substring(0, tempUserSeed.length - 1);
			}
			if (code == 13 || code == 32)
			{ // if the input is 'enter' or 'spacebar'
				if (tempUserSeed == "")
				{
					tempUserSeed = (cast Math.floor(Math.random() * 1000000000));
				}
				currentUserSeed = (cast Std.parseInt(cast tempUserSeed));
				if (currentUserSeed == "0")
				{
					currentUserSeed = "1";
				}
				tempUserSeed = "";
			}
			else if (code == 27)
			{ // if the input is 'escape'
				tempUserSeed = "";
				removeSeedSelection();
			}
			else
			{
				displayTempUserSeed.text = tempUserSeed; // update the input string display
			}
		}
	}

	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////
	// update()
	//
	// Function that is called every frame.
	// Used here for gathering and applying player input.
	public override function update(elapsed:Float)
	{
		// Check for user input: UP, DOWN
		if (FlxG.keys.justPressed.UP)
		{
			verticalMove--;
		}
		if (FlxG.keys.justPressed.DOWN)
		{
			verticalMove++;
		}
		if (FlxG.keys.justPressed.LEFT)
		{
			horizontalMove = horizontalMove + 2;
		}
		if (FlxG.keys.justPressed.RIGHT)
		{
			horizontalMove = horizontalMove - 2;
		}
		// Calculate the next move location
		var tempPos:Int = currentPos + verticalMove;
		if (moveDisabled && pageSelect)
		{
			if (horizontalMove < 0)
			{
				page1.visible = false;
				page2.visible = true;
			}
			if (horizontalMove > 0)
			{
				page2.visible = false;
				page1.visible = true;
			}
			if (FlxG.keys.justPressed.ESCAPE)
			{
				removeInfographic();
			}
			horizontalMove = 0;
		}
		// If selector can move and location is valid, move the selector and play a SFX.
		if (!moveDisabled && (0 != verticalMove) && (0 < tempPos) && (tempPos <= numOfPos))
		{
			y += verticalMove * moveDistance;
			currentPos = tempPos;
			menuMove.play();
		}
		verticalMove = 0;
		// Check for user input: SPACE, ENTER
		if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER)
		{
			selectOption();
		}
		horizontalMove = 0;
		super.update(elapsed);
	}
}
