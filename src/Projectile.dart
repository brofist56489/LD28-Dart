part of DROID_AGE;

abstract class Projectile extends Entity {
	Projectile(double x, double y, double speed, double rotation, World world) : super(x, y, world) {
		this.speed = speed;
		this.rotation = rotation;
	}
	
	void loadTexture() {
		texture = Images.ROCKET;
	}
	
	void tick() {
		move();
	}
	
	void move() {
		double ax = Math.cos(rotation) * speed;
		double ay = Math.sin(rotation) * speed;
		if(!checkCollision(ax, 0.0)) {
			x += ax;
		} else alive = false;
		if(!checkCollision(0.0, ay)) {
			y += ay;
		} else alive = false;
	}
	
	void render() {
		Display.drawRotatedImage((x).toInt(), (y).toInt(), texture, rotation);
	}
}

class Rocket extends Projectile {
	Rocket(double x, double y, double speed, double rotation, World world) : super(x, y, speed, rotation, world) {
		w = 10;
		h = 6;
		rxo = 3;
		ryo = 5;
	}
	
	void explode() {
	}
	
	void onRemove() {
		explode();
	}
}