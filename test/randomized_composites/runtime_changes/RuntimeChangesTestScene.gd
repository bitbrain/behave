extends Node2D

@onready var sequence_random: SequenceRandomComposite = %SequenceRandom


func set_weights(idle: int, run: int, attack_meele: int, attack_ranged: int):
	sequence_random.set("Weights/Idle", idle)
	sequence_random.set("Weights/Run", run)
	sequence_random.set("Weights/Attack Meele", attack_meele)
	sequence_random.set("Weights/Attack Ranged", attack_ranged)
