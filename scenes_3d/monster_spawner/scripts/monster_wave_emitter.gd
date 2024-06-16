class_name MonsterWaveEmitter
extends Node

## Emitted when all monsters in the current wave are defeated
## or in a user defined way
signal next_wave(current_wave : int)


enum EmissionMode {
	## When all monsters from MonsterWave nodes with the current wave_number
	## have been defeated a new wave with start automatically
	WAIT_FOR_WAVES_TO_CLEAR,
	## In this case you decide, for instance by adding a timer interval 
	## which connects to the _start_next_wave() function
	USER_DEFINED
}

## The number of times a new wave should be started
@export var number_of_waves : int = 1
@export var mode : EmissionMode = EmissionMode.WAIT_FOR_WAVES_TO_CLEAR

var current_wave = 0


func start_next_wave():
	if current_wave < number_of_waves:
		current_wave += 1
		next_wave.emit(current_wave)


func current_waves_are_cleared() -> bool:
	var all_waves = (
		get_tree()
			.get_nodes_in_group(Constants.GROUP_NAME_MONSTER_WAVES)
	)
	for wave : MonsterWave in all_waves:
		if wave.wave_number == current_wave:
			return false
	
	return true


func last_wave_cleared() -> bool:
	return current_wave == number_of_waves and current_waves_are_cleared()


func _start_next_wave_when_waves_are_cleared():
	if mode == EmissionMode.USER_DEFINED:
		return

	if current_waves_are_cleared():
		start_next_wave()

