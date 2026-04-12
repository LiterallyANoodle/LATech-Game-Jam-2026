extends Control

@onready var score_label: Label = $ScoreLabel
@onready var time_label: Label = $TimeLabel

var current_score: int = 0
var time_elapsed: float = 0.0
var is_active: bool = true

func _ready() -> void:
	update_score_text()
	
	# Connect signals
	SignalBus.MOLECULE_CORRECT.connect(_on_demon_defeated)
	#SignalBus.WIZARD_DIED.connect(_on_wizard_died)
	SignalBus.MATERIAL_COMBINED.connect(_on_material_combined) # New listener

func _process(delta: float) -> void:
	if is_active:
		time_elapsed += delta
		update_time_text()

func _on_demon_defeated() -> void:
	current_score += 1148
	update_score_text()

func _on_material_combined() -> void:
	current_score += 250
	update_score_text()

func _on_wizard_died() -> void:
	is_active = false

func update_score_text() -> void:
	score_label.text = "Score: " + str(current_score)

func update_time_text() -> void:
	# Minutes and Seconds
	var minutes: int = int(time_elapsed / 60)
	var seconds: int = int(time_elapsed) % 60
	
	# Formats as 00:00
	time_label.text = "Time: %02d:%02d" % [minutes, seconds]
