class_name Game extends Node

const DID_NOT_FINISH_SCORE = 14

var player : Golfball
var players_won : int
var finished : bool

var hud : UserHUD
var menu_background : MenuBackground
var level_select : LevelSelect
var scoreboard : Scoreboard
var game_status : GameStatus

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

	next_hole.rpc()

@rpc("authority", "call_local")
func next_hole():
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
	if game_active:
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

func golball_left():
	player.move_back()

func player_won():
	level_select.activate_hole_camera()
	game_win.rpc()

@rpc("any_peer", "call_local")
func game_win():
	finished = true
	players_won += 1
	print("winners: " + str(players_won))
	player.disable.rpc()
	update_gui.rpc()
	
	if players_won == get_tree().get_nodes_in_group("players").size():
		print("All players have won")
		hud.stop_timer()
		if multiplayer.is_server():
			next_hole.rpc()















#SETTERS
func set_hud(hud):
	self.hud = hud

func set_menu_background(menu_background):
	self.menu_background = menu_background

func set_level_select(level_select):
	self.level_select = level_select

func set_scoreboard(scoreboard):
	self.scoreboard = scoreboard

func set_game_status_ui(game_status_ui):
	game_status = game_status_ui

func set_singleplayer():
	level_select.activate()

func set_player(player):
	if not self.player:
		self.player = player
