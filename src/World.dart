part of DROID_AGE;

class World {
	static const int WIDTH = 100;
	static const int HEIGHT = 100;

	List<int> tiles = new List<int>(WIDTH * HEIGHT);
	List<int> data = new List<int>(WIDTH * HEIGHT);
	List<int> lighting = new List<int>(WIDTH * HEIGHT);
	List<Entity> entities;
	Player player;
	
	World() {
		entities = new List<Entity>();
		initTiles();
		player = new Player(150.0, 150.0, this);
		addEntity(new Enemy(100.0, 100.0, this));
		addEntity(new TorchPickup(0.0, 0.0, this));
	}
	
	void spawnEnemy() {
		bool found = false;
		while(!found) {
			int tx = Game.random.nextInt(WIDTH);
			int ty = Game.random.nextInt(HEIGHT);
			int light = getLighting(tx, ty);
			Tile t = getTile(tx, ty);
			if(light <= 20)
				if(!t.solid) {
					Enemy e = new Enemy(tx * Tile.SIZE + 0.0, ty * Tile.SIZE + 0.0, this);
					addEntity(e);
					found = true;
				}
		}
	}
	
	void initTiles() {
		for(int y=0; y<HEIGHT; y++) {
			for(int x=0; x<WIDTH; x++) {
				setTile(x, y, Tile.VOID);
				if(y==14) setTile(x, y, Tile.WALL);
				if(x==19) setTile(x, y, Tile.WALL);
				setData(x, y, 0);
				setLighting(x, y, 32);
			}
		}
		updateConnections();
		updateLights();
	}
	
	void updateConnections() {
		for(int y=0; y<HEIGHT; y++) {
			for(int x=0; x<WIDTH; x++) {
				if(getTile(x, y) is ConnectingTile) {
					(getTile(x, y) as ConnectingTile).checkConnection(x, y, this);
				}
			}
		}
	}
	
	void addEntity(Entity e) {
		entities.add(e);
	}
	
	Tile getTile(int x, int y) {
		if(x < 0 || y < 0 || x >= WIDTH || y >= HEIGHT) return Tile.VOID;
		return Tile.tiles[tiles[x + y * WIDTH]];
	}
	
	void setTile(int x, int y, Tile t) {
		if(x < 0 || y < 0 || x >= WIDTH || y >= HEIGHT) return;
		tiles[x + y * WIDTH] = t.id;
		t.onSet(x, y, this);
	}
	
	int getData(int x, int y) {
		if(x < 0 || y < 0 || x >= WIDTH || y >= HEIGHT) return 0;
		return data[x + y * WIDTH];
	}
	
	void setData(int x, int y, int d) {
		if(x < 0 || y < 0 || x >= WIDTH || y >= HEIGHT) return;
		data[x + y * WIDTH] = d;
	}
	
	int getLighting(int x, int y) {
		if(x < 0 || y < 0 || x >= WIDTH || y >= HEIGHT) return 32;
		return lighting[x + y * WIDTH];
	}
	
	void setLighting(int x, int y, int l) {
		if(x < 0 || y < 0 || x >= WIDTH || y >= HEIGHT) return;
		lighting[x + y * WIDTH] = l;
	}
	
	void updateLights() {
		for(int y=0; y<HEIGHT; y++) {
			for(int x=0; x<WIDTH; x++) {
				setLighting(x, y, 0);
			}
		}
		List<Point> lightSources = new List<Point>();
		for(int y=0; y<HEIGHT; y++) {
			for(int x=0; x<WIDTH; x++) {
				if(getTile(x, y).emitter) {
					lightSources.add(new Point(x, y));
				}
			}
		}
		for(int y=0; y<HEIGHT; y++) {
			for(int x=0; x<WIDTH; x++) {
				int lightLevel = 6;
				Point p = new Point(x, y);
				lightSources.forEach((Point lightP) {
					int maxLight = getData(lightP.x, lightP.y);
					int change = (((maxLight - lightP.distanceTo(p)) / maxLight) * 32.0).toInt();
					if (change > 0) {
						lightLevel += change;
					}
				});
				lightLevel = Math.max(Math.min(lightLevel, 32), 0);
				setLighting(x, y, lightLevel);
			}
		}
	}
	
	void tick() {
		for(int i=0; i<entities.length; i++) {
			Entity e = entities[i];
			e.tick();
			if(!e.alive) {
				e.onRemove();
				entities.remove(e);
				i--;
				continue;
			}
		}
		player.tick();
	}

	void render() {
		int mix = (player.x - Display.WIDTH / 2) ~/ Tile.SIZE - 2;
		int max = (player.x + Display.WIDTH / 2) ~/ Tile.SIZE + 2;
		int miy = (player.y - Display.HEIGHT / 2) ~/ Tile.SIZE - 2;
		int may = (player.y + Display.HEIGHT / 2) ~/ Tile.SIZE + 2;
		for(int y=miy; y<may; y++) {
			for(int x=mix; x<max; x++) {
				getTile(x, y).render(x, y, this);
			}
		}
		
		for(int i=0; i<entities.length; i++) {
			Entity e = entities[i];
			e.render();
		}
		player.render();
		
		for(int y=miy; y<may; y++) {
			for(int x=mix; x<max; x++) {
				Display.drawRect(x * Tile.SIZE, y * Tile.SIZE, 32, 32, Display.colorFromBrightness(getLighting(x, y)), true);
			}
		}
	}
}

class WorldLoader {
	static void loadWorld(String path, World world) {
		ImageElement img = Display.loadImage(path);
		img.onLoad.listen((Event e) {
			CanvasElement canvas = new CanvasElement(width: img.width, height:img.height);
			CanvasRenderingContext2D ctx = canvas.getContext("2d");
			ctx.drawImage(img, 0, 0);
			List<int> data = ctx.getImageData(0, 0, img.width, img.height).data;
			for(int y=0; y<img.height; y++) {
				for(int x=0; x<img.width; x++) {
					int index = (x + y * img.width) * 4;
					int tile = data[index];
					if(tile >= 100) tile = 2;
					world.setTile(x, y, Tile.tiles[tile]);
				}
			}
			world.updateConnections();
			world.updateLights();
		});
	}
}