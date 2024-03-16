package scenes;

import flixel.FlxState;

class GameOverState extends FlxState
{
	public var GM:GameManager;

	// Constructor

	public function new(gm:GameManager)
	{
		super();
		GM = gm;
	}

	// begin()
	//
	// Called when the scene becomes the current scene.

	public override function create()
	{
		super.create();

		add(GM);

		add(new GameOverSplash(0, 0));
	}

	// end()
	//
	// Called after the scene is no longer the current scene.

	public override function end()
	{
		removeAll();
		super.end();
	}
}
