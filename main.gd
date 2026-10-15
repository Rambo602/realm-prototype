extends Node3D

const SPEED := 6.0
const CAM_OFFSET := Vector3(0, 14, 10)
var hero: MeshInstance3D
var cam: Camera3D
var target := Vector3(0, 1, 0)

func _ready():
    var env := WorldEnvironment.new()
    var e := Environment.new()
    e.background_mode = Environment.BG_COLOR
    e.background_color = Color(0.1, 0.12, 0.18)
    e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    e.ambient_light_color = Color(0.5, 0.5, 0.6)
    env.environment = e
    add_child(env)

    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-55, 30, 0)
    add_child(sun)

    var ground := MeshInstance3D.new()
    var plane := PlaneMesh.new()
    plane.size = Vector2(80, 80)
    ground.mesh = plane
    var gm := StandardMaterial3D.new()
    gm.albedo_color = Color(0.25, 0.4, 0.2)
    ground.material_override = gm
    add_child(ground)

    hero = MeshInstance3D.new()
    hero.mesh = CapsuleMesh.new()
    hero.position = Vector3(0, 1, 0)
    add_child(hero)

    cam = Camera3D.new()
    cam.rotation_degrees = Vector3(-55, 0, 0)
    cam.position = hero.position + CAM_OFFSET
    add_child(cam)

func _unhandled_input(ev):
    if ev is InputEventMouseButton and ev.pressed:
        var origin := cam.project_ray_origin(ev.position)
        var dir := cam.project_ray_normal(ev.position)
        var hit = Plane(Vector3.UP, 0).intersects_ray(origin, dir)
        if hit:
            target = Vector3(hit.x, 1, hit.z)

func _process(delta):
    var d := target - hero.position
    if d.length() > 0.1:
        hero.position += d.normalized() * min(SPEED * delta, d.length())
    cam.position = hero.position + CAM_OFFSET
