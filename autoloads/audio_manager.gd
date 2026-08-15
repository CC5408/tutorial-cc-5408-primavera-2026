extends Node

@export var music_library: Array[AudioStream]
@onready var music_player: AudioStreamPlayer = $MusicPlayer

var _current_song: int = 0

func _ready() -> void:
	music_player.play()

func play_sfx(stream: AudioStream) -> void:
	var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
	audio_stream_player.stream = stream
	audio_stream_player.bus = "SFX"
	add_child(audio_stream_player)
	audio_stream_player.play()
	await audio_stream_player.finished
	audio_stream_player.queue_free()

func next_song() -> void:
	music_player.stop()
	_current_song = wrapi(_current_song + 1, 0, music_library.size())
	music_player.stream = music_library[_current_song]
	music_player.play()
