extends AudioStreamPlayer3D

@onready var Queue = []

func _ready():
	finished.connect(_on_finished)

func add(audio):
	Queue.append(audio)
	if not playing:
		playQueue()

func playQueue() -> void:
	stream = Queue[0]
	play()
	Queue.remove_at(0)
	
func clearQueue():
	Queue.clear()
	stop()
	
func skip():
	stop()
	playQueue()

func _on_finished() -> void:
	if (!Queue.is_empty()):
		playQueue()
