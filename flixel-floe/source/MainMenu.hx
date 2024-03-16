package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class MainMenu extends FlxState
{
	override public function create()
	{
		super.create();
		FlxG.sound.playMusic("audio/bgm__mp3", 1, true);

		add(new FlxSprite(AssetPaths.mainMenu__png));
		add(new FlxSprite(280, 380, AssetPaths.playGameButton__png));
		add(new FlxSprite(280, 430, AssetPaths.howToPlayButton__png));
		add(new FlxSprite(280, 480, AssetPaths.randomSeedButton__png));
		add(new FlxSprite(280, 530, AssetPaths.creditsButton__png));

		var menuSelector = new MenuSelector(309, 388);
		add(menuSelector);
		menuSelector.added();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
