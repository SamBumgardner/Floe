package entities;

import com.haxepunk.Entity;
import entities.HUDHealth;
import com.haxepunk.graphics.Text;

class HUD extends Entity {
    private var health:HUDHealth = new HUDHealth(0,0);
    private var textScore = new Text("score", 500, 0, 0, 0);
    private var textLevel = new Text("level", 290, 0, 0, 0);
    
    public function new(x:Int, y:Int){
        super(x, y);
		    addGraphic(textScore);
		    addGraphic(textLevel);
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
				health.updateHealth(health);
    }
}