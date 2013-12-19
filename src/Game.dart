part of LD28_GB_BH;

class Game {
	bool running;
	GameTimer timer;
	World world;

	Game() {
		Display.init();
		timer = new GameTimer(this);
		world = new World();
		running = true;
		
		timer.start();
	}
	
	void tick() {
		world.tick();
	}
	
	void render() {
		Display.clear();
		Display.drawRect(100, 100, 100, 50, "blue", true);
		Display.drawRect(50, 200, 60, 30, "red", true);
		world.render();
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