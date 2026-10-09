extends CharacterBody3D

@export var speed := 5.0
@export var jump_velocity := 4.5
@export var mouse_sensitivity := 0.3
@export var attack_damage := 10
@export var attack_range := 2.0
@export var attack_cooldown := 1.0

var health := 100.0
var can_attack := true

@onready var camera := $Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y -= 9.8 * delta

	# Movement
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Attack
	if Input.is_action_just_pressed("attack") and can_attack:
		_attack()
		can_attack = false
		# Start cooldown timer (simple version)
		$AttackTimer.start() if has_node("AttackTimer") else set_process_timer(True)

	move_and_slide()

	# Simple health drain for demonstration (over time)
	health -= delta * 0.1  # loses 0.1 health per second
	if health <= 0:
		health = 0
		print("Player died")
		# In a real game, you'd trigger a game over here

func _attack():
	var areas = get_world_3d().direct_space_state.intersect_shape(Shape3D.new_sphere(attack_range, global_transform.origin))
	for area in areas:
		if area.get_collider().has_method("take_damage"):
			area.get_collider().take_damage(attack_damage)
			print("Hit enemy for ", attack_damage, " damage")

func _on_AttackTimer_timeout():
	can_attack = true
	set_process_timer(False)

func take_damage(amount):
	health -= amount
	if health <= 0:
		health = 0
		print("Player died")