package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.sound.FlxSound;

class GameState extends FlxState
{
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	// declare static entities
	private static var music:FlxSound;
	public static var GM:GameManager;

	private static var pausedMenu:PauseMenu;
	private static var musicPlaying:Bool = false;

	// Use a single boolean variable to check if the static assets have been set up.
	private static var staticAssetSetup:Bool = false;

	// public var PC:Player;
	// Used for pausing/unpausing the game.
	private var gamePaused:Bool = false;

	// Heads up display
	private var hud:HUD;

	public function new(?gameManager:GameManager) // leading ? means optional parameter.
	{
		super();

		if (gameManager != null)
		{ // This only happens when a new game is started.
			GM = gameManager;
			musicPlaying = false;
		}

		if (!staticAssetSetup)
		{
			// All entity and asset assignments for static variables go here.
			music = FlxG.sound.load("audio/bgm.mp3", 1, true, FlxG.sound.defaultMusicGroup);
			staticAssetSetup = true;
			pausedMenu = new PauseMenu();
		}
		hud = GameManager.hud;
	}

	///////////////////////////////////////////
	//           LEVEL  GENERATION           //
	///////////////////////////////////////////
	// addEnemy( x:Int, y:Int, maxDifficulty:Int, maxMist:Int )
	//
	// Picks an enemy type, then adds that enemy to location (x, y)
	//
	// There's only one enemy type at the moment, so it's rather basic.

	private function addEnemy(x:Int, y:Int, maxDifficulty:Int, maxMist:Int)
	{
		var rand = FlxG.random.float(0, .5);
		if (rand < .11 && maxDifficulty >= 1)
		{
			add(new SampleEnemy(x, y));
			return 1;
		}
		else if (rand < .22 && maxDifficulty >= 2)
		{
			add(new FireEnemy(x, y));
			return 2;
		}
		else if (rand < .33 && maxMist >= 1)
		{
			add(new MistEnemy(x, y));
			return -1;
		}
		else if (rand < .44 && maxDifficulty >= 3)
		{
			add(new LightningEnemy(x, y));
			return 3;
		}
		return 0;
	}

	// generateLevel()
	//
	// Procedurally generates level using HaxePunk's seeded RNG.

