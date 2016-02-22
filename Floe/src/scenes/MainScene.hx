package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import entities.Player;
import entities.WaterTile;


class MainScene extends Scene
{
	public function new()
	{
		super();
	}
	public override function begin()
	{
		
		var dimensionX = 10;
		//var dimensionY = 20
		var placeX = 32;
		var placeY = 32;
		var playerX = 0;
		var playerY = 0;
		var numOfTiles = 60; //controls number of water tiles initially placed.
		
		add(new Player(playerX, 0));
		
		while(numOfTiles > 0){
			if(Math.random() > .1){
				add(new WaterTile(placeX, placeY));
				numOfTiles -= 1;
			}
			placeX += 32;
			if(placeX > 32 * dimensionX){
				placeX = 32;
				placeY +=32;
			}
		}
	}
}