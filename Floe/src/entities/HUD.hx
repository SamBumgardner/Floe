package entities;

import com.haxepunk.Entity;
import entities.HUDHealth;
import entities.HUDText;

class HUD extends Entity {
    private var health:HUDHealth = new HUDHealth();
    private var text:HUDText = new HUDText();
    
    public function new(x:Int, y:Int){
        super(x, y);
    }
    
    public function updateScore(score:Int):Void{
        
    }
    
    public function updateLake(lakeID:Int):Void{
    
    }
    
    public function updateHealth(health:Int):Void{
    
    }
}