part of DROID_AGE;

class Images {
	static ImageElement DROID;
	static ImageElement ROCKET;
	static ImageElement TEST_WORLD;
	static ImageElement TILE_MAP;
	
	static void init() {
		DROID = Display.loadImage("../res/droids.png");
		ROCKET = Display.loadImage("../res/missle.png");
		TEST_WORLD = Display.loadImage("../res/testWorld.png");
		TILE_MAP = Display.loadImage("../res/tileMap2.png");
	}
}