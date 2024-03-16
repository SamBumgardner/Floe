package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.text.FlxText;

class HUD extends FlxSprite
{
	private var textScore = new FlxText(465, 15, "000000000");
	private var textLevel = new FlxText(260, 15, "Lake 1");
	private var textHealth = new FlxText(75, 15, "x 3");

	// Heart images
	private var imgHeart = new FlxSprite(7, 7, AssetPaths.heart__png);

	// Background images
	private var imgBackground = new FlxSprite(AssetPaths.hudBackground__png);
	private var levelBackground = new FlxSprite(AssetPaths.levelBackdrop__png);

	// Constructor
	public function new(x:Int, y:Int, startHP:Int)
	{
		super(x, y);

		textScore.size = 30;
		textScore.alignment = RIGHT;
		textLevel.size = 30;
		textHealth.size = 30;

		imgHeart.scale = new FlxPoint(1.5, 1.5);
	}

	// Adds graphic assets to entity
	public function added()
	{
		FlxG.state.add(textScore);
		FlxG.state.add(textLevel);
		FlxG.state.add(textHealth);

		FlxG.state.add(imgHeart);
		FlxG.state.add(imgBackground);
		FlxG.state.add(levelBackground);
	}

	// Updates the score text field on the HUD to the value passed in
	public function updateScore(score:Int):Void
	{
		// Add leading zeroes to score
		var zeroes:String = "";
		var scoreString:String = Std.string(score);
		for (i in 0...(9 - scoreString.length))
		{
			zeroes += "0";
		}
		textScore.text = zeroes + scoreString;
	}

	// Updates the lake number text field on the HUD to the value passed in
	public function updateLake(lakeID:Int):Void
	{
		textLevel.text = "Lake " + Std.string(lakeID);
	}

	// Updates the health text field on the HUD to the value passed in
	public function updateHealth(hp:Int):Void
	{
		textHealth.text = "x " + Std.string(hp);
	}
}
