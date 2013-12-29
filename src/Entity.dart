part of DROID_AGE;

class Animator {
	int maxFrame = 4;
	int frame = 0;
	int time = 0;
	int maxTime = 20;
	int tileWidth = 32;
	
	Animator(int f, int mf, int t, int mt) {
		maxFrame = mf;
		frame = f;
		time = t;
		maxTime = mt;
	}
	
	void tick() {
		time++;
		if(time >= maxTime) {
			frame++;
			if(frame >= maxFrame) {
				frame = 0;
			}
			time = 0;
		}
	}
	
	void setTileWidth(int tw) {
		tileWidth = tw;
	}
}

abstract class Entity {
	double x, y;
	double speed = 0.0;
	double rotation = 0.0;
	int rxo = 0, ryo = 0;
	int w, h;
	
	Animator animator;
	ImageElement texture;
	World world;
	bool alive = true;
	
	int direction;
	
	Entity(double x, double y, World world) {
		this.x = x;
		this.y = y;
		this.world = world;
		this.w = 0;
		this.h = 0;
		
		animator = new Animator(0, 4, 0, 15);
		direction = 0;
		loadTexture();
	}
	
	Rectangle getRect() {
		return new Rectangle((x).toInt(), (y).toInt(), w, h);
	}
	
	void loadTexture() {
		texture = Images.DROID;
	}
	
	void tick() {
		animator.tick();
	}
	
	void onRemove() {
	}
	
	bool checkCollision(double ax, double ay) {
		Rectangle rect = new Rectangle(((x + ax) + rxo).toInt(), ((y + ay) + ryo).toInt(), w, h);
		int tx = (x + ax) ~/ Tile.SIZE;
		int ty = (y + ay) ~/ Tile.SIZE;
		
		for(int sy=ty-2; sy<=ty+2; sy++) {
			for(int sx=tx-2; sx<=tx+2; sx++) {
				Tile t = world.getTile(sx, sy);
				Rectangle trect = t.getRect(sx, sy);
				
				if(rect.intersects(trect) && t.solid) {
					return true;
				}
			}
		}
		return false;
	}
	
	void render() {
		Display.drawRotatedTileImage((x).toInt(), (y).toInt(), texture, animator.frame + direction * 4, animator.tileWidth, rotation, 1.0);
	}
}

class Droid extends Entity {
	Droid(double x, double y, World world) : super(x, y, world) {
		legsRot = Math.PI / 4;
		w = 30;
		h = 30;
		rxo = 1;
		ryo = 1;
		speed = 0.0;
	}

	double bodyRot = 0.0;
	double legsRot = 0.0;
	
	int bodyIndex = 0;
	int legsIndex = 0;
	
	int health = 100;
	int maxHealth = 100;
	
	int ammo = 100;
	
	int fireCooldown = 10;
	int maxFireCooldown = 10;
	
	void loadTexture() {
		texture = Images.DROID;
	}
	
	void tick() {
		super.tick();
		move();
		
		fireCooldown--;
		fireCooldown = Math.max(fireCooldown, 0);
	}
	
	void move() {
		double ax = Math.cos(legsRot) * speed;
		double ay = Math.sin(legsRot) * speed;
		if(!checkCollision(ax, 0.0)) {
			x += ax;
		}
		if(!checkCollision(0.0, ay)) {
			y += ay;
		}
	}
	
	void fire() {
		if(fireCooldown == 0) {
			Rocket r = new Rocket(x, y, 3.0 + speed, bodyRot, world);
			world.addEntity(r);
			fireCooldown = maxFireCooldown;
		}	
	}
	
	void render() {
		Display.drawRotatedTileImage((x).toInt(), (y).toInt(), texture, legsIndex, 32, legsRot, 1.0);
		Display.drawRotatedTileImage((x).toInt(), (y).toInt(), texture, bodyIndex + 8, 32, bodyRot, 1.0);
	}
}

class Player extends Droid {
	Player(double x, double y, World world) : super(x, y, world);
	int lights = 5;
	
	void tick() {
		if(Game.keys.isPressed(KeyCode.A)) {
			legsRot -= 0.05;
		} else if (Game.keys.isPressed(KeyCode.D)){
			legsRot += 0.05;
		}
		if(Game.keys.isPressed(KeyCode.W)) {
			speed += 0.05;
		} else {
			speed -= 0.1;
		}
		if(Game.keys.isPressed(KeyCode.S)) {
			speed -= 0.15;
		}
		speed = Math.max(Math.min(speed, 4.0), 0.0);
		if(Game.keys.isPressed(KeyCode.J)) {
			bodyRot -= 0.1;
		} else if (Game.keys.isPressed(KeyCode.L)){
			bodyRot += 0.1;
		}
		super.tick();
		
		world.entities.forEach((Entity e) {
			if(e is Pickup) {
				if(e.getRect().intersects(getRect())) {
					e.onPickup(this);
				}
			}
		});
		
		if(Game.keys.isPressed(KeyCode.I)) {
			fire();
		}
		
		if(Game.keys.isPressedOnce(KeyCode.SPACE)) {
			placeTorch();
		}
		health -= 1;
	}
	
	void placeTorch() {
		int sx = (x + w / 2) ~/ Tile.SIZE;
		int sy = (y + h / 2) ~/ Tile.SIZE;
		if(world.getTile(sx, sy).id == Tile.TORCH.id){
			world.setTile(sx, sy, Tile.GRASS);
			lights++;			
		} else if(world.getTile(sx, sy).id == Tile.GRASS.id) {
			if(lights <= 0) return;
			world.setTile(sx, sy, Tile.TORCH);
			lights--;
		}
		world.updateLights();
	}
}

class Enemy extends Droid {
	double targetRotation = 0.0;
	Entity target = null;

	Enemy(double x, double y, World world) : super(x, y, world) {
		maxFireCooldown = 70;
	}
	
	void tick() {
		if(target == null) {
			target = world.player;
		}
		targetRotation = Math.atan2(target.y - y, target.x - x);
		if(targetRotation > legsRot) {
			legsRot += 0.05;
		} else if (targetRotation < legsRot) {
			legsRot -= 0.05;
		}
		if(targetRotation > bodyRot) {
			bodyRot += 0.1;
		} else if (targetRotation < bodyRot) {
			bodyRot -= 0.1;
		}
		Point mp = new Point(x, y);
		Point tp = new Point(target.x, target.y);
		if(mp.distanceTo(tp) < 3*Tile.SIZE) {
			speed -= 0.2;
		} else {
			speed += 0.1;
		}
		speed = Math.max(Math.min(speed, 3.0), 0.0);
		super.tick();
		
		if(mp.distanceTo(tp) < 5*Tile.SIZE) {
			fire();
		}
	}
}