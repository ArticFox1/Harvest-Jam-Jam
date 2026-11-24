extends CharacterBody2D

@onready var Animator = $Animator
@onready var LandSound = $Land
@onready var WalkSound = $Walk
@onready var JumpSound = $Jump
@onready var RespawnSound = $Jump
@onready var DeathSound = $Death
@onready var Death1Sound = $Death1
@onready var Background = $Background

const Speed: float = 90
const GroundedAcceleration: float = 1000
const GroundedExceedAcceleration: float = 400
const AirAcceleration: float = 650
const AirExceedAcceleration: float = 260

const JumpHeight: float = 12
const HalfGravityThreshold: float = 40
const JumpHoldTime: float = 0.2
const CoyoteTime: float = 0.1
const BufferTime: float = 0.05
const JumpBoost: float = 20

var GroundTimer: float = 0
var BufferTimer: float = 0
var JumpHoldTimer: float = 0
var IsJumpInput: bool = false
var SaveJumpVelocity: float = 0

var RespawnPoint: Vector2 = Vector2.ZERO

signal Died

func _ready() -> void:
	WalkSound.finished.connect(WalkSoundFinished)
	Background.finished.connect(BackgroundSoundFinished)

func Jump(JumpForce: float) -> void:
	BufferTimer = 0
	JumpHoldTimer = JumpHoldTime
	velocity.y = minf(0,velocity.y)
	velocity.y -= JumpForce
	velocity.x += signf(velocity.x) * JumpBoost
	SaveJumpVelocity = velocity.y
	IsJumpInput = true
	JumpSound.pitch_scale = randfn(1,0.1)
	JumpSound.play()

func Die() -> void:
	Died.emit()
	global_position = RespawnPoint
	if randf() < 0.5:
		DeathSound.pitch_scale = randfn(1,0.1)
		DeathSound.play()
	else:
		Death1Sound.pitch_scale = randfn(1,0.1)
		Death1Sound.play()
	RespawnSound.play()
	

func HurtboxTriggered(_body: Node2D) -> void:
	Die()
	
func WalkSoundFinished() -> void:
	WalkSound.play()

func BackgroundSoundFinished() -> void:
	Background.play()

func _physics_process(dt: float) -> void:
	
	if Input.is_action_just_pressed("SelfDestruct"):
		Die()
	
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
		if GroundTimer > 0:
			LandSound.play()
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
	var Acceleration = GroundedAcceleration
	if is_on_floor():
		if absf(velocity.x) > Speed:
			Acceleration = GroundedExceedAcceleration
	else:
		Acceleration = AirAcceleration
		if absf(velocity.x) > Speed:
			Acceleration = AirExceedAcceleration
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * Speed, Acceleration * dt)
	else:
		velocity.x = move_toward(velocity.x, 0, Acceleration * dt)
	
	move_and_slide()
	
	if velocity.y < 0:
		Animator.play("Jumping")
	elif direction:
		Animator.flip_h = (direction-1)*-0.5
		Animator.play("Walking")
	else:
		Animator.play("Idle")
