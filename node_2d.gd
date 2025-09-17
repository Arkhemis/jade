extends Node2D


var projectiles: PackedScene = preload("res://projectiles.tscn")

func _ready() -> void:
	$Projectiles.position = Vector2(550,245)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("primary_action"):
		print("Is pressed")
		var projectile= projectiles.instantiate() as Area2D
		projectile.position = Vector2(250,250)
		$Projectiles.add_child(projectile)
