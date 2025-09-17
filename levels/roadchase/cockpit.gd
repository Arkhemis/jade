extends Node2D

# Référence au nœud parent qui contient tous les paysages (Sprite2D)
@onready var landscapes_container: Node = $Landscapes 

# Pour la fonction has_turned(), pour réinitialiser à un paysage spécifique.
# Assurez-vous que "Landscape1" existe bien comme enfant de landscapes_container.
@onready var landscape_1_node: Sprite2D = $Landscapes/Landscape1 

var current_landscape: Sprite2D = null # Initialiser à null pour plus de clarté
signal steer_direction(steering)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Masquer tous les paysages au démarrage
	for child in landscapes_container.get_children():
		if child is Sprite2D: # S'assurer que c'est bien un Sprite2D
			(child as Sprite2D).visible = false
		# else: print("Attention: ", child.name, " n'est pas un Sprite2D dans Landscapes")

	# Définir le paysage initial
	# Utiliser landscape_1_node s'il est valide et enfant du conteneur
	if landscape_1_node and landscape_1_node.get_parent() == landscapes_container:
		current_landscape = landscape_1_node
	elif landscapes_container.get_child_count() > 0:
		# Sinon, prendre le premier enfant Sprite2D trouvé comme initial
		for child in landscapes_container.get_children():
			if child is Sprite2D:
				current_landscape = child as Sprite2D
				print("Paysage initial par défaut: ", current_landscape.name)
				break # Sortir dès qu'on en trouve un
	
	if current_landscape:
		current_landscape.visible = true
		print("Paysage initial: ", current_landscape.name)
	else:
		printerr("Aucun paysage (Sprite2D) valide trouvé dans $Landscapes pour l'initialisation.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func need_to_turn(drop_mode: bool) -> void:
	if not current_landscape:
		printerr("Impossible de tourner: current_landscape n'est pas défini.")
		# Tentative de récupération ou retour
		if landscapes_container.get_child_count() > 0:
			_ready() # Tente de réinitialiser
			if not current_landscape:
				return # Toujours pas de paysage, on ne peut rien faire
		else:
			return # Pas d'enfants, rien à faire

	var previous_landscape: Sprite2D = current_landscape
	previous_landscape.visible = false

	var all_possible_landscapes_nodes: Array = landscapes_container.get_children()
	var candidate_landscapes: Array[Sprite2D] = []
	
	for node in all_possible_landscapes_nodes:
		var sprite_node := node as Sprite2D # Tente de caster en Sprite2D
		# S'assurer que c'est un Sprite2D et qu'il est différent du précédent
		if sprite_node and sprite_node != previous_landscape:
			candidate_landscapes.append(sprite_node)

	if not candidate_landscapes.is_empty():
		# Il y a des paysages différents disponibles
		current_landscape = candidate_landscapes.pick_random()
	elif all_possible_landscapes_nodes.size() >= 1 and previous_landscape:
		# S'il n'y a pas de candidats *différents*, cela signifie :
		# 1. Il n'y a qu'un seul paysage au total (qui est previous_landscape).
		# 2. Les autres nœuds ne sont pas des Sprite2D valides.
		# Dans ce cas, on ne peut que re-sélectionner le précédent.
		print("Aucun paysage *différent* disponible. Re-sélection du précédent.")
		current_landscape = previous_landscape 
	else:
		# Aucun paysage du tout dans le conteneur (ou previous_landscape était null)
		printerr("Aucun paysage disponible dans $Landscapes pour changer.")
		current_landscape = null # Indique qu'aucun paysage n'est actif

	if current_landscape:
		current_landscape.visible = true
		var direction_string = ""
		if "Left" in current_landscape.name: # Ex: LandscapeLeft, CockpitViewLeft
			direction_string = "left"
		elif "Right" in current_landscape.name: # Ex: LandscapeRight
			direction_string = "right"
		if direction_string != "":
				steer_direction.emit(direction_string)	


func has_turned() -> void: # Cette fonction réinitialise à landscape_1_node
	print("Réinitialisation à Landscape1")
	if current_landscape:
		current_landscape.visible = false
	current_landscape = landscape_1_node
	
	
	if current_landscape:
		current_landscape.visible = true
		print("Cockpit: Réinitialisé à et rendu visible: ", current_landscape.name)

	else:
		print("Cockpit: Aucun paysage à rendre visible après la tentative de réinitialisation.")
	
