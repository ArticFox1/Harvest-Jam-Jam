extends CharacterBody2D


const Speed: float = 90
const GroundedAccleration: float = 1000
const GroundedExceedAcceleration: float = 600

const JumpHeight: float = 12
const HalfGravityThreshold: float = 40
const JumpHoldTime: float = 0.2
const CoyoteTime: float = 0.1
const BufferTime: float = 0.05

var GroundTimer: float = 0
var BufferTimer: float = 0
var JumpHoldTimer: float = 0
var IsJumpInput: bool = false
var SaveJumpVelocity: float = 0

func Jump(JumpForce: float) -> void:
	BufferTimer = 0
	JumpHoldTimer = JumpHoldTime
	velocity.y = minf(0,velocity.y)
	velocity.y -= JumpForce
	SaveJumpVelocity = velocity.y
	IsJumpInput = true

func _physics_process(dt: float) -> void:
	# Add the gravity.
	var Gravity: float = get_gravity().y
	var LocalGravity: float = Gravity
	var JumpForce: float = sqrt(2*Gravity*JumpHeight)
	
	var Grounded: bool = is_on_floor()
	
	var JumpPressed: bool = Input.is_action_just_pressed("Jump")
	var JumpHeld: bool = Input.is_action_pressed("Jump")
	var JumpReleased: bool = Input.is_action_just_released("Jump")
	
	BufferTimer = move_toward(BufferTimer,0,dt)
	JumpHoldTimer = move_toward(JumpHoldTimer,0,dt)
	if Grounded:
		GroundTimer = 0
	else:
		GroundTimer = move_toward(GroundTimer,CoyoteTime,dt)
		if absf(velocity.y) < HalfGravityThreshold and IsJumpInput:
			LocalGravity *= 0.5
		velocity.y += LocalGravity * dt

	# Handle jump.
	if JumpHeld and JumpHoldTimer != 0 and IsJumpInput:
		velocity.y = SaveJumpVelocity
	
	if (JumpPressed or BufferTimer != 0) and GroundTimer < CoyoteTime:
		Jump(JumpForce)
	
	if JumpReleased:
		IsJumpInput = false
	
	if JumpPressed and GroundTimer == CoyoteTime:
		BufferTimer = BufferTime

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("MoveLeft", "MoveRight")
	var Acceleration = GroundedAccleration
	if absf(velocity.x) > Speed:
		Acceleration = GroundedExceedAcceleration
	if direction:
		velocity.x = move_toward(velocity.x, direction * Speed, Acceleration * dt)
	else:
		velocity.x = move_toward(velocity.x, 0, Acceleration * dt)

	move_and_slide()
