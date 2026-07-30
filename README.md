# Warcabot – a checkers-playing robot

Warcabot is an automated cell in which a six-axis **Comau Racer 3** robot plays a full game
of checkers against a human. The player declares their moves solely through the touch-based
**mapp View** visualization, while the robot performs every physical action on the board –
including captures and placing captured pieces into a buffer beside the board. A vision
system continuously verifies the position of the pieces.

The project runs on the **B&R Automation Studio** platform using mapp technology
(Motion, Vision, View and mapp services). Move legality and the machine's opponent moves are
provided by a dedicated checkers engine.

---

## Table of contents

- [Checkers engine](#checkers-engine)
- [Features](#features)
- [How it works](#how-it-works)
- [Software architecture](#software-architecture)
- [Hardware platform](#hardware-platform)
- [Technology stack](#technology-stack)
- [Repository structure](#repository-structure)
- [Getting started](#getting-started)
- [Documentation](#documentation)
- [Project status](#project-status)
- [License](#license)

---

## Checkers engine

The game logic – legal move generation, capture rules and the AI opponent – is handled by a
separate checkers engine:

**➡️ [Checkers-Engine-Warcbot](https://github.com/dashin2004/Checkers-Engine-Warcbot)**

The engine decides the machine's moves and validates the player's moves; the controller
application in this repository translates those decisions into physical robot motion and
keeps the logical board state in sync with the vision system.

## Features

- **Autonomous gameplay** – the robot performs every move on the board on its own.
- **Vision system** – the camera recognizes the color and position of the pieces and
  verifies that each robot move was executed correctly.
- **Intuitive operator panel (mapp View)** – new game, color and difficulty selection,
  move declaration, move history, alarms; multi-language and unit-system support.
- **Manual robot mode** – axis control (joint and Cartesian jog) and return to home position.
- **Safety** – workspace/safespace monitoring, E-STOP handling, and resuming the game after a
  Safety reset without restarting the machine.
- **mapp services** – alarms (AlarmX), save/load game (Recipe), event logging (Audit),
  user management (UserX).

## How it works

A single move happens in three steps:

1. **The player selects a move** on the screen – only rules-compliant moves are allowed
   (validated by the [checkers engine](#checkers-engine)).
2. **The camera checks** the board – it takes a photo and compares the pieces against the
   logical game state.
3. **The robot executes the move** – it picks up the piece, moves it to the new square, and
   places captured pieces into the buffer beside the board.

## Software architecture

The application is modular – each function is a separate task, and data is exchanged through
global variables and interface structures (`gMotionInterface`, `gCameraCtrl`).

| Task | Task class | Role |
|------|------------|------|
| `MotionCtrl` | Cyclic #1 | Robot state machine: homing, manual mode, move execution |
| `MainProgram` | Cyclic #4 | Main game state machine (board verification, step control) |
| `camera` | Cyclic #4 | Image acquisition and mapping piece positions to board squares |
| `CheckVision` | Cyclic #4 | Compares the camera board against the logical game state |
| `PositionInfo` | Cyclic #4 | Reads axis/TCP positions, workspace monitoring |
| `GameStats` | Cyclic #4 | Move detection, history, captured-piece counters, audit |
| `SaveGame` | Cyclic #4 | Save and load game state (mapp Recipe) |
| `AlarmHistory` | Cyclic #4 | Alarm history and its export (mapp AlarmX) |
| `FolderMng` | Cyclic #4 | Verifies and creates the directory structure on the USER drive |
| `VisVariable` | Cyclic #4 | Variables bound to the visualization |

Robot motion sequences are written in **Structured Text (ST Motion)** – `move.st`
(piece transfer with a safe vertical approach) and `gohome.st` (return to the start position).

## Hardware platform

| Module | Type | Function |
|--------|------|----------|
| 5APC3100.KBU1-000 | Panel PC / PLC | Central unit, ARemb runtime, visualization server |
| Comau Racer 3 | 6-axis robot | Physical piece handling |
| VSS112Q22.042P-000 | mappVision camera | Piece recognition |
| 5AC901.IPLK-00 | POWERLINK interface | Communication with the drives |
| X20 (BC0083, DI9371, DO9322, PS9400, …) | I/O modules | Digital signals (Safety, magnetic gripper) |

## Technology stack

- **Automation Studio** 6.7.0
- **mappMotion** 6.7.2 (XT) · **mappView** 6.7.0 · **mappVision** 6.7.0 · **mappServices** 6.7.1
- **OPC UA** (OpcUaCs) 6.7.0
- Automation Runtime embedded (ARemb)
- Checkers engine: [Checkers-Engine-Warcbot](https://github.com/dashin2004/Checkers-Engine-Warcbot)

## Repository structure

```
Warcbot/
├── Logical/                 # Logical layer (programs, types, libraries, mapp View)
│   ├── Programs/            # ST tasks: MainProgram, camera, CheckVision, Motion, GameStats, SaveGame, ...
│   ├── Libraries/           # mapp and system libraries
│   ├── mappView/            # Visualization resources (media, texts, themes)
│   ├── Global.typ / .var    # Global types and variables
├── Physical/                # Hardware configuration (HW, networks, mappMotion, mappVision, roles)
├── Robot-programy/          # ST Motion programs (move.st, gohome.st)
├── SceneViewer/             # Simulation model of the cell (Scene Viewer)
├── warcabot.apj             # Automation Studio project file
└── LICENSE
```

## Getting started

1. Install **Automation Studio 6.7** with the mapp packages (Motion 6.7 XT, View, Vision, Services).
2. Open the project file `warcabot.apj`.
3. Build the configuration and transfer the software to the controller (or run it in simulation).
4. Before testing on the physical robot, verify the motions on the model in **Scene Viewer**.
5. The mapp View visualization is available in a browser at the controller's address.
6. Build/run the [checkers engine](https://github.com/dashin2004/Checkers-Engine-Warcbot) and connect it as the game logic provider.

> Note: after a power cycle the robot must be homed (Restore Position or service homing by
> markers) – see the technical documentation.

## Documentation

- `Warcabot_Dokumentacja_Techniczna.docx` – full technical description of the software.
- `Warcabot_Prezentacja.pptx` – general project presentation.

## Project status

Work in progress. Items planned for completion: integration of the game logic with robot
motion in the `GameMove`/`RobotMove` states, activation of the magnetic gripper in `move.st`,
post-game reports (mapp Report), and cybersecurity extensions.

## License

Released under the **GNU GPL v3** license – see the [LICENSE](LICENSE) file for details.
