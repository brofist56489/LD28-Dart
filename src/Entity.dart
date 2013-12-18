part of LD28_GB_BH;

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

class Entity {
	int x, y;
	int ax, ay;
	
	Animator animator;
	ImageElement texture;
	
	Entity(int x, int y) {
		this.x = x;
		this.y = y;
		this.ax = 0;
		this.ay = 0;
		
		animator = new Animator(0, 4, 0, 15);
	
		texture = Display.loadImage("../res/player.png");
	}
	
	void tick() {
		animator.tick();
	}
	
	void render() {
		Display.drawTiledImage(x, y, texture, animator.frame + 4 * 5, animator.tileWidth);
	}
}