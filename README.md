A custom DOS-style command-line interface built in 8086 Assembly for a COAL university project.
# Custom DOS Command Line

## About the Project

Custom DOS Command Line is a DOS-style command-line interface developed in 8086 Assembly Language as a Computer Organization and Assembly Language (COAL) university project.

It provides a command prompt where users can enter commands to perform different operations. The project demonstrates low-level programming, command parsing, string handling, display formatting, and DOS interrupt usage.

## Features

- Custom command-line interface with a DOS-style prompt
- Colored text and screen formatting
- Command matching and input processing
- Greeting and help commands
- Date and time display
- Text echo, uppercase, lowercase, repeat, and length operations
- Mock directory listing and directory tree display
- Ping-style output with a delay loop
- Version and project information
- System information display
- Exit and shutdown commands

## Commands

| Command | Function |
|---|---|
| `HELP` | Display available commands |
| `HELLO` | Display a greeting |
| `CLEAR` / `CLS` | Clear the screen |
| `DATE` | Display the system date |
| `TIME` | Display the system time |
| `VERSION` | Display version information |
| `ABOUT` | Show project information |
| `ECHO` | Print the supplied text |
| `DIR` | Display a mock directory listing |
| `PING` | Display ping-style replies |
| `UPPER` | Convert text to uppercase |
| `LOWER` | Convert text to lowercase |
| `REPEAT` | Print the supplied text twice |
| `LENGTH` | Count characters in the supplied text |
| `TREE` | Display a directory tree |
| `SYSINFO` | Display system and project information |
| `REBOOT` | Execute the reset-vector routine |
| `SHUTDOWN` | Display the shutdown message |
| `EXIT` | Exit the program |

## Technologies Used

- 8086 Assembly Language
- DOS interrupts (`INT 21h`)
- BIOS video interrupts (`INT 10h`)
- DOSBox or a compatible DOS emulator

## Learning Outcomes

This project provided practical experience with assembly instructions, registers, memory addressing, string processing, conditional jumps, loops, procedures, and interrupt-based input and output.

## Project Status

Developed as a university COAL project.

## Author

Computer Science Student | Exploring Low-Level Programming and Computer Systems

