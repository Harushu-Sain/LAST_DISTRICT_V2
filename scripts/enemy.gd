extends CharacterBody3D

@export var speed := 2.0
@export var detection_range := 10.0

var target := null
var health := 50.0

func _ready():
	# We'll look for the player by name or group
	pass

func _physics_process(delta):
	if not target:
		# Try to find the player
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			target = players[0]
		return

	var direction = (target.global_transform.origin - global_transform.origin).normalized()
	if direction.length() > 0:
		velocity = direction * speed
		move_and_slide()

	# Simple damage to player on touch (for demonstration)
	if is_colliding():
		var collider = get_slide_collision(0).get_collider()
		if collider.is_in_group("player"):
			collider.health -= 10 * delta  # 10 damage per second when touching