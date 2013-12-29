part of DROID_AGE;

class Display {
	static CanvasElement canvas;
	static CanvasRenderingContext2D context;
	static int WIDTH = 640;
	static int HEIGHT = 480;
	
	static int xOff = 0;
	static int yOff = 0;
	
	static void init() {
		canvas = querySelector("#targetCanvas");
		canvas.width = WIDTH;
		canvas.height = HEIGHT;
		context = canvas.getContext("2d");
		context.imageSmoothingEnabled = false;
//		context.webkitImageSmoothingEnabled = false;
//		context.mozImageSmoothingEnabled = false;
	}
	
	static void clear([String color="black"]) {
		drawRect(0, 0, canvas.width, canvas.height, color, true);
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
	
	static void drawRotatedImage(int x, int y, ImageElement img, double radians) {
		context.save();
		context.translate(x - xOff + img.width / 2, y - yOff + img.height / 2);
		context.rotate(radians);
		context.drawImage(img, -img.width / 2, -img.height / 2);
		context.restore();
	}
	
	static void drawRotatedTileImage(int x, int y, ImageElement img, int tileId, int tileWidth, double radians, double scale) {
		if(img == null) return;
		if(img.width == 0 || img.height == 0) return;
		radians += Math.PI / 2;
		
		int tw = img.width ~/ tileWidth;
		int tx = tileId % tw;
		int ty = tileId ~/ tw;
		context.save();
		context.translate(x - xOff + tileWidth * scale / 2, y - yOff + tileWidth * scale / 2);
		context.rotate(radians);
		context.drawImageScaledFromSource(img, tx*tileWidth, ty*tileWidth, tileWidth, tileWidth, -tileWidth*scale / 2, -tileWidth * scale / 2, tileWidth*scale, tileWidth*scale);
		context.restore();
	}
	
	static void drawText(int x, int y, String msg, [String font="30px sans-serif", String color="#fff"]) {
		x -= xOff;
		y -= yOff;
		context.font = font;
		context.fillStyle = color;
		context.fillText(msg, x, y);
	}
	
	static ImageElement loadImage(String path) {
		ImageElement img = new ImageElement();
		img.src = path;
//		bool done = false;
//		img.onLoad.listen((Event e) {
//			print("done");
//			done = true;
//		});
//		while(!done) {}
		return img;
	}
	
	static void centerOn(int x, int y) {
		xOff = x - (WIDTH ~/ 2);
		yOff = y - (HEIGHT ~/ 2);
	}
	
	static String colorFromBrightness(int brightness) {
		String color = "rgba(0, 0, 0, ${(32 - brightness) / 32})";
		return color;
	}
}