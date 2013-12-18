part of LD28_GB_BH;

class Display {
	static CanvasElement canvas;
	static CanvasRenderingContext2D context;
	static int xOff = 0;
	static int yOff = 0;
	
	static void init() {
		canvas = querySelector("#targetCanvas");
		canvas.width = 640;
		canvas.height = 480;
		context = canvas.getContext("2d");
	}
	
	static void clear([String color="black"]) {
		drawRect(0, 0, canvas.width, canvas.height, color);
	}
	
	static void drawImage(int x, int y, ImageElement img) {
		x -= xOff;
		y -= yOff;
		context.drawImage(img, x, y);
	}
	
	static void drawTiledImage(int x, int y, ImageElement img, int tileId, int tileWidth) {
		if(img.width == 0 || img.height == 0) return;
		x -= xOff;
		y -= yOff;
		int tw = img.width ~/ tileWidth;
		int tx = tileId % tw;
		int ty = tileId ~/ tw;
		
		context.drawImageScaledFromSource(img, tx*tileWidth, ty*tileWidth, tileWidth, tileWidth, x, y, tileWidth, tileWidth);
	}
	
	static void drawRect(int x, int y, int width, int height, [String color="black", bool filled=true]) {
		x -= xOff;
		y -= yOff;
		if(filled) {
			context.fillStyle = color;
			context.fillRect(x, y, width, height);
		} else {
			context.strokeStyle = color;
			context.strokeRect(x, y, width, height);
		}
	}
	
	static ImageElement loadImage(String path) {
		ImageElement img = new ImageElement();
		img.src = path;
		return img;
	}
}