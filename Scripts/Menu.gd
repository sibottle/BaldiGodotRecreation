extends Control

const HereSchool = "res://Balids .tscn"
var isLoading = false

# play baldis voiceline and intro music when scene loads
func _ready() -> void:
	$BaldiText.play()
	$Music.play()

# player want to leave the game (wahh :( )
func _on_exit_pressed() -> void:
	get_tree().quit()

func _process(delta: float) -> void:
	if !isLoading:
		pass
	else:
		var load_status = ResourceLoader.load_threaded_get_status(HereSchool)
		# if status is...
		match load_status:
			ResourceLoader.THREAD_LOAD_LOADED: # scene loaded,
				get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(HereSchool)) #change to the school scene
			ResourceLoader.THREAD_LOAD_FAILED: # scene couldnt load because idk why im not the godot here
				OS.crash("couldnt load game scene. please contact technical support or create an issue on https://github.com/sibottle/BaldiGodotRecreation/issues")

# change title menu to gamemode selection
func _on_start_pressed() -> void:
	$Title.hide()
	$Gamemode.show()

# same as the previous one but backwards
func _on_back_gam_pressed() -> void:
	$Gamemode.hide()
	$Title.show()

# start to preload balids scene, and show "L O A D" animation
func _on_story_pressed() -> void:
	isLoading = true
	ResourceLoader.load_threaded_request(HereSchool)
	$Gamemode.hide()
	$LoadLOadStillLoad/AnimatedSprite2D.play("default")
	$LoadLOadStillLoad.show()


func _on_menu_pressed() -> void:
	$Menu.show()
	$Title.hide()
