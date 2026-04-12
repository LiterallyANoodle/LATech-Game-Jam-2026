extends SubViewport

@onready var timer: Timer = $Timer
@onready var demon_follower: PathFollow2D = $Path2D/PathFollow2D
@onready var demon: Sprite2D = $Path2D/PathFollow2D/Demon
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var boom: AudioStreamPlayer = $Boom
@onready var wizard: AnimatedSprite2D = $Wizard
@onready var orb: AnimatedSprite2D = $Orb

@onready var progress_ratio: float = 0.0
@onready var warning_sent: bool = false

@export var bounce_height: float = 40.0
@export var bounce_frequency: float = 100.0

func _ready() -> void:
	explosion.visible = false
	timer.wait_time = constants.ROUND_TIME
	timer.start()
	
	# Log initial appearance
	await get_tree().process_frame
	SignalBus.log_event.emit("Demon appears!!!")
	
	SignalBus.MOLECULE_CORRECT.connect(_on_molecule_correct)

func _process(delta: float) -> void:
	progress_ratio = 1 - (timer.time_left / constants.ROUND_TIME)
	demon_follower.progress_ratio = progress_ratio
	demon.global_position.y = demon_follower.global_position.y - \
		(bounce_height * abs(sin(progress_ratio * bounce_frequency)))
		
	# if demon is 80% to the conjerer, send warning
	if progress_ratio >= 0.8 and not warning_sent:
		SignalBus.log_event.emit("[color=red]Times running out![/color]")
		warning_sent = true # trigger once per demon
		
		
func explode_enemy() -> void:
	explosion.global_position = demon.global_position
	timer.start()
	
	# Log respawn appearance
	await get_tree().process_frame
	SignalBus.log_event.emit("Demon appears!!!")
	
	explosion.visible = true
	explosion.set_frame(0)
	explosion.play()
	boom.seek(0.0)
	boom.play()
	
func explode_wizard() -> void:
	explosion.global_position = wizard.global_position
	timer.stop()
	wizard.visible = false
	orb.visible = false
	explosion.visible = true
	explosion.set_frame(0)
	explosion.play()
	boom.seek(0.0)
	boom.play()
	
func _on_explode_done() -> void:
	explosion.visible = false
	
func _on_timer_expire() -> void:
	explode_wizard()
	
func _on_molecule_correct() -> void:
	explode_enemy()
