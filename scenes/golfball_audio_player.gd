class_name GolfballAudioPlayer extends Node3D

const MIN_IMPACT_VOLUME = -7.5
const VOLUME_OFFSET = 0

@onready var golfball_rigidbody = $".."/Golfball
@export_dir var wood_sounds_dir
@onready var audio_players = []

var wood_sounds = []


# Called when the node enters the scene tree for the first time.
func _ready():
	wood_sounds = get_sounds_in_path(wood_sounds_dir)
	print(wood_sounds)
	get_audio_players()
	golfball_rigidbody.body_entered.connect(play_audio)

func get_sounds_in_path(path):
	var arr = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		while true:
			var tmp = dir.get_next()
			if tmp != "":
				if tmp.ends_with(".mp3"):
					var sound = load_mp3(path+"/"+tmp)
					arr.append(sound)
			else:
				dir.list_dir_end()
				break
	return arr

func load_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	return sound


func get_audio_players():
	audio_players.clear()
	for child in get_children():
		if child is AudioStreamPlayer:
			audio_players.append(child)

func get_inactive_audio_player():
	for audio_player in audio_players:
		if not audio_player.playing:
			return audio_player

func play_audio(body):
	#Play sound only for player
	if not golfball_rigidbody.get_parent().is_multiplayer_authority():
		return
	
	var audio_clips = get_body_material(body)
	# If body should not play audio, return
	if not audio_clips:
		return
	
	var tmp_audio_player = get_inactive_audio_player()
	# No free audio player, return!
	if not tmp_audio_player:
		return
	
	set_audio(tmp_audio_player, audio_clips)
	set_audio_player_volume(tmp_audio_player)
	tmp_audio_player.play()

func get_body_material(body):
	if body is StaticBody3D:
		if body.is_in_group("Wood"):
			return wood_sounds
	return false

func set_audio(audio_player, audio_clips):
	audio_player.stream = audio_clips[randi()%audio_clips.size()]

func set_audio_player_volume(audio_player):
	var volume = golfball_rigidbody.linear_velocity.length() + MIN_IMPACT_VOLUME
	volume = clamp (volume, MIN_IMPACT_VOLUME, 0)
	audio_player.volume_db = volume + VOLUME_OFFSET
