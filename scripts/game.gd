class_name Game extends Node

const NEXT_HOLE_TIMER_WAIT = 3.0
const DID_NOT_FINISH_SCORE = 14

var players_won : int
var finished : bool

var player : Golfball
var hud : UserHUD
var menu_background : MenuBackground
var level_select : LevelSelect
var scoreboard : Scoreboard
var game_status : GameStatus
var teleport_overlay : TeleportOverlay

var next_hole_timer : Timer

func change_level(level_path, level_name):
	change_level_rpc.rpc(level_path, level_name)

@rpc("authority", "call_local")
func change_level_rpc(level_path, level_name):
	game_status.set_status(GameStatus.statuses.HIDDEN)

	if menu_background:
		menu_background.queue_free()
		menu_background = null
	
	scoreboard.reset()
	update_gui.rpc()
	
	level_select.change_level(level_path, level_name)
	
	game_active(true)

	next_hole()

func next_hole():
	if multiplayer.is_server():
		next_hole_rpc.rpc()

@rpc("authority", "call_local")
func next_hole_rpc():
	print("huumern huumern")
	players_won = 0
	finished = false
	
	update_gui()
	hud.stop_timer()
	level_select.next_hole()
	
	if not level_select.last_hole:
		scoreboard.next_hole()
		hud.start_timer()
		initialize_player(level_select.get_current_spawn_location_transform())
		update_gui()
	else:
		if multiplayer.is_server():
			game_active(false)
		else:
			game_status.set_status(GameStatus.statuses.HOST_CHOOSING_MAP)


@rpc("any_peer", "call_local")
func update_gui():
	hud.update_text(player.putts)
	scoreboard.update()

func game_active(status):
	if status:
		hud.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		level_select.visible = false
	else:
		hud.visible = false
		level_select.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

@rpc("authority", "call_local")
func initialize_player(pos):
	player.enable.rpc(pos, level_select.next_level_rotation())
	player.goto(pos)

func golball_left(peer_id):
	if peer_id == player.get_multiplayer_authority():
		player.move_back()
		if teleport_overlay:
			teleport_overlay.activate()

func player_won(peer_id):
	if peer_id == player.get_multiplayer_authority():
		level_select.activate_hole_camera()
		game_win.rpc(peer_id)

@rpc("any_peer", "call_local")
func game_win(peer_id):
	players_won += 1
	if peer_id == player.get_multiplayer_authority():
		finished = true
		player.disable.rpc()
	
	update_gui.rpc()
	
	if players_won == get_tree().get_nodes_in_group("players").size():
		print("All players have won")
		hud.stop_timer()
		if multiplayer.is_server():
			start_next_hole_timer()

func set_singleplayer():
	level_select.visible = true

func set_multiplayer():
	if multiplayer.is_server():
		level_select.visible = true

func start_next_hole_timer():
	hud.stop_timer()
	if not multiplayer.is_server():
		return
	
	if not next_hole_timer:
		next_hole_timer = initialize_next_hole_timer()
	
	disable_players.rpc()
	next_hole_timer.start()

func initialize_next_hole_timer():
	if not multiplayer.is_server():
		return
	
	if next_hole_timer:
		remove_child(next_hole_timer)
	
	var tmp = Timer.new()
	tmp.wait_time = NEXT_HOLE_TIMER_WAIT
	tmp.autostart = false
	tmp.one_shot = true
	tmp.timeout.connect(next_hole)
	add_child(tmp)
	return tmp

func level_timeout():
	if multiplayer.is_server():
		start_next_hole_timer()

@rpc("authority", "call_local")
func disable_players():
	player.disable.rpc()
	level_select.activate_hole_camera()

func register(node):
	if node is UserHUD:
		hud = node
	elif node is MenuBackground:
		menu_background = node
	elif node is LevelSelect:
		level_select = node
	elif node is Scoreboard:
		scoreboard = node
	elif node is GameStatus:
		game_status = node
	elif node is Golfball:
		if not player:
			player = node
	elif node is TeleportOverlay:
		teleport_overlay = node
