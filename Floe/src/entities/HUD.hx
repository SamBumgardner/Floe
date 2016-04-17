package entities;

import com.haxepunk.Entity;
import entities.HUDHealth;
import com.haxepunk.graphics.Text;
//import entities.HUDText;

class HUD extends Entity {
    private var health:HUDHealth = new HUDHealth();
    //private var text:HUDText = new HUDText();
    private var textScore = new Text("", 500, 0, 0, 0);
	private var textLevel = new Text("", 290, 0, 0, 0);
    
    public function new(x:Int, y:Int){
        super(x, y);
    }
    
    public function updateScore(score:Int):Void{
        // add leading zeroes functionality, currently absent
        textScore.text = Std.string(score);
    }
    
    public function updateLake(lakeID:Int):Void{
        // should there be leading zeroes for the lake id?
        textLevel.text = "Lake " + Std.string(lakeID);
    }
    
    public function updateHealth(health:Int):Void{
        // TODO: implement this method
    }
}