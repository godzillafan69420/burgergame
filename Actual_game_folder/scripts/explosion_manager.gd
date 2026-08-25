extends Node
## explosion_manager.gd  (autoload: "Explosions")
##
## Global entry point for the death-explosion VFX. Call this from anywhere
## a player or enemy dies:
##
##   Explosions.spawn(global_position)
##
## It instances explosion_effect.tscn at the given position, parents it to
## the current scene (or a parent you pass in), and the effect frees itself
## once it's done playing -- no cleanup needed on your end.

const ExplosionEffectScene := preload("res://scenes/explosion_effect.tscn")

func spawn(pos: Vector2, target_parent: Node = null) -> void:
	var parent: Node = target_parent
	if parent == null:
		parent = get_tree().current_scene
	if parent == null:
		return

	var fx := ExplosionEffectScene.instantiate()
	parent.add_child(fx)
	fx.global_position = pos
