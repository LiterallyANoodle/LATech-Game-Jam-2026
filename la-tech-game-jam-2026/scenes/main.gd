extends Node2D

var molecule_scene: PackedScene = preload("res://scenes/molecule.tscn")
var molecules: Dictionary
var target_shape: Dictionary
# Player's position in GRID COORDINATES
var player_position: Vector2 = Vector2(-4, 0)
var cast_button_position: Vector2 = Vector2(0, -4)

const dirs: Array = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
const neighborhood: Array = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.ZERO]
const elements: Array = ["earth", "air", "fire", "water", "iron", "copper", "gold", "silver", "quint"]

@onready var player: Node2D = $Player
@onready var cast_button: Node2D = $CastButton

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

func test_shape() -> bool:
	var correct: bool = true
	for key: Vector2 in target_shape.keys():
		if not molecules.has(key):
			correct = false
			break
		if not molecules[key].element == target_shape[key]:
			correct = false
			break
	return correct

func clear_molecules() -> void:
	for key: Vector2 in molecules:
		molecules[key].free()
	molecules.clear()

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

func remove_molecule(pos: Vector2) -> void:
	if molecules.has(pos):
		var mol: Molecule = molecules[pos]
		molecules.erase(pos)
		mol.free()

func shove_molecule(pos: Vector2, dir: Vector2) -> void:
	if molecules.has(pos):
		var mol: Molecule = molecules[pos]
		mol.move(dir)
		molecules.erase(pos)
		for key: Vector2 in mol.fusions:
			if mol.fusions[key] == true:
				shove_molecule(pos + key, dir)
		if molecules.has(pos + dir):
			var other: Molecule = molecules[pos + dir]
			if mol.element == "earth" and other.element == "air":
				remove_molecule(pos + dir)
				mol.set_element("copper")
			elif mol.element == "air" and other.element == "earth":
				remove_molecule(pos + dir)
				mol.set_element("copper")
			elif mol.element == "fire" and other.element == "water":
				remove_molecule(pos + dir)
				mol.set_element("iron")
			elif mol.element == "water" and other.element == "fire":
				remove_molecule(pos + dir)
				mol.set_element("iron")
			elif mol.element == "iron" and other.element == "air":
				remove_molecule(pos + dir)
				mol.set_element("silver")
			elif mol.element == "air" and other.element == "iron":
				remove_molecule(pos + dir)
				mol.set_element("silver")
			elif mol.element == "copper" and other.element == "fire":
				remove_molecule(pos + dir)
				mol.set_element("gold")
			elif mol.element == "fire" and other.element == "copper":
				remove_molecule(pos + dir)
				mol.set_element("gold")
			elif mol.element == "gold" and other.element == "silver":
				remove_molecule(pos + dir)
				mol.set_element("quint")
			elif mol.element == "silver" and other.element == "gold":
				remove_molecule(pos + dir)
				mol.set_element("quint")
			shove_molecule(pos + dir, dir)
		molecules[pos + dir] = mol

func player_fused(direction: Vector2) -> void:
	var target: Vector2 = player_position + direction
	var target2: Vector2 = target + direction
	if (not molecules.has(target)) or (not molecules.has(target2)): return
	molecules[target].fuse(direction)
	molecules[target2].fuse(direction * -1)

func player_moved(direction: Vector2) -> void:
	player_position += direction
	if molecules.has(player_position):
		shove_molecule(player_position, direction)
	
	if player_position == cast_button_position:
		if test_shape():
			print("You did it!")
			clear_molecules()
			SignalBus.MOLECULE_CORRECT.emit()
	
	try_spawn(Vector2(-5, -3), "fire")
	try_spawn(Vector2(-5, 3), "water")
	try_spawn(Vector2(5, 3), "earth")
	try_spawn(Vector2(5, -3), "air")

func spawn_molecule(pos: Vector2, type: String) -> void:
	var instance: Molecule = molecule_scene.instantiate()
	add_child(instance)
	molecules[pos] = instance
	instance.position = coord_to_position(pos)
	instance.set_element(type)

func _ready() -> void:
	SignalBus.PLAYER_MOVED.connect(player_moved)
	SignalBus.PLAYER_FUSED.connect(player_fused)
	spawn_molecule(Vector2(-5, -3), "fire")
	spawn_molecule(Vector2(-5, 3), "water")
	spawn_molecule(Vector2(5, 3), "earth")
	spawn_molecule(Vector2(5, -3), "air")
	player.position = coord_to_position(player_position)
	generate_target_shape()
	spawn_target()
	cast_button.position = coord_to_position(cast_button_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
