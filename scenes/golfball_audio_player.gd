class_name GolfballAudioPlayer extends Node3D

const MIN_IMPACT_VOLUME = -7.5
const VOLUME_OFFSET = 0

@onready var golfball_rigidbody = $".."/Golfball

@export_dir var sounds_path
@onready var audio_players = []

var audio = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_sounds(sounds_path)
	get_audio_players()
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
				audio[sound_key] = get_sounds_in_path(sounds_path)
			else:
				dir.list_dir_end()
				break

func get_sounds_in_path(path):
	var arr = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		while true:
			var tmp = dir.get_next()
			if tmp != "":
				var tmp_path = dir.get_current_dir() + "/" + tmp
				# Fixes exporting audio, removes suffix .remap and .import
				tmp_path = tmp_path.trim_suffix(".remap")
				tmp_path = tmp_path.trim_suffix(".import")
				arr.append(load_mp3(tmp_path))
			else:
				dir.list_dir_end()
				break
	print(arr)
	return arr

func load_mp3(path):
	return ResourceLoader.load(path)

func play_audio(body):
	#Play sound only for player
	if not golfball_rigidbody.get_parent().is_multiplayer_authority():
		return
	
	var audio_clips = get_body_material(body)
	# If body has corresponding audio
	if not audio_clips:
		return
	
	var tmp_audio_player = get_inactive_audio_player()
	# No free audio player, return!
	if not tmp_audio_player:
		return
	
	set_audio(tmp_audio_player, audio_clips)
	set_audio_player_volume(tmp_audio_player)
	tmp_audio_player.play()

func get_audio_players():
	audio_players.clear()
	for child in get_children():
		if child is AudioStreamPlayer:
			audio_players.append(child)

func get_inactive_audio_player():
	for audio_player in audio_players:
		if not audio_player.playing:
			return audio_player

func get_body_material(body):
	for group in body.get_groups():
		if audio.has(group):
			return audio[group]
	return null

func set_audio(audio_player, audio_clips):
	audio_player.stream = audio_clips[randi()%audio_clips.size()]

func set_audio_player_volume(audio_player):
	var volume = golfball_rigidbody.linear_velocity.length() + MIN_IMPACT_VOLUME
	volume = clamp (volume, MIN_IMPACT_VOLUME, 0)
	audio_player.volume_db = volume + VOLUME_OFFSET
