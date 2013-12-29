part of DROID_AGE;

class Rectangle {
	int x, y, w, h;
	
	Rectangle(this.x, this.y, this.w, this.h);
	
	bool intersects(Rectangle r2) {
		if(x < r2.x + r2.w && x + w > r2.x && y < r2.y + r2.h && y + h > r2.y) {
			return true;
		} else {
			return false;
		}
	}
}

class Keyboard {
	HashMap<int, int> _keys = new HashMap<int, int>();
	HashMap<int, int> _onceKeys = new HashMap<int, int>();
	
	Keyboard() {
		window.onKeyDown.listen((KeyboardEvent e) {
			if (!_keys.containsKey(e.keyCode)) {
				_keys[e.keyCode] = e.timeStamp;
			}
			if (!_onceKeys.containsKey(e.keyCode)) {
				_onceKeys[e.keyCode] = e.timeStamp;
			}
		});

		window.onKeyUp.listen((KeyboardEvent e) {
			_keys.remove(e.keyCode);
			_onceKeys.remove(e.keyCode);
		});
	}
	
	void poll() {
		_onceKeys.clear();
	}
	
	bool isPressed(int keyCode) => _keys.containsKey(keyCode);
	bool isPressedOnce(int keyCode) => _onceKeys.containsKey(keyCode);
}