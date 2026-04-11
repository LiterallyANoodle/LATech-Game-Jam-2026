extends Node2D

var molecule_scene: PackedScene = preload("res://scenes/molecule.tscn")
var molecules: Dictionary
# Player's position in GRID COORDINATES
var player_position: Vector2 = Vector2.ZERO

@onready var player: Node2D = $Player

# Transforms GRID COORDINATES to WORLD COORDINATES
func coord_to_position(coord: Vector2) -> Vector2:
	return coord * constants.GRID_SIZE

func shove_molecule(pos: Vector2, dir: Vector2) -> void:
	if molecules.has(pos):
		var mol: Molecule = molecules[pos]
		mol.move(dir)
		molecules.erase(pos)
		if molecules.has(pos + dir):
			shove_molecule(pos + dir, dir)
		molecules[pos + dir] = mol

func player_moved(direction: Vector2) -> void:
	player_position += direction
	if molecules.has(player_position):
		shove_molecule(player_position, direction)

func spawn_molecule(pos: Vector2, type: String) -> void:
	var instance: Molecule = molecule_scene.instantiate()
	add_child(instance)
	molecules[pos] = instance
	instance.position = coord_to_position(pos)

func _ready() -> void:
	SignalBus.PLAYER_MOVED.connect(player_moved)
	spawn_molecule(Vector2(-3, -3), "fire")
	spawn_molecule(Vector2(4, 2), "water")
	spawn_molecule(Vector2(3, -1), "earth")
	player.position = coord_to_position(Vector2.ZERO)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
