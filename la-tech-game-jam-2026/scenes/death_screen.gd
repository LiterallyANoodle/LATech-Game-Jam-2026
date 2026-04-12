extends Control


func _ready() -> void:
	# Keep it hidden at start
	visible = false
	# Connect to the signal
	SignalBus.WIZARD_DIED.connect(_on_wizard_died)

func _on_wizard_died() -> void:
	visible = true
	# Optional: Make it fancy with a fade-in
	modulate.a = 0
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.5) # Fade in over 1.5 seconds
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