	private function generateLevel()
	{
		var tileSize = 32;

		var originX = 0;
		var originY = tileSize * 2;

		var maxX = tileSize * 19;
		var maxY = tileSize * 19;

		var placeX = originX;
		var placeY = originY;

		var playerX = tileSize * 10; // Player's starting X & Y position.
		var playerY = cast(tileSize * Math.min((18 - (6 - GM.lake)), 18));

		var enemyCount = 0; // Counts number of enemies placed in the level.
		var mistEnemyCount = 0;
		var maxEnemies = GM.lake - 1;
		var borderSize = Math.max(7 - GM.lake, 1);

		// To ensure all levels can be completed, we require 2+ non-obstacle tiles
		// to be placed horizontally between obstacles in the lake.
		var minimumSpaceBetweenObstacles = 2;
		var tilesSinceLastObstacle = 0;
		var RocksInPreviousRow = [];
		var RocksInCurrentRow = [];

		PC = new Player(playerX, playerY);
		add(PC);

		while (placeY <= maxY)
		{
			while (placeX <= maxX)
			{
				if (placeX < originX + (tileSize * (borderSize - 1))
					|| placeY < originY + (tileSize * (borderSize - 1))
					|| placeX > maxX - (tileSize * (borderSize - 1))
					|| placeY > maxY - (tileSize * (borderSize - 1)))
				{
					// Do nothing

					placeX += tileSize;
					continue;
				}
				else if (placeX == originX + (tileSize * (borderSize - 1))
					|| placeY == originY + (tileSize * (borderSize - 1))
					|| placeX == maxX - (tileSize * (borderSize - 1))
					|| placeY == maxY - (tileSize * (borderSize - 1)))
				{
					add(new Border(placeX, placeY));

					placeX += tileSize;
					continue;
				}
				else if (placeX == originX + (tileSize * borderSize)
					|| placeY == originY + (tileSize * borderSize)
					|| placeX == maxX - (tileSize * borderSize)
					|| placeY == maxY - (tileSize * borderSize))
				{
					if (placeY == originY + (tileSize * borderSize))
					{
						if (FlxG.random.float() > .95 && enemyCount < Math.min(2, GM.lake) && enemyCount < maxEnemies)
						{
							add(new BorderEnemy(placeX, placeY));
							enemyCount++;
						}
					}

					add(new GroundTile(placeX, placeY));

					placeX += tileSize;
					continue;
				}
				else if (FlxG.random.float() > .15)
				{
					add(new WaterTile(placeX, placeY));
					tilesSinceLastObstacle++;
					if (FlxG.random.float() > .99 && maxEnemies > 0)
					{
						add(new WaterEnemy(placeX, placeY));
					}

					if (FlxG.random.float() < .15 && enemyCount < maxEnemies)
					{
						var result = addEnemy(placeX, placeY, maxEnemies - enemyCount, maxEnemies - mistEnemyCount);
						if (result > 0)
						{
							enemyCount += result;
						}
						if (result < 0)
						{
							mistEnemyCount++;
						}
					}
				}
				else
				{
					if (FlxG.random.float() > .85
						|| tilesSinceLastObstacle < minimumSpaceBetweenObstacles
						|| RocksInPreviousRow.indexOf(placeX) != -1
						|| RocksInPreviousRow.indexOf(placeX + tileSize) != -1
						|| RocksInPreviousRow.indexOf(placeX - tileSize) != -1)
					{
						add(new GroundTile(placeX, placeY));
						tilesSinceLastObstacle++;

						if (FlxG.random.float() < .15 && enemyCount < maxEnemies)
						{
							var result = addEnemy(placeX, placeY, maxEnemies - enemyCount, maxEnemies - mistEnemyCount);
							if (result > 0)
							{
								enemyCount += result;
							}
							if (result < 0)
							{
								mistEnemyCount++;
							}
						}
					}
					else
					{
						add(new Obstacle(placeX, placeY));
						tilesSinceLastObstacle = 0;
						RocksInCurrentRow.push(placeX);
					}
				}

				placeX += tileSize;
			}
			RocksInPreviousRow = RocksInCurrentRow.copy();
			RocksInCurrentRow = [];
			placeX = 0;
			placeY += tileSize;
		}

		// HXP.console.log(["Level has been generated!"]);
	}

	///////////////////////////////////////////
	//            LEVEL START/END            //
	///////////////////////////////////////////
	// create()
	//
	// Called when Main sets an instance of GameScene as the current scene.

	public override function create()
	{
		super.create();

		if (!musicPlaying)
		{
			music.play();
			musicPlaying = true;
		}

		add(GM);

		generateLevel();

		add(hud);

		hud.updateScore(GM.getScore());
	}

	// endMusic()
	//
	// Called when going to the gameOver scene, and not the next level.
	// Stops the looping music.

	public function endMusic()
	{
		music.stop();
	}

	// gameOver()
	//
	// Called when going to the gameOver scene, and not the next level.
	// Returns the GameManager object for the gameOver scene to use.

	public function gameOver()
	{
		return GM;
	}

	///////////////////////////////////////////
	//          PAUSE/UNPAUSE  GAME          //
	///////////////////////////////////////////
	// pauseGame()
	//
	// Iterates through list of entities in the scene, and sets active to false.
	// Will also bring up the pause menu.

	private function pauseGame()
	{
		trace("need to pause the game with substates here!");
	}

	// unpauseGame()
	//
	// Reverses the actions of pauseGame.

	private function unpauseGame()
	{
		trace("need to unpause the game (stop the substate) here!");
	}

	///////////////////////////////////////////
	//            UPDATE FUNCTION            //
	///////////////////////////////////////////
	// update()
	//
	// Called every frame to update the scene.
	// Used to check if the player paused or unpaused the game.

	public override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			if (!GM.levelCompleted && !GM.levelFailed)
			{
				if (!gamePaused)
				{
					gamePaused = true;
					pauseGame();
				}
				else if (gamePaused)
				{
					gamePaused = false;
					unpauseGame();
				}
			}
		}

		super.update(elapsed);
	}
}
