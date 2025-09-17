extends Area2D

const mosquito_1 = preload("res://levels/roadchase/moskito_1.png")
const mosquito_2 = preload("res://levels/roadchase/moskito_2.png")
const mosquito_3 = preload("res://levels/roadchase/moskito_3.png")
const mosquitos = [mosquito_1, mosquito_2, mosquito_3]
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	$Mosquito.texture = mosquitos.pick_random()
	var resize = create_tween()
	resize.tween_property($Mosquito, 'scale', Vector2(0.175, 0.153), 0.3)
	

func squash():
	$AnimationPlayer.play('squash')
	
