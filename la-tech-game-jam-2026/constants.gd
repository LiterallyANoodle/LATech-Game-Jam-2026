extends Node

# Space between grid spaces in pixels
const GRID_SIZE: int = 64

# How long it takes for player/blocks to move one grid tile
const MOVE_TIME: float = 0.10

# Atom textures
@onready var air_tex: AtlasTexture = AtlasTexture.new()
@onready var fire_tex: AtlasTexture = AtlasTexture.new()
@onready var earth_tex: AtlasTexture = AtlasTexture.new()
@onready var water_tex: AtlasTexture = AtlasTexture.new()

func _ready() -> void:
	air_tex.set_atlas(load("res://assets/Elements.png"))
	air_tex.region = Rect2(48, 0, 16, 16)
	fire_tex.set_atlas(load("res://assets/Elements.png"))
	fire_tex.region = Rect2(0, 0, 16, 16)
	earth_tex.set_atlas(load("res://assets/Elements.png"))
	earth_tex.region = Rect2(16, 0, 16, 16)
	water_tex.set_atlas(load("res://assets/Elements.png"))
	water_tex.region = Rect2(32, 0, 16, 16)
