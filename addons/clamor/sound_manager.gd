@tool

extends Node

var _players_1d: Array[PooledAudioStreamPlayer] = []
var _players_2d: Array[PooledAudioStreamPlayer2D] = []
var _players_3d: Array[PooledAudioStreamPlayer3D] = []

var num_pooled_sounds = 10
	
func play(sound : SoundReference) -> void:
	var instance = _get_player_1d()
	## TODO: Check whether the sound actually exists :)
	var library = ClamorSettings.get_settings().get_library_by_name(sound.library_id).sounds[sound.sound_id] as Sound
	instance.configure([library.get_stream()], true, "", true, 1.0, 1.0, ProcessMode.PROCESS_MODE_ALWAYS)
	
	instance.trigger()
	instance.release(true)
	
func _ready() -> void:
	_initialize_pools()

func _initialize_pools():
	_initialise_pool(10,
			_create_player_1d)

	_initialise_pool(10,
			_create_player_2d)

	_initialise_pool(10,
			_create_player_3d)

func _create_player_1d() -> PooledAudioStreamPlayer:
	return _add_player_to_pool(PooledAudioStreamPlayer.create(), _players_1d)


func _create_player_2d() -> PooledAudioStreamPlayer2D:
	return _add_player_to_pool(PooledAudioStreamPlayer2D.create(), _players_2d)


func _create_player_3d() -> PooledAudioStreamPlayer3D:
	return _add_player_to_pool(PooledAudioStreamPlayer3D.create(), _players_3d)

func _is_player_free(p_player) -> bool:
	return not p_player.playing and not p_player.reserved
	
func _get_player_from_pool(p_pool: Array) -> Variant:
	if p_pool.size() == 0:
		push_error("Resonate - Player pool has not been initialised. This can occur when calling a [play/instance*] function from [_ready].")
		return null

	for player in p_pool:
		if _is_player_free(player):
			return player

	push_warning("Resonate - Player pool exhausted, consider increasing the pool size in the project settings (Audio/Manager/Pooling) or releasing unused audio stream players.")
	return null


func _get_player_1d() -> PooledAudioStreamPlayer:
	return _get_player_from_pool(_players_1d)


func _get_player_2d() -> PooledAudioStreamPlayer2D:
	return _get_player_from_pool(_players_2d)


func _get_player_3d() -> PooledAudioStreamPlayer3D:
	return _get_player_from_pool(_players_3d)
	
func _initialise_pool(p_size: int, p_creator_fn: Callable) -> void:
	for i in p_size:
		p_creator_fn.call_deferred()
	
func _add_player_to_pool(p_player, p_pool) -> Variant:
	add_child(p_player)

	p_pool.append(p_player)

	return p_player
