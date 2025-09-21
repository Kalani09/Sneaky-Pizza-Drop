extends Node


signal scene_changing

var is_changing_scene: bool = false


const SCENES = {
	"main_menu": "res://scenes/main_menu.tscn", 
	"level01": "res://scenes/level_01.tscn", 
	"level02_order": "res://scenes/level_02_order.tscn", 
	"game_over": "res://scenes/lose.tscn",
	"win_screen": "res://scenes/win.tscn"
}



func change_scene_to(scene_name: String, fade_duration: float = 0.5):
	if is_changing_scene:
		return

	if not SCENES.has(scene_name):
		print("Scene not found: ", scene_name)
		return

	is_changing_scene = true
	scene_changing.emit()


	


	get_tree().change_scene_to_file(SCENES[scene_name])



	is_changing_scene = false

func change_scene_to_file(scene_path: String, fade_duration: float = 0.5):
	if is_changing_scene:
		return

	is_changing_scene = true
	scene_changing.emit()




	get_tree().change_scene_to_file(scene_path)



	is_changing_scene = false

func go_to_win_screen():
	change_scene_to("win_screen")

func go_to_level02_scene():
	change_scene_to("level02_order")

func go_to_game_over():
	change_scene_to("game_over")


func go_to_main_menu():
	change_scene_to("main_menu")

func restart_current_level():
	var current_scene = get_tree().current_scene.scene_file_path
	change_scene_to_file(current_scene)
