extends Control
@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options
@onready var credits: Panel = $Credits


func _ready():
	main_buttons.visible = true
	options.visible = false
	credits.visible = false

func _on_start_button_pressed() -> void :
	get_tree().change_scene_to_file("res://scenes/level_01_order.tscn")


func _on_exit_button_pressed() -> void :
	get_tree().quit()


func _on_options_button_pressed() -> void :
	main_buttons.visible = false
	options.visible = true


func _on_back_pressed() -> void :
	_ready()


func _on_credits_button_pressed() -> void :
	credits.visible = true
	main_buttons.visible = false
