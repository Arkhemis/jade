extends Node2D

func steer(steering_direction):
	var steering = create_tween()
	$CarDriftingSoundEffect.play()
	if steering_direction == 'right':
		steering.tween_property($Volant, 'rotation_degrees', 90, 0.3)
	else:
		steering.tween_property($Volant, 'rotation_degrees', -90, 0.3)
	steering.tween_property($Volant, 'rotation_degrees', 0, 0.3)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		steer('left')
		
	if Input.is_action_just_pressed("right"):
		steer('right')
	
