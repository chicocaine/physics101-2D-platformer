# Developement Guide Document

---

> *Refer to **GAME_DESIGN.md***

## Adding more features
1. Each feature or concept should be showcased in separate level/s as to be faithful to the *"Concept/s of the Level"*.
    > Exceptions can be made if two concepts are purposefully or realistically related and are both features of the level simulation.
2. Not all physics concepts in the list are required to be simulated.
    > Though it might be something nice to work towards in the long run.
3. If you want to start working on a level (concept/s simulation):
    - `git pull origin main` to fetch and merge with the latest version of `main` or the game.
    - `git switch -c feature/'insert-level-concept/simulation-name'` to create a new branch of main to start working on the level
    - Also consider making a documentation `.md` for that specific level or concept/simulation in the `project_DIR/docs` folder.
        > example: MAGNETIC_FORCES.md - includes all the knows and mechanics of the "Magnetic Forces" level
    - Once you feel that the level is ready to be shipped, push it to the repository with `git push origin feature/'insert-level-concept/simulation-name` and submit a pull request for main in Github.

## Testing, Quality, Improvements and Bug Fixes

### Testing and Issues
You can start testing by simply pulling `main` and testing the current state of the game. If you find bugs or spaces for possible improvements, you can create a new **Issue** in the Github repository and fill in the details (what could be improved or how to recreate the bug). The issue should be labeled accordingly using Github Labels (bug, enhancements, etc.). 

```
example: 
    # bugs
    Title: Pause menu doesn't close with `ESC`
    Labels: bug, UI
    # enhancements
    Title: Add music and sfx toggle to the pause menu
    Labels: enhancement, UI 
```
### Improvements and Bug Fixes
Obviously thoughout the whole development process, there will be changes, bug fixes and quality improvements.

To start, pull (fetch and merge) from `main` and make a new branch on your local machine/repo with `git switch -c <type>/<decription>`. Refer to the table below:

| Type | Purpose | Example |
| ---- | ------- | ------- |
| `feature/` | New functionality or major addition | `feature/chat-system` |
| `fix/` | Bug fixes | `fix/login-redirect` |
| `improvement/` or `enhancement/` | Refinements, optimizations, or better UX without changing core logic | `improvement/ui-buttons` or `enhancement/performance` |
| `refactor/` | Code or structure changes that don't alter behavior | `refactor/inventory-system` |
| `tweak/` | Very minor changes or small balancing adjustments | `tweak/player-speed` |
| `chore/` | Maintenance tasks (dependency updates, config changes, etc.) | `chore/update-dependencies` |
| `hotfix/` | Emergency fix applied directly to production | `hotfix/payment-bug` |

Once you finish the change or fix, you can push with `git push origin <type>/<description>` and make a **pull request** to merge it with main.