part of DROID_AGE;

class Pickup extends Entity {
	Pickup(double x, double y, World world) : super(x, y, world) {
		w = 16;
		h = 16;
	}
	
	bool visible = true;
	int visibleTimer = 120;
	int index = 0;
	
	void loadTexture() {
		texture = Images.TILE_MAP;
	}
	
	void onPickup(Entity e) {	
	}
	
	void resetVisibility() {
		visible = false;
		visibleTimer = 600;
	}
	
	void tick() {
		if(!visible)
			visibleTimer--;
		if(visibleTimer <= 0) {
			visible = true;
		}
	}
	
	void render() {
		if(visible)
			Display.drawTiledImage((x).toInt(), (y).toInt(), texture, index+24, 32);
	}
}

class TorchPickup extends Pickup {
	TorchPickup(double x, double y, World world) : super(x, y, world);
	
	void onPickup(Entity e) {
		if(!visible) return;
		Player p = e as Player;
		p.lights += 5;
		resetVisibility();
	}
}

class HealthPickup extends Pickup {
	HealthPickup(double x, double y, World world) : super(x, y, world);
	
	void onPickup(Entity e) {
		if(!visible) return;
		Droid d = e as Droid;
		d.health += 50;
		if(d.health >= d.maxHealth) {
			d.health = d.maxHealth;
		}
		resetVisibility();
	}
}