class_name InteractiveTilemap extends TileMapLayer

@export var tile_scenes : Array[InteractiveTileMapResource] = []

var _half_tile_size : Vector2 = Vector2.ZERO

func _ready() -> void :
	if tile_set :
		_half_tile_size = tile_set.tile_size / 2
		_replace_tiles_with_scenes()
	return

func _replace_tiles_with_scenes() -> void :
	for tile_pos in get_used_cells() :
		var tile_atlas_coords : Vector2i = get_cell_atlas_coords(tile_pos)
		var object_scene : PackedScene = null
		
		for resource in tile_scenes :
			if resource.atlas_coord == tile_atlas_coords :
				object_scene = resource.scene
				break
		
		if object_scene and object_scene.can_instantiate() :
			_replace_tile_with_object(tile_pos, object_scene)
	return
	
func _replace_tile_with_object(tile_pos: Vector2, object_scene: PackedScene):
	# Clear the cell in TileMap
	erase_cell(tile_pos)
	
	# Spawn the object
	var obj = object_scene.instance()
	var ob_pos = map_to_local(tile_pos) + _half_tile_size
	add_child(obj)
	obj.global_position = to_global(ob_pos)
	return
