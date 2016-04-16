package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import entities.HUDHealth;
import entities.HUDText;

class HUD extends Entity {
    // private var hearts:HUDHealth = new HUDHealth();
    // private var text:HUDText = new HUDText();
    
    public function new(){
        super(x, y);
    }
    
    public function updateScore(score:Int):Void{
    
    }
    
    public function updateLake(lakeID:Int):Void{
    
    }
    
    public function updateHealth(health:Int):Void{
    
    }
}