part of LD28_GB_BH;

class World {
	
	List<Entity> entities;

	World() {
		entities = new List<Entity>();
		entities.add(new Entity(100, 300));
	}
	
	void tick() {
		entities.forEach((Entity e) {
			e.tick();
		});
	}
	
	void render() {
		entities.forEach((Entity e) {
			e.render();
		});
	}
}