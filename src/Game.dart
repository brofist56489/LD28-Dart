part of DROID_AGE;

class Game {
	bool running;
	GameTimer timer;
	World world;
	static Math.Random random;
	static Keyboard keys;
	int tickCount = 0;

	Game() {
		random = new Math.Random();
		keys = new Keyboard();
		Images.init();
		Tile.init();
		Display.init();
		timer = new GameTimer(this);
		world = new World();
		WorldLoader.loadWorld("../res/testWorld.png", world);
		running = true;
		
		timer.start();
	}
	
	void tick() {
		tickCount++;
		world.tick();
		if(tickCount%600 == 0) {
			world.spawnEnemy();
		}
		keys.poll();
	}
	
	void render() {
		Display.clear();
		Display.centerOn(world.player.x.toInt(), world.player.y.toInt());
		world.render();
		Display.centerOn(320, 240);
		Display.drawRect(0, Display.HEIGHT-32, Display.WIDTH, 32, "#333", true);
		Display.drawText(10, Display.HEIGHT-6, "${world.player.lights}");
		int w = ((world.player.health / world.player.maxHealth) * Display.WIDTH).toInt();
		Display.drawRect(0, 0, w, 20, "red", true);
//		for(int i=0; i<world.player.health~/10; i++) {
//			Display.drawRect(i*64, 0, 4, 20, "black", true);
//		}
	}
}

class GameTimer {
	int ltr = new DateTime.now().millisecondsSinceEpoch;
	int lt = new DateTime.now().millisecondsSinceEpoch;
	int now;
	double msPt = 60.0 / 1000.0;
	double delta = 0.0;
	
	int ticks = 0;
	int frames = 0;
	
	Game game;
	
	GameTimer(Game game) {
		this.game = game;
	}
	
	void start() {
		window.requestAnimationFrame(update);
	}
	
	void update(double time) {
		now = new DateTime.now().millisecondsSinceEpoch;
		delta += (now - lt) * msPt;
		lt = now;
		
		while(delta >= 1) {
			game.tick();
			ticks++;
			delta--;
		}
		
		game.render();
		frames++;
		
		if(now - ltr >= 1000.0) {
			print("$ticks tps, $frames fps");
			ticks = 0;
			frames = 0;
			ltr += 1000;
		}
	
		if(game.running)
			window.requestAnimationFrame(update);
	}
}