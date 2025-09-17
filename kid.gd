extends Node2D

var normal_zoom
var normal_position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	normal_zoom = $Camera2D.zoom
	normal_position = $Camera2D.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if Input.is_action_just_pressed("primary_action"):
		var choosen_marker = $Markers.get_children().pick_random()
		var zoom_tween = create_tween().set_parallel()
		zoom_tween.tween_property($Camera2D, "zoom", normal_zoom, 1).from(choosen_marker.position)
		#zoom_tween.tween_property($Camera2D, "position", normal_position, 3).from(choosen_marker.position)
  
		
