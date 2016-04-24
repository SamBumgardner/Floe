/*Tile
  This is an abstract class for all tiles to inherit from.\
  It provides a public interface change things such as the size of a tile.
*/


package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Tile extends Entity {

	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////


	//all tiles in floe share a common size
    public static var size = 32;
	
	public static var commonLayer = 1;
	
	
	// new(x:Int, y:Int)
	//
	// Tile's constructor.
	
	public function new(x:Int, y:Int)
	{
		//call the entity constructor so we can access entity's fields
		super(x, y);
		
		//set the hitbox to the common size
		setHitbox(size,size);
		
		//set layer to value held in commonLayer
		layer = commonLayer;
		
	}

	
	///////////////////////////////////////////
	//             WATER ACTIONS             //
	///////////////////////////////////////////
	
	// pause() 
	//
	// To be overwritten in child classes if necessary.
	
	public function pause(){}
	
	// resume()
	//
	// To be overwritten in child classes if necessary.
	
	public function unpause(){}
}