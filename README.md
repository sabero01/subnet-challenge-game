# Subnetting Challenge Game 

A lightweight, terminal-based Bash script designed to help network engineers and students master IPv4 subnetting through gamification.

## Purpose
I created this project to move away from boring static tables and learn **IP Subnetting** in a fun, interactive way. By practicing Network Address, First Usable IP, and Broadcast Address calculations against the clock, I can build the mental muscle memory needed for exams like the CCNA.

## How to Play
1. **Make the script executable:**
   ```bash
   chmod +x subnet_game.sh
   ```
2. **Launch the game:**
   ```bash
   ./subnet_game.sh
   ```

## Game Mechanics
- **Health System:** You start with 3 hearts (❤️). A wrong answer costs you a life!
- **Randomized Challenges:** The game generates random Class A, B, and C addresses with CIDR masks ranging from `/8` to `/30`.
- **Score Tracking:** Keeps track of your consecutive correct answers.
- **Instant Feedback:** If you get it wrong, the game shows you the correct answer immediately so you can learn from the mistake.

## Technical Highlights
The game is built using pure **Bash bitwise arithmetic**:
- Converts dotted-decimal IPs into 32-bit integers.
- Uses bitwise `AND` with CIDR masks to find the **Network Address**.
- Uses bitwise `OR` with inverted masks (wildcards) to find the **Broadcast Address**.
- No external heavy dependencies—just standard Linux tools.

## Requirements
- Any Linux/Unix terminal with `bash`.
- ANSI color support (standard in almost all modern terminals).

---
*Happy Subnetting!*
