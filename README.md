# MiniOS

MiniOS is a small experimental desktop-like interface built with **Godot 4.6**. It combines:

- A terminal-style command input and log console.
- A file-system panel that reflects directories/files.
- A draggable and resizable desktop window widget.

The project is a lightweight sandbox for UI/window behavior and simple file operations through command-line commands.

## Features

- **Terminal command input** for basic file/folder operations.
- **Command history navigation** using `ui_up` / `ui_down` actions.
- **File manager panel** that lists folders and files from the active execution directory.
- **Native folder open** command (`cdos`) to open the save directory in your OS file explorer.
- **Desktop window controls**:
  - Drag from top bar.
  - Resize from window edges/corners.

## Project Layout

```text
MiniOS/
├── Scenes/
│   ├── os.tscn                  # Main scene (console + filesystem panel + desktop)
│   ├── window.tscn              # Reusable draggable/resizable window
│   ├── folder.tscn              # Folder row UI prefab
│   └── file.tscn                # File row UI prefab
├── Scripts/
│   ├── os.gd                    # Main app controller and UI coordination
│   ├── data_manager.gd          # Filesystem helpers and JSON save/load utilities
│   ├── file_node.gd             # File row setup
│   ├── folder_node.gd           # Folder row setup
│   ├── CommandManagement/
│   │   ├── command_manager.gd   # Command dispatcher/implementation
│   │   └── command_line_input.gd# Command history input behavior
│   └── WindowManagement/
│       ├── top_bar.gd           # Window drag behavior
│       └── window.gd            # Window resize behavior
├── UIThemes/
├── Textures/
└── project.godot
```

## Requirements

- **Godot Engine 4.6** (or compatible 4.x build).

## Running the Project

1. Open Godot.
2. Import this folder (`MiniOS/`) as a project.
3. Run the project (main scene is configured in `project.godot`).

Default window/viewport size is `1280x720`.

## Command Reference

The command parser supports the following commands:

- `help`  
  Print list of registered commands.

- `cd <path>`  
  Change execution directory.
  - Relative paths are interpreted under `user://MiniOS`.
  - Absolute paths begin with `/` and enable probing mode.

- `cdos`  
  Open `user://MiniOS` in the native OS file manager.

- `mkfile <name>`  
  Create a JSON file in the current execution directory.

- `mkdir <name>`  
  Create a directory under `user://MiniOS/<name>`.

- `dlfile <name>`  
  Delete file in the current execution directory.

- `dldir <name>`  
  Recursively delete directory in the current execution directory.

## Data and Persistence

- Main save root is: `user://MiniOS`.
- File creation uses JSON serialization helpers in `DataManager`.
- Directory listing is recursive for folders and non-recursive for files in the selected directory.

## Known Limitations / Notes

- The command history array should be initialized before first use to avoid null/append issues.
- `mkdir` currently targets `user://MiniOS` root rather than always respecting the current execution directory.
- The current file panel shows full folder paths for recursively discovered directories.

## Roadmap Ideas

- Path normalization and safer traversal boundaries.
- Better command parsing (quoted args, flags, validation).
- Richer desktop/window system (multiple windows, focus, z-order controls).
- File operations from UI interactions (click to open, rename, drag/drop).
- Automated tests for command and data manager behaviors.

## License

No license file is currently included in this repository.
