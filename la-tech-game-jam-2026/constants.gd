extends Node

# Space between grid spaces in pixels
const GRID_SIZE: int = 64

# How long it takes for player/blocks to move one grid tile
const MOVE_TIME: float = 0.10

# Atom textures
var air_tex: Texture2D = load("res://.godot/imported/poopy_air.png-39d0e8ba2a99cdbdd97878c876e7c6bc.ctex")
var fire_tex: Texture2D = load("res://.godot/imported/poopy_atom.png-1dfad63143ba100ae804eb975d0efbab.ctex")
var earth_tex: Texture2D = load("res://.godot/imported/poopy_earth.png-3641b60a6dc4ce0382ee94705ac8c906.ctex")
var water_tex: Texture2D = load("res://.godot/imported/poopy_water.png-326f2f47c33d16830bc64acd827fda9d.ctex")
