extends Node2D

const DEFAULT_LAYER: int = 0

@onready var grass_tilemap: TileMap = get_node("Grass")
@onready var water_tilemap: TileMap = get_node("Water")

var grass_used_cells: Array

func _ready() -> void:
	var used_grass_rect: Rect2 = grass_tilemap.get_used_rect()
	grass_used_cells = grass_tilemap.get_used_cells(DEFAULT_LAYER)
	generate_water_tiles(used_grass_rect)
	
	
func generate_water_tiles(used_rect: Rect2) -> void:
	for x in range(used_rect.position.x - 10, used_rect.size.x + 10):
		for y in range(used_rect.position.y - 10, used_rect.size.y + 10):
			if grass_used_cells.has(Vector2i(x, y)):
				continue
				
			water_tilemap.set_cell(
				DEFAULT_LAYER,
				Vector2i(x, y),
				DEFAULT_LAYER,
				Vector2i(0, 0)
				)
			
