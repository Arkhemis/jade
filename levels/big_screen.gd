extends Node2D

# Précharger les textures pour de meilleures performances
const BUTTON_A_TEX = preload("res://assets/ui/Sprites/flat-dark/button_a.png")
const BUTTON_B_TEX = preload("res://assets/ui/Sprites/flat-dark/button_b.png")
const BEAR_TEX = preload("res://assets/animals/bear.png")
const WALRUS_TEX = preload("res://assets/animals/walrus.png")

# Utiliser les textures préchargées dans la définition des événements
var events = [
	{
		"button_texture": BUTTON_A_TEX, # On stocke directement la ressource
		"event_texture": BEAR_TEX,
		"button_to_press": "primary_action" # Assure-toi que cette action est définie dans Input Map
	},
	{
		"button_texture": BUTTON_B_TEX,
		"event_texture": WALRUS_TEX,
		"button_to_press": "secondary_action" # Assure-toi que cette action est définie dans Input Map
	}
	# Ajoute plus d'événements ici si tu veux
]

var current_event: Dictionary # Pour stocker l'événement en cours, type hint pour la clarté
var event_active: bool = false
var game_playing: bool = true
var score: int = 0 # Ajoutons un score !

# Références aux nœuds (optionnel, mais peut rendre le code plus propre)
@onready var button_sprite: Sprite2D = $ButtonA # Renommer le nœud ButtonA en ButtonSprite dans l'éditeur
@onready var event_sprite: Sprite2D = $Event
@onready var game_timer: Timer = $GameTimer
@onready var event_timer: Timer = $EventTimer
@onready var event_timeout_timer: Timer = $EventTimeout
@onready var score_label: Label = $Score # Si tu ajoutes un label pour le score

func _ready():
	randomize()
	
	button_sprite.visible = false
	event_sprite.visible = false
	score_label.text = "Score: 0" # Initialiser le label de score

	game_timer.start(10) # Durée totale du jeu
	event_timer.start(randi_range(1, 3)) # Délai avant le premier événement

func show_event():
	if not events: # Au cas où la liste serait vide
		print_debug("La liste d'événements est vide !")
		return

	current_event = events.pick_random()
	if not current_event: # Sécurité si pick_random retourne null (ne devrait pas arriver avec une liste non vide)
		print_debug("Impossible de choisir un événement.")
		return

	button_sprite.texture = current_event["button_texture"]
	event_sprite.texture = current_event["event_texture"]
	
	button_sprite.visible = true
	event_sprite.visible = true

	event_active = true
	event_timeout_timer.start(2)  # Temps pour réagir

func hide_event():
	button_sprite.visible = false
	event_sprite.visible = false
	event_active = false
	
	# On ne relance le timer d'événement que si le jeu est toujours en cours
	if game_playing:
		event_timer.start(randi_range(1, 3)) # Délai avant le prochain événement

func _unhandled_input(event: InputEvent):
	if not event_active or not current_event: # Si pas d'événement actif ou si current_event n'est pas défini
		return

	# On ne traite que les pressions d'action pour éviter les "Ouch!" sur les mouvements de souris etc.
	if event.is_action_pressed(current_event["button_to_press"]) and not event.is_echo():
		print("Bien joué !")
		score += 1
		score_label.text = "Score: " + str(score)
		hide_event()
		event_timeout_timer.stop() # Arrêter le timer de réaction car on a réussi
	else:

		for e_data in events:
			if event.is_action_pressed(e_data["button_to_press"]) and not event.is_echo() and \
				e_data["button_to_press"] != current_event["button_to_press"]:
				print("Ouch! Mauvais bouton !")
				score -=1 # Pénalité ?
				hide_event() # Échouer l'événement ?
				event_timeout_timer.stop()
				break


func _on_game_timer_timeout() -> void:
	print("Fin du jeu ! Score final : " + str(score))
	game_playing = false
	event_timer.stop() # Arrêter la génération de nouveaux événements
	event_timeout_timer.stop() # Arrêter le timer de réaction s'il était en cours
	hide_event() # Cacher l'événement en cours s'il y en avait un
	# Ici, tu pourrais afficher un écran de "Game Over"

func _on_event_timeout_timer_timeout() -> void: # Renommé pour plus de clarté
	if event_active: # S'assurer que l'événement était bien actif
		print("Trop tard !")
		score -=1 # Pénalité ?
		score_label.text = "Score: " + str(score)
		hide_event()

func _on_event_timer_timeout() -> void:
	if game_playing: # Ne montrer un nouvel événement que si le jeu est en cours
		print('Nouvel événement !')
		show_event()
