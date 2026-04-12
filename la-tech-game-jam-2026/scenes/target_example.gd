extends SubViewport

var molecule_scene: PackedScene = preload("res://scenes/molecule.tscn")
var molecules: Dictionary

func coord_to_position(coord: Vector2) -> Vector2:
	return coord * constants.GRID_SIZE + \
		Vector2(constants.EXAMPLE_WINDOW / 2, constants.EXAMPLE_WINDOW / 2)

func spawn_molecule(pos: Vector2, type: String) -> void:
	var instance: Molecule = molecule_scene.instantiate()
	add_child(instance)
	molecules[pos] = instance
	instance.position = coord_to_position(pos)
	instance.set_element(type)

func display(mols: Dictionary) -> void:
	for key: Vector2 in molecules:
		molecules[key].free()
	molecules.clear()
	for key: Vector2 in mols:
		spawn_molecule(key, mols[key])

func _ready() -> void:
	SignalBus.REBUILD_EXAMPLE.connect(display)
