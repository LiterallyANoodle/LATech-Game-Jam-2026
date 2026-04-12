class_name Molecule extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var element: String

func set_element(ele: String) -> void:
	element = ele
	match ele:
		"earth":
			sprite.texture = constants.earth_tex
		"air":
			sprite.texture = constants.air_tex
		"fire":
			sprite.texture = constants.fire_tex
		"water":
			sprite.texture = constants.water_tex
		"copper": sprite.texture = constants.copper_tex
		"iron": sprite.texture = constants.iron_tex
		"gold": sprite.texture = constants.gold_tex
		"silver": sprite.texture = constants.silver_tex
		"quint": sprite.texture = constants.quintessence_tex
		_:
			print("YOU FUCKED UP")

func move(direction: Vector2) -> void:
	direction = direction * constants.GRID_SIZE
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position", self.position + direction, constants.MOVE_TIME) \
		.set_trans(Tween.TRANS_CUBIC)
