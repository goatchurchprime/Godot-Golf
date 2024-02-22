class_name GolfballAudioPlayer extends Node3D

const MIN_IMPACT_VOLUME = -7.5
const VOLUME_OFFSET = -10

@onready var golfball_rigidbody = $".."/Golfball
@export var impact_sounds : Array[AudioStream] = []
@onready var audio_players = []


# Called when the node enters the scene tree for the first time.
func _ready():
	get_audio_players()
	golfball_rigidbody.body_entered.connect(play_audio)

func get_audio_players():
	audio_players.clear()
	for child in get_children():
		if child is AudioStreamPlayer:
			audio_players.append(child)

func get_inactive_audio_player():
	for audio_player in audio_players:
		if not audio_player.playing:
			return audio_player

func randomize_audio(audio_player):
	audio_player.stream = impact_sounds[randi()%impact_sounds.size()]

func play_audio(body):
	#Play sound only for player
	if not golfball_rigidbody.get_parent().is_multiplayer_authority():
		return
		
	if not collision_conditions_met(body):
		return
	
	var tmp_audio_player = get_inactive_audio_player()
	# No free audio player, return!
	if not tmp_audio_player:
		return
	
	randomize_audio(tmp_audio_player)
	set_audio_player_volume(tmp_audio_player)
	tmp_audio_player.play()

func collision_conditions_met(body):
	if body is StaticBody3D:
		if not body.physics_material_override:
			return false
		if body.physics_material_override.rough == false:
			return false
	return true

func set_audio_player_volume(audio_player):
	var volume = golfball_rigidbody.linear_velocity.length() + MIN_IMPACT_VOLUME
	volume = clamp (volume, MIN_IMPACT_VOLUME, 0)
	audio_player.volume_db = volume + VOLUME_OFFSET
