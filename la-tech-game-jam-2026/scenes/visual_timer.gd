extends Node2D

@onready var timer: Timer = $Timer
@onready var demon_follower: PathFollow2D = $Path2D/PathFollow2D
@onready var demon: Sprite2D = $Path2D/PathFollow2D/Demon
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var boom: AudioStreamPlayer = $Boom

@onready var progress_ratio: float = 0.0

@export var bounce_height: float = 40.0
@export var bounce_frequency: float = 100.0

func _ready() -> void:
	explosion.visible = false

func _process(delta: float) -> void:
	progress_ratio = 1 - (timer.time_left / constants.ROUND_TIME)
	demon_follower.progress_ratio = progress_ratio
	demon.global_position.y = demon_follower.global_position.y - \
		(bounce_height * abs(sin(progress_ratio * bounce_frequency)))
		
func explode_enemy() -> void:
	explosion.global_position = demon.global_position
	explosion.visible = true
	explosion.set_frame(0)
	explosion.play()
	boom.seek(0.0)
	boom.play()
	
func _on_explode_done() -> void:
	explosion.visible = false
