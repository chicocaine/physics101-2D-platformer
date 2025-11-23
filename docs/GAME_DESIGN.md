# Game Design Document
## Physics101 2D Platformer

---

## Overview
Physics101 is an educational 2D platformer designed to teach physics concepts through interactive simulations and gameplay. Players explore different levels, each showcasing specific physics principles in an engaging and intuitive way.

---

## Core Gameplay Mechanics

### Player Movement
The player's primary means of traversing and interacting with the world:
- **Move** - Left/right movement
- **Jump** - Vertical movement and platforming
- **Swing** - Apply forces while hanging on a wall to start swinging
- **Hang** - Attach to ropes, ledges, or walls
- **Interact** - Engage with simulation elements and objects

---

## UI and Navigation

### Main Menu
- The main menu can be designed as a hub level with entry points (doors) leading to different levels or simulations

### Pause Menu
Essential pause menu functionality:
- Music toggle
- SFX (sound effects) toggle
- Return to main menu option

---

## Featured Physics Simulations

### Possible Concepts/Features
The game may include interactive simulations of the following physics concepts:

- **Measurements & Fundamentals**
  - Vectors
  - Forces and equilibrium of forces
  - Torque and center of mass
  - Levers and mechanical advantage
  - Pulleys and pulley systems

- **Classical Mechanics**
  - Laws of motion (e.g., collision demo between different masses on a frictionless surface)
  - Work, energy, and conservation
  - Power, momentum, and impulse

- **Motion Types**
  - Motion on a plane - rectilinear
  - Free fall
  - Projectile motion
  - Rotational motion

- **Advanced Mechanics**
  - Rope swing/pendulum swing (including double pendulum demonstrations)
  - Fluid mechanics
  - Temperature
  - Elasticity (?)

---

## Simulation Design Principles

### What Every Feature/Simulation Should Accomplish

1. **Educational Value**
   - Showcase specified physics concept(s) through interactive exploration
   - Allow players to observe and manipulate the mechanics of each concept

2. **User Experience**
   - Keep simulations simple and intuitive
   - Maintain educational value while being engaging
   - Design for accessibility and understanding

3. **Player Agency**
   - Provide maximum freedom for exploration
   - Allow parameter adjustments (e.g., mass, velocity, friction)
   - Include independent step-speed control for simulations if possible
   - Enable experimentation and discovery

4. **Core Functions**
   - **Entry** - Clear introduction to the simulation
   - **Exit** - Ability to leave and return to menu
   - **Reset** - Restore simulation to initial state

---

## Level Design Guidelines

### Concept Separation
1. Each physics concept should be showcased in separate level(s) to maintain focus on the "Concept of the Level"
   - **Exception**: Exceptions can be made if two concepts are purposefully or realistically related and are both features of the level simulation.

### Scope and Requirements
2. Not all listed physics concepts are required to be implemented
   - The complete list represents long-term goals
   - Prioritize quality and educational value over quantity

### Development Process
3. When creating a new level/simulation:
   - Focus on clear demonstration of the chosen concept
   - Ensure interactivity supports learning
   - Test for both educational effectiveness and fun factor
   - Consider creating level-specific documentation (e.g., `MAGNETIC_FORCES.md`) in the `docs/` folder to detail:
     - Physics concepts covered
     - Mechanics and interactions
     - Parameter ranges and defaults
     - Learning objectives

---

## Educational Goals

### Learning Through Play
- Players should naturally discover physics principles through experimentation
- Mistakes and unexpected results are learning opportunities
- Visual feedback should clearly demonstrate cause and effect
- Gradual complexity increase helps build understanding

### Interactive Demonstrations
- Each simulation should answer "what happens if...?" questions
- Parameters should be adjustable in real-time when possible
- Visual aids (vectors, force arrows, trajectories) enhance comprehension
- Quantitative feedback (measurements, graphs) reinforces concepts

---

## Future Considerations

### Potential Expansions
- Additional physics domains (optics, electromagnetism, thermodynamics)
- Multi-step puzzles requiring applied physics knowledge
- Sandbox mode for free experimentation
- Challenge modes with specific objectives
- Progress tracking and achievement system

### Quality of Life Features
- Tutorial system for new physics concepts
- In-game physics reference guide
- Screenshot/replay system for interesting simulations
- Customizable difficulty/complexity settings
