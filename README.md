# Phyics101 2D Platformer

A **2D physics-driven platformer** built in **Godot 4.5.1 (Stable)**.  
Realistic movement, grounded jumping, and pendulum-style swinging mechanics.

---

## 🧩 Overview

Ember Platformer aims to blend **realistic physics** with responsive platforming.  
Players can run, jump, and swing across environments with believable weight and motion.

Built collaboratively in **Godot Engine**, using **GDScript** for quick iteration and clear structure.

---

## ⚙️ Tech Stack

| Component | Technology |
|------------|-------------|
| Engine | [Godot 4.5.1 (Stable)](https://godotengine.org/download) |
| Language | GDScript (primary) |
| Physics | Built-in 2D physics with custom extensions |
| Version Control | Git + GitHub / GitLab |
| Optional | Git LFS for large assets (textures, audio) |

---

## 📂 Project Structure

The project separates **game objects (scenes)** from **game logic (scripts)** for clarity and team efficiency.
```bash
/physics101-2D-platformer/
├── assets/ # Art, audio, fonts
├── scenes/ # Game objects (player, rope, enemies, levels)
├── scripts/ # Behavior, systems, and reusable logic
├── ui/ # Menus and interface layouts
├── docs/ # Documentation and design notes
└── project.godot # Godot project file
```

🔹 **`scenes/`** → The *what*: objects and environments you see and interact with.  
🔹 **`scripts/`** → The *how*: logic and systems that define behavior.

See [`PROJECT_STRUCTURE.md`](docs/PROJECT_STRUCTURE.md) for a detailed breakdown and conventions.

---

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/<your-org>/ember-platformer.git
cd ember-platformer
```
### 2. Open in Godot
1. Launch **Godot 4.5.1 (Stable)**.
2. Choose Import, select `project.godot`.
3. Open the project.
### 3. Run the Test Scene
Open `scenes/test/PhysicsTest.tscn` (or equivalent) and press Play ▶️.
You should see the basic player movement and physics prototype.

---

## 👥 Collaboration Workflow
### Branch Naming Convention
Use short, descriptive prefixes:
- `feature/` – new feature (e.g. `feature/swing-mechanic`)
- `fix/` – bug fix (e.g. `fix/player-jump-collision`)
- `level/` – level design updates
- `art/` – new assets
### Workflow
1. Pull latest changes from `main`
2. Create a feature branch
3. Make your updates
4. Commit and push
5. Open a Pull Request for review

### Avoid Merge Conflicts
- Don’t edit the same `.tscn `scene simultaneously
- Use instanced scenes to compose levels and systems
- Communicate major changes in Discord or project chat

---

## 📖 Documentation
- `PROJECT_STRUCTURE.md` → File organization and contribution standards
- `docs/design_notes.md` → Gameplay, physics, and system design details (coming soon)

---

## 💬 Communication
Use your project Discord or issue tracker for:
- Task coordination
- Asset requests
- Feature discussions
