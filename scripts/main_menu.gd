extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var settings: Panel = $Settings
@onready var back: Button = $Settings/back


func show_main_menu() -> void:
	main_buttons.show()
	settings.hide()
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_main_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	#get_tree().change_scene_to_file("res://main_menu.tscn") #Switch to correct scene
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	main_buttons.hide()
	settings.show()

func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_back_pressed() -> void:
	show_main_menu()
