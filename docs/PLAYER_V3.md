> Player V3 (RigidBody2D) in godot

### Conceptual Architecture
“A controllable RigidBody2D whose movement feels character-like but still obeys physical laws, and whose parameters can be adjusted at runtime to study and manipulate the simulation.”
 - The player is **subject to physics** (mass, gravity, friction, impulse).
 - The player is **controlled by applying forces/impulses**, not by teleporting velocity.
 - **All parameters** — like gravity, mass, friction, strength, jump height, etc. — **can be exposed as variables** that can be tweaked from a UI or inspector.
 - **The environment** defines “global” constants (like gravity, air drag, magnetic fields), but can be overriden or scaled locally for experiments.

 ### Core Tunable Parameters

 1. Physical properties (intrinsic to the player)
| Property          | Symbol | Unit | Purpose                                   | Example Effect                             |
| ----------------- | ------ | ---- | ----------------------------------------- | ------------------------------------------ |
| `mass`            | m      | kg   | Determines inertia and response to forces | Heavy player pushes lighter objects easily |
| `friction_coeff`  | μ      | —    | Surface friction with ground or objects   | Higher = harder to slide                   |
| `restitution`     | e      | —    | Bounciness                                | 0 = no bounce, 1 = perfectly elastic       |
| `linear_damping`  | —      | —    | Air resistance                            | Simulates drag, affects glide              |
| `angular_damping` | —      | —    | Rotational air resistance                 | Slows spins                                |
→ These map directly to built-in RigidBody2D properties and `PhysicsMaterial`.

2. Control properties (how input maps to forces)
| Property         | Symbol | Unit | Description                              | Role                                           |
| ---------------- | ------ | ---- | ---------------------------------------- | ---------------------------------------------- |
| `move_force`     | Fₓ     | N    | Max horizontal force applied when moving | Feels like “player strength” for walking       |
| `jump_impulse`   | J      | N·s  | Impulse applied when jumping             | Affects jump height                            |
| `run_multiplier` | —      | —    | Scales movement force when “running”     | Sprinting behavior                             |
| `air_control`    | —      | —    | % of move force available in air         | Controls air steering                          |
| `ground_drag`    | —      | —    | How fast velocity decays on ground       | Simulates friction feel, not physical friction |
| `air_drag`       | —      | —    | How fast velocity decays in air          | Preserves or kills momentum                    |
→ These are the tunable game-feel parameters, and will be implemented through forces.

3. Environment physics parameters (global)
| Parameter                 | Symbol | Unit      | Description                      |
| ------------------------- | ------ | --------- | -------------------------------- |
| `gravity`                 | g      | m/s²      | Acceleration due to gravity      |
| `air_density`             | ρ      | kg/m³     | Used for drag force calculations |
| `magnetic_field_strength` | B      | T (tesla) | For magnetic simulations         |
| `light_refraction_index`  | n      | —         | For optical simulation tests     |
→ These will live in an **Environment Controller node**, accessible by all simulation actors (player + objects).

4. Interaction parameters (how player affects objects)
| Property             | Description                                                               | Notes                                        |
| -------------------- | ------------------------------------------------------------------------- | -------------------------------------------- |
| `push_strength`      | How strongly the player applies impulse when contacting a pushable object | Derived from player’s move force or mass     |
| `grip_strength`      | How much force the player can exert when latching/magnetizing             | Used for “magnetic latch”                    |
| `drag_objects`       | Whether player can pull rigidbodies by force                              | Good for “tug” demo                          |
| `collision_transfer` | How much momentum is transferred when colliding                           | Controlled via restitution and relative mass |

### Concept of *Tunability*

“Tunability” means:
- All important stats are @export or adjustable via in-game UI sliders.
- Adjusting any parameter should immediately affect the simulation (no restarts).
- Parameters can be saved and restored (preset systems for experiments).

To support this:
- Each “tunable” property can have:
	- a name,
	- min/max values,
	- default value, and
	- update callback.

We will use a StatController class to manage that.
*example:*
```gdscript
class_name TunableStat
var name: String
var value: float
var min_value: float
var max_value: float
var on_change: Callable
```
*player can have:*
```gdscript
var tunables = {
	"mass": TunableStat.new("Mass", 1.0, 0.1, 100.0, func(): _update_mass()),
	"move_force": TunableStat.new("Move Force", 500.0, 0.0, 2000.0, func(): _update_force())
}
```
Qhen the player adjusts a slider for “mass,” it calls `_update_mass()` and updates the actual `RigidBody2D.mass`.
