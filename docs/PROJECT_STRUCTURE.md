# Project Structure & Standards

**Engine Version:** Godot 4.5.1 (Stable)  
**Language:** GDScript (primary)

---

## 📁 Project Overview

This document explains the project’s file structure and organizational rules for contributors.  
The main goal is to **keep gameplay composition and logic cleanly separated** for easier collaboration and scalability.

---

## 🧱 Folder Structure
```bash
physics101-2D-platformer
├── addons/ # Optional Godot plugins or custom tools
├── assets/ # All raw art, audio, and fonts
│ ├── art/
│ │ ├── characters/
│ │ ├── tilesets/
│ │ ├── props/
│ │ └── backgrounds/
│ ├── audio/
│ │ ├── sfx/
│ │ └── music/
│ └── fonts/
├── scenes/ # Game objects and world composition
│ ├── player/
│ ├── environment/
│ ├── levels/
│ └── ui/
├── scripts/ # Logic, systems, utilities (code only)
│ ├── player/
│ ├── physics/
│ ├── managers/
│ └── utils/
├── ui/ # Menu and interface layouts
│ └── menus/
├── docs/ # Design notes, documents, references
├── .gitignore
└── project.godot
```
## 🎭 `scenes/` – Game Objects (Composition Layer)

**Scenes** in Godot are the *building blocks* of the game.  
They represent **objects with a presence in the world** — things you can see, interact with, or place in a level.

Examples:
- `Player.tscn`
- `Rope.tscn`
- `EnemyBat.tscn`
- `Level1.tscn`

Each scene defines:
- Node hierarchy (physics, sprites, shapes, animations)
- Optional behavior script attached to the root node

Example:
```bash
Player.tscn
├─ RigidBody2D
│ ├─ CollisionShape2D
│ ├─ Sprite2D
│ └─ RayCast2D
└─ Player.gd (attached script)
```

Scenes are **instanced** into other scenes to form complex compositions (like levels).

---

## 🧠 `scripts/` – Logic & Systems (Behavior Layer)

The `scripts/` folder contains **pure code** and reusable systems that define **how things behave**, but are not tied to any particular scene.

This includes:
- Game managers (`GameManager.gd`, `AudioManager.gd`)
- Physics solvers (`RopeSolver.gd`)
- Utility classes (`MathUtils.gd`)
- Shared AI or input logic

These scripts:
- Can be used across multiple scenes
- May be autoloaded as singletons (for global systems)
- Are written for modularity and reusability

Example:
```bash
scripts/physics/RopeSolver.gd
scripts/managers/GameManager.gd
scripts/utils/VectorMath.gd
```

---

## ⚖️ Separation Philosophy

| Concept | Stored In | Purpose |
|----------|------------|---------|
| **Game Object** | `scenes/` | Visual + physical entity (player, rope, level, UI) |
| **Behavior / Logic** | `scripts/` | Code that defines *how* things move, react, or interact |
| **Scene-specific behavior** | Same folder as scene | E.g., `Player.tscn` → `Player.gd` |
| **Shared logic or systems** | `scripts/` | Reusable helpers, managers, utilities |

If you’re unsure where to place something:
> “Does this have a physical or visual presence in the game world?”  
> - ✅ Yes → put it in `/scenes/`  
> - 🧠 No → put it in `/scripts/`

---

## 🧩 Example in Practice

**Scene:** `scenes/environment/Rope.tscn`  
Defines a visual rope and anchor point.

**Script:** `scripts/physics/RopeSolver.gd`  
Handles rope math, tension, and swing simulation.

Usage:
```gdscript
# Rope.gd (attached to Rope.tscn)
const RopeSolver = preload("res://scripts/physics/RopeSolver.gd")

func _physics_process(delta):
    var tension = RopeSolver.calculate_tension(current_angle, player_mass, swing_velocity)
```
This keeps your *game object (rope)* separate from its *underlying physics logic*.

---

## 🤝 Collaboration Guidelines

- Use feature branches (e.g. `feature/player-swing`, `fix/jump-collision`)
- Avoid editing the same `.tscn` files simultaneously
- Prefer **instanced scenes** over large monolithic ones
- Keep naming consistent:
    - Scenes: `PascalCase` → `Player.tscn`
    - Scripts: `snake_case` → `player_controller.gd`
    - Nodes in editor: `snake_case` → `collision_shape`, `sprite_body`
- Use signals for communication between scenes instead of direct references

---

## 🧾 Version Control Notes

Godot 4 uses text-based scene (`.tscn`) and resource (`.tres`) files — these are merge-friendly.

Recommended .gitignore:
```gitignore
.import/
.godot/
export.cfg
export_presets.cfg
*.tmp
*.import
```
If using large assets (audio, textures), consider **Git LFS**.

---

## 🚀 Summary
- Godot 4.5.1 (Stable)
- GDScript-first development
- `scenes/` = game objects & composition
- `scripts/` = logic, physics, systems
- Modular, instanced, and merge-friendly design

> Keep it clean, modular, and readable — every contributor should know where things belong at a glance.