part of DROID_AGE;

class Tile {
	
	static ImageElement tileMap;
	static const int SIZE = 32;
	static List<Tile> tiles;
	
	static Tile VOID;
	static Tile WALL;
	static Tile GRASS;
	static Tile TORCH;

	static void init() {
		tileMap = Images.TILE_MAP;
		tiles = new List<Tile>(32);
		VOID = new Tile(0, 0, false, false);
		WALL = new ConnectingTile(1, 8, true, false);
		GRASS = new Tile(2, 1, false, false);
		TORCH = new TorchTile(3, 2, false, true);
	}
	
	int _id;
	int _textId;
	bool _solid;
	bool _emitter;
	Tile(int id, int textId, bool solid, bool emit) {
		_id = id;
		if(tiles[id] != null) {
			throw new Exception("Duplicate Tiles: $id");
		}
		_textId = textId;
		_solid = solid;
		_emitter = emit;
		tiles[id] = this;
	}
	
	int get id => _id;
	int get textId => _textId;
	bool get solid => _solid;
	bool get emitter => _emitter;
	
	Rectangle getRect(int x, int y) {
		return new Rectangle(x * SIZE, y * SIZE, SIZE, SIZE);
	}
	
	void onSet(int x, int y, World world) {
	}
	
	void render(int x, int y, World world) {
		x *= SIZE;
		y *= SIZE;
		Display.drawTiledImage(x, y, tileMap, _textId, SIZE);
	}
}

class ConnectingTile extends Tile {
	ConnectingTile(int id, int textId, bool solid, bool emit) : super(id, textId, solid, emit);
	
	void checkConnection(int x, int y, World world) {
		bool u = world.getTile(x, y-1).id == this.id;
		bool d = world.getTile(x, y+1).id == this.id;
		bool l = world.getTile(x-1, y).id == this.id;
		bool r = world.getTile(x+1, y).id == this.id;
		int i = 0;
		
		if (u && d && l && r) {
			i = 10;
		} else if (!u && d && l && r) {
			i = 6;
		} else if (u && !d && l && r) {
			i = 7;
		} else if (!u && !d && l && r) {
			i = 0;
		} else if (u && d && !l && r) {
			i = 8;
		} else if (!u && d && !l && r) {
			i = 2;
		} else if (u && !d && !l && r) {
			i = 4;
		} else if (!u && !d && !l && r) {
			i = 12;
		} else if (u && d && l && !r) {
			i = 9;
		} else if (!u && d && l && !r) {
			i = 3;
		} else if (u && !d && l && !r) {
			i = 5;
		} else if (!u && !d && l && !r) {
			i = 11;
		} else if (u && d && !l && !r) {
			i = 1;
		} else if (!u && d && !l && !r) {
			i = 13;
		} else if (u && !d && !l && !r) {
			i = 14;
		} else if (!u && !d && !l && !r) {
			i = 15;
		}
		world.setData(x, y, i);
	}
	
	void render(int x, int y, World world) {
		int data = world.getData(x, y);
		x *= Tile.SIZE;
		y *= Tile.SIZE;
		Display.drawTiledImage(x, y, Tile.tileMap, _textId + data, Tile.SIZE);
	}
}

class TorchTile extends Tile {
	TorchTile(int id, int textId, bool solid, bool emit) : super(id, textId, solid, emit);
	
	void onSet(int x, int y, World world) {
		world.setData(x, y, 5);
	}
}