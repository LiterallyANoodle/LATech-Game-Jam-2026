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
@onready var ghost_container: Node2D = $GhostContainer
@onready var is_resetting: bool = false
@onready var is_dead: bool = false


# Transforms GRID COORDINATES to WORLD COORDINATES
func coord_to_position(coord: Vector2) -> Vector2:
	return coord * constants.GRID_SIZE

func generate_target_shape() -> void:
	# Updated this so that only one quintessnce can spawn per battle
	target_shape.clear()
	
	var first_element: String = elements.pick_random()
	target_shape[Vector2.ZERO] = first_element
	
	for i: int in range(0, constants.EXAMPLE_MAX_SIZE):
		var pos: Vector2 = target_shape.keys().pick_random()
		pos += dirs.pick_random()
		
		if target_shape.has(pos):
			continue
			
		if target_shape.values().has("quint"):
			# Create a temporary list that excludes quintessnce
			var eligible_elements: Array = elements.duplicate()
			eligible_elements.erase("quint")
			target_shape[pos] = eligible_elements.pick_random()
		else:
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

func restore_connections(pos: Vector2) -> void:
	for dir: Vector2 in dirs:
		var other: Vector2 = pos + dir
		if not molecules.has(other): continue
		if molecules[other].fusions[dir * -1]:
			molecules[pos].fusions[dir] = true

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
				SignalBus.MATERIAL_COMBINED.emit()
				SignalBus.log_event.emit("[color=wheat]Copper formed![/color]")
			elif mol.element == "air" and other.element == "earth":
				remove_molecule(pos + dir)
				mol.set_element("copper")
				SignalBus.MATERIAL_COMBINED.emit()
				SignalBus.log_event.emit("[color=wheat]Copper formed!")
			elif mol.element == "fire" and other.element == "water":
				remove_molecule(pos + dir)
				mol.set_element("iron")
				SignalBus.MATERIAL_COMBINED.emit()
				SignalBus.log_event.emit("[color=wheat]Iron formed![/color]")
			elif mol.element == "water" and other.element == "fire":
				remove_molecule(pos + dir)
				mol.set_element("iron")
				SignalBus.MATERIAL_COMBINED.emit()
				SignalBus.log_event.emit("[color=wheat]Iron formed![/color]")
			elif mol.element == "iron" and other.element == "air":
				remove_molecule(pos + dir)
				mol.set_element("silver")
				SignalBus.MATERIAL_COMBINED.emit()
				SignalBus.log_event.emit("[color=slateblue]Silver formed![/color]")
			elif mol.element == "air" and other.element == "iron":
				remove_molecule(pos + dir)
				mol.set_element("silver")
				SignalBus.MATERIAL_COMBINED.emit()
				SignalBus.log_event.emit("[color=slateblue]Silver formed![/color]")
			elif mol.element == "copper" and other.element == "fire":
				remove_molecule(pos + dir)
				mol.set_element("gold")
				SignalBus.MATERIAL_COMBINED.emit()
				SignalBus.log_event.emit("[color=slateblue]Gold formed![/color]")
			elif mol.element == "fire" and other.element == "copper":
				remove_molecule(pos + dir)
				mol.set_element("gold")
				SignalBus.MATERIAL_COMBINED.emit()
				SignalBus.log_event.emit("[color=slateblue]Gold formed![/color]")
			elif mol.element == "gold" and other.element == "silver":
				remove_molecule(pos + dir)
				mol.set_element("quint")
				SignalBus.MATERIAL_COMBINED.emit()
				SignalBus.log_event.emit("[color=tomato]Quintessence formed![/color]")
			elif mol.element == "silver" and other.element == "gold":
				remove_molecule(pos + dir)
				mol.set_element("quint")
				SignalBus.MATERIAL_COMBINED.emit()
				SignalBus.log_event.emit("[color=tomato]Quintessence formed![/color]")
			shove_molecule(pos + dir, dir)
		molecules[pos + dir] = mol
		restore_connections(pos + dir)
		molecules[pos + dir].recalc()

func player_fused(direction: Vector2) -> void:
	if is_dead: return	
	var target: Vector2 = player_position + direction
	var target2: Vector2 = target + direction
	if (not molecules.has(target)) or (not molecules.has(target2)): return
	if molecules[target].fusions[direction]:
		molecules[target].unfuse(direction)
		molecules[target2].unfuse(direction * -1)
	else:
		molecules[target].fuse(direction)
		molecules[target2].fuse(direction * -1)

func player_moved(direction: Vector2) -> void:
	if is_dead: return
	player_position += direction
	if molecules.has(player_position):
		shove_molecule(player_position, direction)
	
	if player_position == cast_button_position:
		if test_shape():
			is_resetting = true
			SignalBus.log_event.emit("[color=yellow]Combo correct, Demon defeated!![/color]")
			clear_molecules()
			SignalBus.MOLECULE_CORRECT.emit()
			
			# generate_target_shape()
			# SignalBus.REBUILD_EXAMPLE.emit(target_shape)
			
			generate_target_shape()
			update_ghost_projection()
			SignalBus.REBUILD_EXAMPLE.emit(target_shape)
			await get_tree().create_timer(0.1).timeout
			is_resetting = false
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

func update_ghost_projection() -> void:
	# Clear old pattern
	for child: Node in ghost_container.get_children():
		child.free()
		
	if ghost_container.get_child_count() > 0:
		return
		
	# Iterate through the target dictionary
	for coord: Vector2 in target_shape.keys():
		var element_type: String = target_shape[coord]
		
		# Create a simple sprite
		var ghost: Sprite2D = Sprite2D.new()
		ghost_container.add_child(ghost)
		
		# Set visual properties
		ghost.texture = get_element_texture(element_type)
		ghost.position = coord_to_position(coord)
		
		# Transpaency
		ghost.modulate = Color(1, 1, 1, 0.3) 
		ghost.scale = Vector2(4, 4)
		ghost.z_index = -1

# Helper to find the texture constants script
func get_element_texture(type: String) -> Texture2D:
	match type:
		"earth": return constants.earth_tex
		"air": return constants.air_tex
		"fire": return constants.fire_tex
		"water": return constants.water_tex
		"iron": return constants.iron_tex
		"copper": return constants.copper_tex
		"gold": return constants.gold_tex
		"silver": return constants.silver_tex
		"quint": return constants.quintessence_tex
	return null

func _ready() -> void:
	SignalBus.PLAYER_MOVED.connect(player_moved)
	SignalBus.PLAYER_FUSED.connect(player_fused)
	SignalBus.WIZARD_DIED.connect(_on_wizard_died)
	spawn_molecule(Vector2(-5, -3), "fire")
	spawn_molecule(Vector2(-5, 3), "water")
	spawn_molecule(Vector2(5, 3), "earth")
	spawn_molecule(Vector2(5, -3), "air")
	player.position = coord_to_position(player_position)
	generate_target_shape()
	generate_target_shape()
	update_ghost_projection()
	#spawn_target()
	SignalBus.REBUILD_EXAMPLE.emit(target_shape)
	cast_button.position = coord_to_position(cast_button_position)

func _on_wizard_died() -> void:
	is_dead = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
		
		
