# Terminal, Command Prompt & PowerShell Command Reference

A quick reference for the most common commands used to navigate the file system and to create, move, and copy files and folders.

- **Terminal (macOS / Linux)** — Bash / Zsh shells.
- **Command Prompt (Windows)** — the classic `cmd.exe` shell.
- **PowerShell (Windows)** — the default modern Windows shell. It also accepts many classic `cmd.exe` and Unix-style commands as aliases.

---

## 1. Navigating the File System

| Task | Terminal (macOS / Linux) | Command Prompt (cmd.exe) | PowerShell (Windows) |
|------|--------------------------|--------------------------|----------------------|
| Show current directory (path) | `pwd` | `cd` | `pwd` or `Get-Location` |
| List files & folders | `ls` | `dir` | `ls`, `dir`, or `Get-ChildItem` |
| List all (incl. hidden) | `ls -a` | `dir /a` | `ls -Force` |
| List with details | `ls -l` | `dir` | `ls` or `Get-ChildItem` |
| Change directory | `cd folder_name` | `cd folder_name` | `cd folder_name` |
| Go up one level | `cd ..` | `cd ..` | `cd ..` |
| Go to home directory | `cd ~` or `cd` | `cd %USERPROFILE%` | `cd ~` |
| Go to previous directory | `cd -` | *(not available)* | `cd -` |
| Change drive (e.g. to D:) | *(N/A)* | `D:` | `D:` |
| Clear the screen | `clear` | `cls` | `clear` or `cls` |

---

## 2. Creating Files & Folders

| Task | Terminal (macOS / Linux) | Command Prompt (cmd.exe) | PowerShell (Windows) |
|------|--------------------------|--------------------------|----------------------|
| Create a new folder | `mkdir folder_name` | `mkdir folder_name` or `md folder_name` | `mkdir folder_name` or `New-Item folder_name -ItemType Directory` |
| Create nested folders | `mkdir -p a/b/c` | `mkdir a\b\c` | `New-Item a/b/c -ItemType Directory -Force` |
| Create an empty file | `touch file.txt` | `type nul > file.txt` | `New-Item file.txt` or `ni file.txt` |
| Write text into a file | `echo "hello" > file.txt` | `echo hello > file.txt` | `echo "hello" > file.txt` or `Set-Content file.txt "hello"` |
| Append text to a file | `echo "more" >> file.txt` | `echo more >> file.txt` | `echo "more" >> file.txt` or `Add-Content file.txt "more"` |

---

## 3. Moving & Renaming

| Task | Terminal (macOS / Linux) | Command Prompt (cmd.exe) | PowerShell (Windows) |
|------|--------------------------|--------------------------|----------------------|
| Move a file/folder | `mv source dest` | `move source dest` | `mv source dest` or `Move-Item source dest` |
| Rename a file/folder | `mv old_name new_name` | `ren old_name new_name` | `mv old_name new_name` or `Rename-Item old_name new_name` |

---

## 4. Copying Files & Folders

| Task | Terminal (macOS / Linux) | Command Prompt (cmd.exe) | PowerShell (Windows) |
|------|--------------------------|--------------------------|----------------------|
| Copy a file | `cp file.txt copy.txt` | `copy file.txt copy.txt` | `cp file.txt copy.txt` or `Copy-Item file.txt copy.txt` |
| Copy a folder (recursive) | `cp -r src_folder dest_folder` | `xcopy src_folder dest_folder /E /I` | `cp src_folder dest_folder -Recurse` or `Copy-Item src_folder dest_folder -Recurse` |

---

## 5. Deleting Files & Folders

> ⚠️ **Warning:** deletion from the terminal / command line is permanent — files are **not** sent to the Trash / Recycle Bin.

| Task | Terminal (macOS / Linux) | Command Prompt (cmd.exe) | PowerShell (Windows) |
|------|--------------------------|--------------------------|----------------------|
| Delete a file | `rm file.txt` | `del file.txt` | `rm file.txt` or `Remove-Item file.txt` |
| Delete an empty folder | `rmdir folder_name` | `rmdir folder_name` | `rmdir folder_name` |
| Delete a folder + contents | `rm -r folder_name` | `rmdir /s folder_name` | `rm folder_name -Recurse` or `Remove-Item folder_name -Recurse` |
| Force delete (no prompt) | `rm -rf folder_name` | `rmdir /s /q folder_name` | `Remove-Item folder_name -Recurse -Force` |

---

## 6. Viewing File Contents

| Task | Terminal (macOS / Linux) | Command Prompt (cmd.exe) | PowerShell (Windows) |
|------|--------------------------|--------------------------|----------------------|
| Print whole file | `cat file.txt` | `type file.txt` | `cat file.txt` or `Get-Content file.txt` |
| Print first lines | `head file.txt` | *(not built-in)* | `Get-Content file.txt -Head 10` |
| Print last lines | `tail file.txt` | *(not built-in)* | `Get-Content file.txt -Tail 10` |

---

## Quick Tips

- Use **Tab** to auto-complete file and folder names.
- Use the **↑ / ↓ arrow keys** to cycle through previously typed commands.
- Wrap paths that contain spaces in quotes: `cd "My Folder"`.
- Use `.` to mean "the current folder" and `..` to mean "one folder up".
- Windows uses back-slashes `\` in paths (`a\b\c`), while macOS / Linux use forward-slashes `/` (`a/b/c`). PowerShell accepts both.
