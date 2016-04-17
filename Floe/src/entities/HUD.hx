package entities;

import com.haxepunk.Entity;
import entities.HUDHealth;
import com.haxepunk.graphics.Text;

class HUD extends Entity {
    private var health:HUDHealth = new HUDHealth(0,0);
    private var textScore = new Text("000000000", 450, 0, 0, 0);
	private var textLevel = new Text("Lake 1", 260, 0, 0, 0);
    
    public function new(x:Int, y:Int){
        super(x, y);
		
		textScore.size = 30;
		textScore.align = RIGHT;
		textLevel.size = 30;
		
		
		addGraphic(textScore);
		addGraphic(textLevel);
    }
    
    public function updateScore(score:Int):Void{
        // add leading zeroes functionality, currently absent
		var zeroes:String = "";
		var scoreString:String = Std.string(score);
		for (i in 0...(9-scoreString.length)){
			zeroes += "0";
		}
        textScore.text = zeroes + scoreString;
    }
    
    public function updateLake(lakeID:Int):Void{
        // should there be leading zeroes for the lake id?
        textLevel.text = "Lake " + Std.string(lakeID);
    }
    
    public function updateHealth(health:Int):Void{
        // TODO: implement this method
    }
}