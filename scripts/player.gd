extends CharacterBody2D

class_name Player

@onready var level: Node2D = get_parent()
@onready var player_position: Marker2D = $PlayerPosition


@export var walk_speed: float = 120.0
@export var run_speed: float = 150.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var grass_walk_sound: AudioStreamPlayer = $grass_walk_sound
@onready var gravel_walk_sound: AudioStreamPlayer = $gravel_walk_sound
@onready var grass_run_sound: AudioStreamPlayer = $grass_run_sound
@onready var gravel_run_sound: AudioStreamPlayer = $gravel_run_sound
@onready var door_sound: AudioStreamPlayer = $door_sound

var direction: Vector2 = Vector2.ZERO
var is_running: bool = false
var current_speed: float = 0.0
var player_state: String = "idle"
var noise_modifier: float = 1.0
var noise_level: float = 0.0
var game_over: bool = false
var score: int = 0


static  var _instance: Player = null

func _ready():
	_instance = self if _instance == null else _instance
	add_to_group("Player")
	

func _physics_process(delta: float) -> void :
	level.display_score()
	handle_input()
	handle_movement(delta)
	update_noise_level()
	update_sfx()
	move_and_slide()




func handle_input() -> void :

	var x = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	var y = Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")


	if x != 0:
		direction = Vector2(x, 0)
	elif y != 0:
		direction = Vector2(0, y)
	else:
		direction = Vector2.ZERO



	is_running = Input.is_action_pressed("run")
	current_speed = run_speed if is_running else walk_speed

	if direction == Vector2.ZERO:
		player_state = "idle"
	else:
		player_state = "run_" if is_running else "walk_"



func handle_movement(delta: float) -> void :

		velocity = direction * current_speed
		_update_animation(direction)

func _update_animation(dir: Vector2) -> void :


	if dir == Vector2.ZERO:
		animated_sprite.play("idle")
	else:

		if abs(dir.x) > abs(dir.y):
			if dir.x > 0:
				animated_sprite.play(player_state + "right")
			else:
				animated_sprite.play(player_state + "left")
		else:
			if dir.y > 0:
				animated_sprite.play(player_state + "down")
			else:
				animated_sprite.play(player_state + "up")

func update_noise_level():
	
	noise_modifier = level.get_custom_data_at(player_position.global_position, "noise_modifier")
	var noise_type = 2.0 if is_running else 1.0
	noise_level = 10 * noise_modifier * noise_type
	if noise_level >= 80:
		level.play_noise_animation()
		if not door_sound.is_playing():
			door_sound.play()
		if not game_over:
			Player.lose_game("You made loud noises!")
			game_over = true

func update_sfx():
	if player_state == "idle":
		grass_walk_sound.stop()
		gravel_walk_sound.stop()
		grass_run_sound.stop()
		gravel_run_sound.stop()
	elif player_state == "run_":
		if noise_modifier == 5.0:
			if not gravel_run_sound.is_playing():
				gravel_run_sound.play()
		else:
			if not grass_run_sound.is_playing():
				grass_run_sound.play()
	elif player_state == "walk_":
		if noise_modifier == 5.0:
			if not gravel_walk_sound.is_playing():
				gravel_walk_sound.play()
		else:
			if not grass_walk_sound.is_playing():
				grass_walk_sound.play()



func stop_all_sfx():
	grass_walk_sound.stop()
	gravel_walk_sound.stop()
	grass_run_sound.stop()
	gravel_run_sound.stop()


func win_game():
	if game_over:
		return

	print("You win!")
	game_over = true
	set_physics_process(false)
	stop_all_sfx()
	score += 1000
	level.update_score_label(score)
	await _instance.get_tree().create_timer(1.5).timeout
	SceneManager.go_to_win_screen()
	
func play_level_02():
	if game_over:
		return

	print("You win!")
	game_over = true
	set_physics_process(false)
	stop_all_sfx()
	score += 1000
	level.update_score_label(score)
	await _instance.get_tree().create_timer(1.5).timeout
	SceneManager.go_to_level02_scene()

static func lose_game(reason: String = ""):
	if _instance and not _instance.game_over:
		print("You lose! ", reason)
		_instance.game_over = true
		_instance.set_physics_process(false)
		_instance.stop_all_sfx()
		await _instance.get_tree().create_timer(2.0).timeout
		SceneManager.go_to_game_over()
