# Warcabot — a checkers-playing robot

**🇬🇧 English** · [🇵🇱 Polski](README.pl.md)

**Warcabot** is an automated cell in which a six-axis **Comau Racer 3** robot plays a full game
of checkers against a human. The player declares their moves solely through the touch-based
**mapp View** visualization, while the robot performs every physical action on the board —
moving pieces, capturing, and placing captured pieces into a buffer beside the board. A
**mapp Vision** camera continuously verifies the position of the pieces and the correctness of
each move.

The controller runs on the **B&R Automation Studio** platform using mapp technology (Motion,
Vision, View and mapp services). Legal-move generation and the machine's opponent are provided
by a dedicated **checkers engine** (C + Python) connected over **OPC UA**.

---

## Table of contents

- [Checkers engine](#checkers-engine)
- [Features](#features)
- [How it works](#how-it-works)
- [Software architecture](#software-architecture)
- [The checkers engine in depth](#the-checkers-engine-in-depth)
- [OPC UA interface](#opc-ua-interface)
- [Hardware platform](#hardware-platform)
- [Operator panel (mapp View)](#operator-panel-mapp-view)
- [Technology stack](#technology-stack)
- [Repository structure](#repository-structure)
- [Getting started](#getting-started)
- [Documentation](#documentation)
- [Project status](#project-status)
- [Authors](#authors)
- [License](#license)

---

## Checkers engine

The game logic — legal move generation, capture rules and the AI opponent — is handled by a
separate checkers engine:

**➡️ [Checkers-Engine-Warcbot](https://github.com/dashin2004/Checkers-Engine-Warcbot)**

The engine decides the machine's moves and validates the player's moves; the controller
application in this repository translates those decisions into physical robot motion and keeps
the logical board state in sync with the vision system. A copy of the engine is vendored under
`Checkers-Engine-Warcbot-main/`.

## Features

- **Autonomous gameplay** — the robot performs every move on the board on its own, including
  multi-capture jumps and clearing captured pieces into a side buffer.
- **Vision system** — a mapp Vision smart camera recognizes the color and position of the
  pieces and verifies that each robot move was executed correctly.
- **Strong AI opponent** — a bitboard engine with alpha-beta search, transposition/killer/draw
  tables, a hand-tuned evaluation, an optional neural-network evaluator and an opening book.
- **Selectable difficulty** — from a 1-ply beginner up to a 15-ply expert, plus "troll" (worst
  move) and random modes.
- **Intuitive operator panel (mapp View)** — new game, color and difficulty selection, move
  declaration, move history, statistics and alarms; multi-language and unit-system support.
- **Manual robot mode** — joint and Cartesian jog, gripper control and return-to-home.
- **Safety** — workspace/axis monitoring, E-STOP handling and resuming the game after a Safety
  reset without restarting the machine.
- **mapp services** — alarms (AlarmX), save/load game (Recipe), event logging (Audit), user
  management (UserX) and post-game reports (Report).

## How it works

A single move happens in three steps:

1. **The player selects a move** on the screen — only rules-compliant moves are highlighted
   (validated by the [checkers engine](#checkers-engine)).
2. **The camera checks the board** — it takes a photo and compares the physical pieces against
   the logical game state.
3. **The robot executes the move** — it picks up the piece, moves it to the target square, and
   places any captured pieces into the buffer beside the board.

## Software architecture

The application is modular — each function is a separate task, and data is exchanged through
global variables and interface structures (`gMotionInterface`, `gCameraCtrl`, `gRobotMoveVar`,
`gAlarm`).

| Task | Task class | Role |
|------|------------|------|
| `MotionCtrl` | Cyclic #1 | Robot state machine: power-on, homing, manual mode, move execution |
| `MainProgram` | Cyclic #4 | Main game state machine (board verification, step control, capture sequence) |
| `camera` | Cyclic #4 | Image acquisition and mapping piece positions to board squares |
| `CheckVision` | Cyclic #4 | Compares the camera board against the logical game state |
| `PositionInfo` | Cyclic #4 | Reads axis/TCP positions, workspace monitoring |
| `GameStats` | Cyclic #4 | Move detection, history, captured-piece counters, audit |
| `SaveGame` | Cyclic #4 | Save and load game state (mapp Recipe) |
| `AlarmHistory` | Cyclic #4 | Alarm history and its export (mapp AlarmX) |
| `FolderMng` | Cyclic #4 | Verifies and creates the directory structure on the USER drive |
| `VisVariable` | Cyclic #4 | Variables bound to the visualization |

Robot motion sequences are written in **Structured Text (ST Motion)** — `move.st` (piece
transfer with a safe vertical approach and magnetic gripper) and `gohome.st` (return to the
start joint position). Board squares and buffer slots are addressed through the lookup tables
`COORD_POSITION[x, y]` and `BUFOR_POSITION[color, slot]`.

## The checkers engine in depth

The engine has two layers: a high-performance **C core** compiled to a Python extension
(`search_engine`) and a **Python control layer** that manages the game and the OPC UA link.

- **Bitboard representation** — the board is stored as four 64-bit integers (`p1`, `p2`, `p1k`,
  `p2k`) for men and kings of each side, enabling fast move/jump generation via bit operations.
- **Search** — `negamax` with alpha-beta pruning (`board_search.c`), accelerated by a Zobrist
  **transposition table** (`hash_table.c`), a **killer-move table** (`killer_table.c`), a
  **draw table** (`draw_table.c`) and move ordering. Bounded by both depth and a time budget.
- **Evaluation** (`board_eval.c`) — material (man = 50, king = 70), positional tables,
  distance-to-promotion, a material-advantage bonus, tail-pin detection and bitmask-recognized
  strategic patterns (Right Lock, Triangle, Oreo, Bridge, Dog, king-in-corner penalty).
- **Neural network** (`neural_net.c`) — an optional evaluator taking a 128-neuron encoding of
  the board (32 squares × piece-type planes) with ReLU/tanh layers; includes training routines.
- **Opening book** (`opening_book.c`, `book_moves.txt`) — built from a large PDN game collection
  (`CheckersGames.pdn`), storing win/loss/draw outcomes per position.

**Difficulty levels** (`gDifficultyLevel`):

| Level | Value | Behavior |
|-------|-------|----------|
| Easy | `0` | Search depth 1 |
| Medium | `1` | Search depth 5 |
| Hard | `2` | Search depth 15 (~2 s time budget) |
| Troll (worst move) | `3` | Deliberately picks the lowest-evaluated move |
| Random | `4` | Random legal move (still respecting forced captures) |

The Python driver (`PlcCheckers.py`) runs a game state machine — `WAITING_FOR_START`,
`HUMAN_SELECT_PIECE`, `HUMAN_SELECT_MOVE`, `BOT_TURN`, `ESTOP`, `GAME_OVER` — generating legal
move highlights for the player and waiting for camera confirmation after each physical move.

## OPC UA interface

The engine connects to the controller as an OPC UA client over a persistent, TLS-secured
channel (client certificate `client_cert.der` / `client_key.pem`). Default endpoint
`opc.tcp://192.168.0.11:4842`, account `Admin`/`Admin`. Selected nodes:

| Variable | Node ID | Meaning |
|----------|---------|---------|
| `gStart` | `::AsGlobalPV:gStart` | Start game / load saved state |
| `gPlayerColor` | `::AsGlobalPV:gPlayerColor` | Human color (TRUE = human starts) |
| `gDifficultyLevel` | `::AsGlobalPV:gDifficultyLevel` | Difficulty 0–4 |
| `gBoardActual` | `::AsGlobalPV:gBoardActual` | Logical 8×8 board |
| `gEnablePiece` / `gEnableMove` | `::AsGlobalPV:…` | Legal-piece / legal-move highlights |
| `gPickPiece` / `gPickMove` | `::AsGlobalPV:…` | Player piece / target selection |
| `GESTOP` | `::AsGlobalPV:GESTOP` | Emergency stop |
| `BoardGit` | `::MainProgra:BoardGit` | Camera board matches logical state |
| `RobotMoveMarker` | `::MainProgra:RobotMoveMarker` | Trigger physical robot move |
| `WinOrLose` / `EndGame` | `::GameStats:…` | Result / end of game |

> After a controller restart the OPC UA session expires — restart `PlcCheckers.py` to
> re-establish the secure channel.

## Hardware platform

| Module | Type | Function |
|--------|------|----------|
| Panel PC / PLC | `5APC3100.KBU1-000` | Central unit, ARemb runtime, visualization & OPC UA server |
| 6-axis robot | Comau Racer 3 | Physical piece handling (magnetic gripper) |
| mapp Vision camera | `VSS112Q22.042P-000` | Piece recognition and move verification |
| POWERLINK interface | `5AC901.IPLK-00` | Communication with the drives |
| X20 bus controller | `X20BC0083` | POWERLINK I/O station |
| X20 I/O | `X20DI9371`, `X20DO9322`, `X20PS9400`, `X20BB80`, `X20BM11`, `X20TB12` | Digital I/O (Safety, magnetic gripper), power, terminals |
| Drives | `8EI8X8MWT10.xxxx-1` | ACOPOS drives for the robot axes |

## Operator panel (mapp View)

The visualization is the sole human–machine interface. Screens: **Main** (project overview),
**Play** (interactive 8×8 board, statistics, new/load/save game), **Alarm** (active list &
history), **Manual** (Cartesian/joint jog, positions, homing) and **Settings**. Manual and
Settings are protected by login (mapp UserX). Screenshots are included in the technical documentation.

## Technology stack

- **Automation Studio** 6.7.0
- **mappMotion** 6.7.2 (XT) · **mappView** 6.7.0 · **mappVision** 6.7.0 · **mappServices** 6.7.1
- **OPC UA** (OpcUaCs) 6.7.0
- Automation Runtime embedded (ARemb)
- Checkers engine: C (GCC) + Python — [Checkers-Engine-Warcbot](https://github.com/dashin2004/Checkers-Engine-Warcbot)

## Repository structure

```
Warcbot/
├── Logical/                        # Logical layer (programs, types, libraries, mapp View)
│   ├── Programs/                   # ST tasks: MainProgram, camera, CheckVision, Motion, ...
│   ├── Libraries/                  # mapp and system libraries
│   ├── mappView/                   # Visualization resources (media, texts, themes)
│   ├── Global.typ / .var           # Global types and variables
├── Physical/                       # Hardware configuration (HW, networks, mappMotion/Vision)
├── Robot-programy/                 # ST Motion programs (move.st, gohome.st, moveAB.st)
├── SceneViewer/                    # Simulation model of the cell (Scene Viewer)
├── Checkers-Engine-Warcbot-main/   # Checkers engine (C core + Python, OPC UA)
├── Documentation/                  # Technical documentation (PL + EN, PDF)
├── warcabot.apj                    # Automation Studio project file
└── LICENSE                         # GNU GPL v3
```

## Getting started

1. Install **Automation Studio 6.7** with the mapp packages (Motion 6.7 XT, View, Vision, Services).
2. Open the project file `warcabot.apj`.
3. Build the configuration and transfer the software to the controller (or run it in simulation).
4. Before testing on the physical robot, verify the motions on the model in **Scene Viewer**.
5. Open the mapp View visualization in a browser at the controller's address (`192.168.0.11`).
6. Build and run the checkers engine and connect it as the game-logic provider:

   ```bash
   git clone https://github.com/dashin2004/Checkers-Engine-Warcbot.git
   cd Checkers-Engine-Warcbot
   python3 -m venv .venv && source .venv/bin/activate
   pip install -r requirements.txt
   ./build.sh                       # compile the C core -> search_engine.so
   cd src/python && python3 PlcCheckers.py
   ```

> Note: after a power cycle the robot must be homed (Restore Position or service homing by
> markers) — see the technical documentation.

## Documentation

Full technical description of the system — architecture, every ST task, the checkers engine,
OPC UA, vision, HMI, hardware, safety and startup — is available in two languages:

- 🇬🇧 [`Documentation/Warcabot_Technical_Documentation.pdf`](Documentation/Warcabot_Technical_Documentation.pdf) — English
- 🇵🇱 [`Documentation/Warcabot_Dokumentacja_Techniczna.pdf`](Documentation/Warcabot_Dokumentacja_Techniczna.pdf) — Polish

## Project status

Work in progress. Items planned for completion: integration of the game logic with robot motion
in the `GameMove`/`RobotMove` states, activation of the magnetic gripper in `move.st`, post-game
reports (mapp Report), and cybersecurity extensions.

## Authors

Bartosz Zawłocki · Andrzej Działak · Mateusz Skrzypiński · Szymon Markowski · Adam Witczak · Piotr Piechocki

## License

Released under the **GNU GPL v3** license — see the [LICENSE](LICENSE) file for details.
