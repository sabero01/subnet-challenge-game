#!/bin/bash

# ==============================================================================
# Subnetting Challenge Game
# A terminal-based game to practice IPv4 subnetting.
# ==============================================================================

# --- Colors and UI Elements ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'
HEART="❤️"

# --- Game State ---
hearts=3
score=0

# --- Helper Functions ---

# Convert an IP address (a.b.c.d) to a 32-bit integer
ip_to_int() {
    local ip=$1
    local a b c d
    IFS=. read -r a b c d <<< "$ip"
    echo "$(( (a << 24) + (b << 16) + (c << 8) + d ))"
}

# Convert a 32-bit integer back to an IP address (a.b.c.d)
int_to_ip() {
    local int=$1
    local a=$(( (int >> 24) & 255 ))
    local b=$(( (int >> 16) & 255 ))
    local c=$(( (int >> 8) & 255 ))
    local d=$(( int & 255 ))
    echo "$a.$b.$c.$d"
}

# Generate a random valid IP address for Class A, B, or C
generate_random_ip() {
    local class_type=$(( RANDOM % 3 ))
    case $class_type in
        0) # Class A: 1-126
            echo "$(( RANDOM % 126 + 1 )).$(( RANDOM % 256 )).$(( RANDOM % 256 )).$(( RANDOM % 256 ))"
            ;;
        1) # Class B: 128-191
            echo "$(( RANDOM % 64 + 128 )).$(( RANDOM % 256 )).$(( RANDOM % 256 )).$(( RANDOM % 256 ))"
            ;;
        2) # Class C: 192-223
            echo "$(( RANDOM % 32 + 192 )).$(( RANDOM % 256 )).$(( RANDOM % 256 )).$(( RANDOM % 256 ))"
            ;;
    esac
}

# --- Main Game Loop ---
clear
echo -e "${CYAN}==========================================${RESET}"
echo -e "${YELLOW}      WELCOME TO THE SUBNETTING GAME      ${RESET}"
echo -e "${CYAN}==========================================${RESET}"
echo -e "Identify the Network, First Usable, or Broadcast address."
echo -e "Press Ctrl+C or type 'quit' to exit.\n"

while [ $hearts -gt 0 ]; do
    # 1. Generate Challenge
    ip=$(generate_random_ip)
    cidr=$(( RANDOM % 23 + 8 )) # CIDR between /8 and /30
    
    # 2. Calculate Subnet Math
    # Math Explanation:
    # - Mask: We shift all 1s to the left by (32 - CIDR) bits.
    # - Network: IP bitwise AND Mask.
    # - Wildcard: Bitwise NOT of Mask (inverted).
    # - Broadcast: Network bitwise OR Wildcard.
    
    ip_int=$(ip_to_int "$ip")
    mask_int=$(( (0xFFFFFFFF << (32 - cidr)) & 0xFFFFFFFF ))
    net_int=$(( ip_int & mask_int ))
    wildcard_int=$(( mask_int ^ 0xFFFFFFFF ))
    broad_int=$(( net_int | wildcard_int ))
    first_int=$(( net_int + 1 ))

    network_addr=$(int_to_ip "$net_int")
    broadcast_addr=$(int_to_ip "$broad_int")
    first_usable=$(int_to_ip "$first_int")

    # 3. Pick a Question Type
    q_type=$(( RANDOM % 3 ))
    case $q_type in
        0) question="Network Address"; correct_ans="$network_addr" ;;
        1) question="First Usable IP"; correct_ans="$first_usable" ;;
        2) question="Broadcast Address"; correct_ans="$broadcast_addr" ;;
    esac

    # 4. Display Challenge
    echo -e "${BLUE}------------------------------------------${RESET}"
    echo -e "Score: ${GREEN}$score${RESET} | Health: $(for i in $(seq 1 $hearts); do echo -n "$HEART "; done)"
    echo -e "Target: ${YELLOW}$ip/$cidr${RESET}"
    echo -en "What is the ${CYAN}$question${RESET}? "
    read -r user_ans

    if [[ "$user_ans" == "quit" ]]; then
        break
    fi

    # 5. Validate Answer
    if [[ "$user_ans" == "$correct_ans" ]]; then
        score=$(( score + 1 ))
        echo -e "${GREEN}Correct! Excellent work.${RESET}\n"
    else
        hearts=$(( hearts - 1 ))
        echo -e "${RED}Wrong!${RESET}"
        echo -e "The correct $question was: ${GREEN}$correct_ans${RESET}"
        if [ $hearts -gt 0 ]; then
            echo -e "Remaining Health: $(for i in $(seq 1 $hearts); do echo -n "$HEART "; done)\n"
        fi
    fi
done

# --- Game Over ---
echo -e "\n${RED}==========================================${RESET}"
echo -e "               GAME OVER                  "
echo -e "${RED}==========================================${RESET}"
echo -e "Final Score: ${GREEN}$score${RESET}"
echo -e "Better luck next time, Admin!\n"
