class_name GolfballAudioPlayer extends Node3D

const VOLUME_OFFSET = -15

@onready var golfball_rigidbody = $".."/Golfball

@export_dir var sounds_path

var ready_audio_players = []

var audio_clips = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_sounds(sounds_path)
	initialize_audio_players()
	golfball_rigidbody.body_entered.connect(play_audio)

func initialize_sounds(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		while true:
			var tmp = dir.get_next()
			if tmp != "":
				var sound_key = tmp.capitalize()
				var sounds_path = dir.get_current_dir() + "/" + tmp
				audio_clips[sound_key] = FileFetcher.get_sounds_in_path(sounds_path)
			else:
				dir.list_dir_end()
				break

func initialize_audio_players():
	ready_audio_players.clear()
	for child in get_children():
		if child is AudioStreamPlayer:
			child.finished.connect(audio_player_finished.bind(child))
			ready_audio_players.append(child)

func play_audio(body):
	#Play sound only for player
	if not golfball_rigidbody.get_parent().is_multiplayer_authority():
		return
	
	var audio_clips = get_body_material(body)
	# If material has physics audio
	if not audio_clips:
		return
	
	var audio_player = ready_audio_players.pop_back()
	# No free audio player, return!
	if not audio_player:
		return
	
	set_audio(audio_player, audio_clips)
	set_audio_player_volume(audio_player)
	audio_player.play()

func set_audio(audio_player, audio_clips):
	audio_player.stream = audio_clips[randi()%audio_clips.size()]

func set_audio_player_volume(audio_player):
	var velocity_magnitude = abs(golfball_rigidbody.linear_velocity.length())
	var golfball_max_strength = golfball_rigidbody.get_parent().MAX_STRENGTH
	audio_player.volume_db = velocity_magnitude - golfball_max_strength
	audio_player.volume_db = min(audio_player.volume_db, 0)
	print(audio_player.volume_db)

func get_body_material(body):
	for group in body.get_groups():
		if audio_clips.has(group):
			return audio_clips[group]
	return null

func audio_player_finished(audio_player):
	ready_audio_players.push_back(audio_player)
