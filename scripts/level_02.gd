extends Node2D

class_name Level02
@onready var noise_ground: TileMapLayer = $TileMap/NoiseLayer
@onready var win_area: Area2D = $WinArea
@onready var timer_label: Label = $CanvasLayer/TimerLabel
@onready var score_label: Label = $CanvasLayer/ScoreLabel
@onready var level_02_customer: CharacterBody2D = $Level02_Customer
@onready var customer_2_voice: AudioStreamPlayer = $Level02_Customer/customer2Voice

static  var _instance: Level02 = null
var game_over: bool = false
var caught_timer: float = 0.0
var catch_delay: float = 2.0
var score: int = 1000
var player

func _ready():
	_instance = self if _instance == null else _instance
	level_02_customer.visible = false
	player = get_node("Player")


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
	var local_point: Vector2 = _instance.noise_ground.to_local(map_position)
	var local_position: Vector2i = _instance.noise_ground.local_to_map(local_point)
	return  _instance.noise_ground.get_cell_tile_data(local_position) 



static func get_custom_data_at(map_position: Vector2, custom_data_name: String) -> float:
	var data = get_tile_data_at(map_position)
	var cd = data.get_custom_data(custom_data_name)
	return cd 

static func play_noise_animation() -> void :
	_instance.level_02_customer.global_position = _instance.player.global_position
	_instance.level_02_customer.visible = true
	_instance.customer_2_voice.play()
	
	
static func update_score_label(score: int):
	_instance.score_label.text = "💰: " + str(score)

func _on_win_area_body_entered(body: Node2D) -> void :
		if body.is_in_group("Player") and not game_over:
			body.win_game()
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
