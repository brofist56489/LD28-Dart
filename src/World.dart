part of LD28_GB_BH;

class World {
	
	List<Entity> entities;
	Player player;

	World() {
		entities = new List<Entity>();
		player = new Player(0, 0);
	}
	
	void tick() {
		for(int i=0; i<entities.length; i++) {
			Entity e = entities[i];
			e.tick();
		}
		player.tick();
	}
	
	void render() {
		for(int i=0; i<entities.length; i++) {
			Entity e = entities[i];
			e.render();
		}
		player.render();
	}
}