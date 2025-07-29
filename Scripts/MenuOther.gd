extends Control




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Sensitivity.sens = $Opt/HSlider.value


func _on_back_menu_pressed() -> void:
	self.hide()
	$"../Title".show()

func _on_how_pressed() -> void:
	$HowScreen.show()

func _on_back_how_pressed() -> void:
	$HowScreen.hide()

func _on_options_pressed() -> void:
	$Opt.show()

func _on_back_opt_pressed() -> void:
	$Opt.hide()

func _on_credits_pressed() -> void:
	$Credits.show()

func _on_press_to_exit_cred_pressed() -> void:
	$Credits.hide()
