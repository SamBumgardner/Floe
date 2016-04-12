/*Tile
  This is an abstract class for all tiles to inherit from.\
  It provides a public interface change things such as the size of a tile.
*/


package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Tile extends Entity {
	//all tiles in floe share a common size
    public static var size = 32;
	
	//all tiles of a given type share a common graphic
    public static var commonImage:Image; //this gets initialized in the const
	
	//Since the assets folder is not guaranteed to be link before static initialization,
	//as a hack we do it in the constructor, and use this boolean to make sure we don't initialize
	//more than once
	public static var graphicInit:Bool = false;
	
	public static var commonLayer = 1;
	
	public function new(x:Int, y:Int)
	{
		//call the entity constructor so we can access entity's fields
		super(x, y);
		
		//set the hitbox to the common size
		setHitbox(size,size);
		
		//set layer to value held in commonLayer
		layer = commonLayer;
		
		//if a the static graphic has not been set, set it here
		if(!graphicInit) {
			commonImage = new Image("graphics/Blank_32x32.png");
			graphicInit = true;
		}
		//now that the static graphic has been set use it to set the image for any tile
		graphic = commonImage;
	}

}