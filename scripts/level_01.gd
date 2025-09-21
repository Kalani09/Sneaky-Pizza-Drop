extends Node2D

class_name Level01



@onready var ground_layer: TileMapLayer = $TileMap / NoiseGround
@onready var Door: AnimatedSprite2D = $Animated_House / Door
@onready var WindowDown1: AnimatedSprite2D = $Animated_House / Window_Down_1
@onready var WindowDown2: AnimatedSprite2D = $Animated_House / Window_Down_2
@onready var WindowUp: AnimatedSprite2D = $Animated_House / Window_Up
@onready var Cat: AnimatedSprite2D = $Animated_House / Cat
@onready var win_area: Area2D = $WinArea
@onready var timer_label: Label = $"CanvasLayer/TimerLabel"
@onready var level_01_customer: CharacterBody2D = $Level01_Customer
@onready var customer_voice: AudioStreamPlayer = $Level01_Customer / CustomerVoice
@onready var score_label: Label = $CanvasLayer/ScoreLabel



static  var _instance: Level01 = null
var game_over: bool = false
var caught_timer: float = 0.0
var catch_delay: float = 2.0
var score: int = 0

func _ready():
	_instance = self if _instance == null else _instance
	level_01_customer.visible = false
	
		

	if win_area:
		win_area.body_entered.connect(_on_win_area_body_entered)


func _process(delta):
	update_timer_display()

func update_timer_display():

	var level_timer = get_node("LevelTimer")
	if level_timer and timer_label:
		var time_remaining = level_timer.time_left
		var minutes = int(time_remaining) / 60
		var seconds = int(time_remaining) %60
		timer_label.text = "%02d:%02d" % [minutes, seconds]


		if time_remaining < 10:
			timer_label.modulate = Color.RED
		elif time_remaining < 30:
			timer_label.modulate = Color.YELLOW
		else:
			timer_label.modulate = Color.WHITE

static func get_tile_data_at(map_position: Vector2) -> TileData:
	var local_point: Vector2 = _instance.ground_layer.to_local(map_position)
	var local_position: Vector2i = _instance.ground_layer.local_to_map(local_point)
	return _instance.ground_layer.get_cell_tile_data(local_position)


static func get_custom_data_at(map_position: Vector2, custom_data_name: String) -> float:

	var data = get_tile_data_at(map_position)
	var cd = data.get_custom_data(custom_data_name)
	return cd

static func play_noise_animation() -> void :
	_instance.Door.play("open")
	_instance.WindowDown1.play("open")
	_instance.WindowDown2.play("open")
	_instance.WindowUp.play("open")
	_instance.Cat.play("appear")
	_instance.level_01_customer.visible = true
	_instance.customer_voice.play()


static func update_score_label(score: int):
	_instance.score_label.text = "💰: " + str(score)


func _on_win_area_body_entered(body: Node2D) -> void :
		if body.is_in_group("Player") and not game_over:
			body.play_level_02()
			game_over = true


func _on_level_timer_timeout() -> void :
	if not game_over:
			play_noise_animation()
			Player.lose_game("Time ran out!")
			game_over = true
			
func display_score() ->void:
	var player_score = "0000" if score == 0 else str(score)
	if score_label:
		score_label.set_text("💰" + player_score) 
		score_label.visible = true
