extends Node2D


var stain_scene : PackedScene = preload('res://levels/roadchase/mosquito.tscn')
var stain
var need_to_turn: bool
var turn_direction: String
var drop_mode := false
@onready var shap: CollisionShape2D = $MosquitosSpawn/CollisionShape2D
@onready var mosquitos_container: Node2D = $MosquitosSpawn/CollisionShape2D/Mosquitos # Renommé pour clarté
@onready var cockpit: Node2D = $cockpit # Assure-toi que ce chemin est correct
@onready var mosquito_timer: Timer = $MosquitoTimer
@onready var need_turn_timer: Timer = $NeedTurnTimer
@onready var turn_time_limit_timer: Timer = $TurnTimeLimit

var min_need_turn_timer:= 2
var max_need_turn_timer:= 7

var min_mosquito_timer:= 1
var max_mosquito_timer:= 4
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	mosquito_timer.start(randf_range(min_mosquito_timer,max_mosquito_timer))
	need_turn_timer.start(randf_range(min_need_turn_timer,max_need_turn_timer))
	$redpill.play(45)
	$DropTimer.start(43)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if mosquitos_container.get_child_count() > 0:
		if Input.is_action_just_pressed("primary_action"):
			#print("Gotcha! Attempting to squash the newest mosquito.")
			var newest_mosquito = mosquitos_container.get_children()[-1] 
			
			# Bonne pratique : vérifier si le nœud est valide et possède la méthode
			if is_instance_valid(newest_mosquito) and newest_mosquito.has_method("squash"):
				newest_mosquito.squash() 
	
	if need_to_turn:
		var turned_correctly = false
		var turned_incorrectly = false

		if turn_direction == "left":
			if Input.is_action_just_pressed("left"):
				turned_correctly = true
			elif Input.is_action_just_pressed("right"):
				turned_incorrectly = true
		elif turn_direction == "right":
			if Input.is_action_just_pressed("right"):
				turned_correctly = true
			elif Input.is_action_just_pressed("left"):
				turned_incorrectly = true
		
		if turned_correctly:
			print("Turn successful!")
			cockpit.has_turned()
			need_to_turn = false
			turn_time_limit_timer.stop()
			var tim = randf_range(min_need_turn_timer, max_need_turn_timer)
			print(tim)
			need_turn_timer.start(tim) 
		elif turned_incorrectly:
			print("Wrong turn!")
			game_over()
			
			
func _on_stain_timer_timeout() -> void:
	show_stain()
	mosquito_timer.start(randf_range(min_mosquito_timer,max_mosquito_timer))
	
func show_stain():
	stain = stain_scene.instantiate() as Area2D
	var rect = shap.shape.get_rect()
	var x = randi_range(rect.position.x, rect.position.x+rect.size.x)
	var y = randi_range(rect.position.y, rect.position.y+rect.size.y)
	var rand_point = global_position + Vector2(x,y)
	stain.global_position = rand_point
	stain.visible = true
	mosquitos_container.add_child(stain)
	


func _on_need_turn_timer_timeout() -> void:
	if need_to_turn:
		return
	
	$cockpit.need_to_turn(drop_mode)
	need_to_turn = true
	$TurnTimeLimit.start(1)


func _on_turn_time_limit_timeout() -> void:
	if need_to_turn: # Vérifier si on attendait effectivement un virage
		print("!!! Turn time limit EXCEEDED !!!") # Message distinctif
		game_over()
		need_to_turn = false # Réinitialiser l'état
	else:
		print("TurnTimeLimit timeout, but need_to_turn was already false. No action.")


func _on_cockpit_steer_direction(cockpit_turn_direction: Variant) -> void:
	if cockpit_turn_direction == "left" or cockpit_turn_direction == "right":
		turn_direction = cockpit_turn_direction
		print("Player needs to turn:", turn_direction)
	else:
		pass

func game_over():
	print("GAME OVER! Too bad!")
	# Ici, tu devrais probablement arrêter les timers et gérer la fin de partie.
	mosquito_timer.stop()
	need_turn_timer.stop()
	turn_time_limit_timer.stop()
	need_to_turn = false
	get_tree().reload_current_scene() 
	#ou get_tree().change_scene_to_file("res://menus/game_over_screen.tscn")


func _on_drop_timer_timeout() -> void:
	print("Drop mode starting")
	
	min_need_turn_timer = 0.5
	max_need_turn_timer = 2

	min_mosquito_timer = 0.5
	max_mosquito_timer = 2
	drop_mode = true
