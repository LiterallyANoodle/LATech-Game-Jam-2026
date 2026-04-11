extends Node2D

var molecule_scene: PackedScene = preload("res://scenes/molecule.tscn")
var molecules: Dictionary
var target_shape: Dictionary
# Player's position in GRID COORDINATES
var player_position: Vector2 = Vector2.ZERO

const dirs: Array = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
const neighborhood: Array = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.ZERO]
const elements: Array = ["earth", "air", "fire", "water"]

@onready var player: Node2D = $Player

# Transforms GRID COORDINATES to WORLD COORDINATES
func coord_to_position(coord: Vector2) -> Vector2:
	return coord * constants.GRID_SIZE

func generate_target_shape() -> void:
	target_shape.clear()
	target_shape[Vector2.ZERO] = elements.pick_random()
	for i: int in range(0, 10):
		var pos: Vector2 = target_shape.keys().pick_random()
		pos += dirs.pick_random()
		target_shape[pos] = elements.pick_random()

func spawn_target() -> void:
	for k: Vector2 in target_shape.keys():
		spawn_molecule(k, target_shape[k])

# Attempt to spawn a new atom if the area around the spawn point is clear
func try_spawn(pos: Vector2, type: String) -> void:
	var clear: bool = true
	for dir: Vector2 in neighborhood:
		if player_position == dir + pos: clear = false
		if molecules.has(dir + pos): clear = false
	if clear: spawn_molecule(pos, type)

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
	try_spawn(Vector2(-5, -3), "fire")
	try_spawn(Vector2(-5, 3), "water")
	try_spawn(Vector2(5, 3), "earth")
	try_spawn(Vector2(5, -3), "air")

func spawn_molecule(pos: Vector2, type: String) -> void:
	var instance: Molecule = molecule_scene.instantiate()
	add_child(instance)
	molecules[pos] = instance
	instance.position = coord_to_position(pos)

func _ready() -> void:
	SignalBus.PLAYER_MOVED.connect(player_moved)
	spawn_molecule(Vector2(-5, -3), "fire")
	spawn_molecule(Vector2(-5, 3), "water")
	spawn_molecule(Vector2(5, 3), "earth")
	spawn_molecule(Vector2(5, -3), "air")
	player.position = coord_to_position(Vector2.ZERO)
	generate_target_shape()
	spawn_target()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
