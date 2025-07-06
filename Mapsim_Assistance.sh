#!/bin/bash

# 🎨 Colors
GREEN='\033[92m'
RED='\033[91m'
CYAN='\033[96m'
YELLOW='\033[93m'
MAGENTA='\033[95m'
NC='\033[0m'

width=81
export LC_ALL=C.UTF-8

# تابع نصب وابستگی‌ها
install_dependencies() {
    echo -e "${CYAN}[ℹ] Checking and installing required packages Mapsim Assistance ...${NC}"
    apt-get update -y         
}

# ┌ Logo
show_logo() {
    clear
    echo -e "${MAGENTA}"
    echo "       ▄▄▄▄███▄▄▄▄      ▄████████    ▄███████▄    ▄████████  ▄█    ▄▄▄▄███▄▄▄▄         "
    echo "      ▄██▀▀▀███▀▀▀██▄   ███    ███   ███    ███   ███    ███ ███  ▄██▀▀▀███▀▀▀██▄      "
    echo "      ███   ███   ███   ███    ███   ███    ███   ███    █▀  ███▌ ███   ███   ███      "
    echo "      ███   ███   ███   ███    ███   ███    ███   ███        ███▌ ███   ███   ███      "
    echo "      ███   ███   ███ ▀███████████ ▀█████████▀  ▀███████████ ███▌ ███   ███   ███      "
    echo "      ███   ███   ███   ███    ███   ███                 ███ ███  ███   ███   ███      "
    echo "      ███   ███   ███   ███    ███   ███           ▄█    ███ ███  ███   ███   ███      "
    echo "       ▀█   ███   █▀    ███    █▀   ▄████▀       ▄████████▀  █▀    ▀█   ███   █▀       "
    echo "                                                                                       "
    echo "                                 A S S I S T A N C E                                   "
    echo -e "${NC}"
}

show_main_menu() {
    echo -e "\n${CYAN}Mapsim Assistance - Main Menu${NC}"
    echo -e "\n"
    echo -e "${GREEN}1) X-ui Panel${NC}"
    echo -e "${RED}0) Exit${NC}"
    echo -e "\n"
    echo -ne "${CYAN}Your choice: ${NC}"
}

show_xui_panel_menu() {
    echo -e "\n${CYAN}X-ui Panel - Menu${NC}"
    echo -e "\n"
    echo -e "${GREEN}1) Setup Auto-Restart for x-ui${NC}"
    echo -e "${YELLOW}2) Manage Auto-Restart Schedule${NC}"
    echo -e "${RED}0) Back to Main Menu${NC}"
    echo -e "\n"
    echo -ne "${CYAN}Your choice: ${NC}"
}

setup_auto_restart() {
    XUI_PATH=$(command -v x-ui)
    if [ -z "$XUI_PATH" ]; then
        echo -e "${RED}[!] Error: 'x-ui' not found in PATH.${NC}"
        return
    fi

    echo -e "\n${CYAN}Choose your restart interval:${NC}"
    echo "1. Every X hours"
    echo "2. Every X minutes"
    read -p "Select option (1 or 2): " mode

    if [ "$mode" == "1" ]; then
        read -p "Restart every how many hours? (e.g., 4): " interval
        CRON_EXPR="0 */$interval * * *"
        UNIT="hour(s)"
    elif [ "$mode" == "2" ]; then
        read -p "Restart every how many minutes? (e.g., 30): " interval
        CRON_EXPR="*/$interval * * * *"
        UNIT="minute(s)"
    else
        echo -e "${RED}[!] Invalid option.${NC}"
        return
    fi

    if ! [[ "$interval" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}[!] Invalid input. Numbers only.${NC}"
        return
    fi

    CRON_LINE="$CRON_EXPR $XUI_PATH restart >> /var/log/xui_cron.log 2>&1"
    (crontab -l 2>/dev/null | grep -v 'x-ui restart'; echo "$CRON_LINE") | crontab -

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✔] Auto-restart configured successfully. Every $interval $UNIT.${NC}"
        echo -e "${CYAN}[ℹ] Logs will be saved to: /var/log/xui_cron.log${NC}"
        echo -e "${CYAN}Running a test restart and checking service status...${NC}"
        sleep 1
        $XUI_PATH restart >> /var/log/xui_cron.log 2>&1
        sleep 1
        systemctl is-active --quiet x-ui
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[✔] x-ui restarted and is running successfully.${NC}"
        else
            echo -e "${RED}[✖] x-ui restart failed or service is not active!${NC}"
        fi
    else
        echo -e "${RED}[✖] Failed to configure cron job.${NC}"
    fi
}

manage_auto_restart_menu() {
    CRON_JOB=$(crontab -l 2>/dev/null | grep 'x-ui restart')
    if [ -z "$CRON_JOB" ]; then
        echo -e "${RED}[✖] No auto-restart job found for x-ui in crontab.${NC}"
        return
    fi

    echo -e "\n${CYAN}🌀 Current Auto-Restart Job:${NC}"
    echo -e "${GREEN}$CRON_JOB${NC}"

    echo -e "\n${CYAN}📋 Choose an option:${NC}"
    echo -e "\n"
    echo -e "${GREEN} 1) Change the restart schedule${NC}"
    echo -e "${YELLOW} 2) Keep current schedule${NC}"
    echo -e "${CYAN} 3) View Auto-Restart Log${NC}"
    echo -e "${RED} 4) Remove auto-restart job${NC}"
    echo -e "${MAGENTA} 0) Back to X-ui Panel Menu${NC}"
    echo -e "\n"
    echo -ne "${CYAN}Your choice: ${NC}"
    read action

    case $action in
        1)
            echo -e "\n${CYAN}⏱️ Choose time mode:${NC}"
            echo -e "${GREEN} 1) Restart every X hours${NC}"
            echo -e "${YELLOW} 2) Restart every X minutes${NC}"
            echo -ne "${CYAN}Select mode (1 or 2): ${NC}"
            read mode

            if [ "$mode" == "1" ]; then
                read -p "Enter hours interval (e.g., 6): " interval
                CRON_EXPR="0 */$interval * * *"
                UNIT="hour(s)"
            elif [ "$mode" == "2" ]; then
                read -p "Enter minutes interval (e.g., 30): " interval
                CRON_EXPR="*/$interval * * * *"
                UNIT="minute(s)"
            else
                echo -e "${RED}[!] Invalid mode selection.${NC}"
                return
            fi

            if ! [[ "$interval" =~ ^[0-9]+$ ]]; then
                echo -e "${RED}[!] Invalid input. Only numeric values allowed.${NC}"
                return
            fi

            XUI_PATH=$(command -v x-ui)
            NEW_LINE="$CRON_EXPR $XUI_PATH restart >> /var/log/xui_cron.log 2>&1"
            (crontab -l 2>/dev/null | grep -v 'x-ui restart'; echo "$NEW_LINE") | crontab -

            echo -e "${GREEN}[✔] Updated successfully: Every $interval $UNIT${NC}"
            echo -e "${CYAN}[ℹ] Logs will be saved to: /var/log/xui_cron.log${NC}"
            echo -e "${CYAN}Testing restart...${NC}"
            sleep 1
            $XUI_PATH restart >> /var/log/xui_cron.log 2>&1
            sleep 1
            if systemctl is-active --quiet x-ui; then
                echo -e "${GREEN}[✔] x-ui restarted and running correctly.${NC}"
            else
                echo -e "${RED}[✖] Restart failed or service is not active.${NC}"
            fi
            ;;
        2)
            echo -e "${YELLOW}[ℹ] Keeping current schedule. No changes made.${NC}" ;;
        3)
            view_xui_cron_log ;;
        4)
            (crontab -l 2>/dev/null | grep -v 'x-ui restart') | crontab -
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}[✔] Auto-restart job removed successfully.${NC}"
            else
                echo -e "${RED}[✖] Failed to remove auto-restart job.${NC}"
            fi
            ;;
        0)
            echo -e "${MAGENTA}[↩] Returning to X-ui Panel Menu...${NC}" ;;
        *)
            echo -e "${RED}[!] Invalid option. Please try again.${NC}" ;;
    esac
}


view_xui_cron_log() {
    LOG_FILE="/var/log/xui_cron.log"

    echo -e "\n${CYAN}📄 Viewing x-ui auto-restart log:${NC}"
    if [ -f "$LOG_FILE" ]; then
        echo -e "${YELLOW}----------------------------------------${NC}"
        tail -n 30 "$LOG_FILE"
        echo -e "${YELLOW}----------------------------------------${NC}"
    else
        echo -e "${RED}[✖] Log file not found: $LOG_FILE${NC}"
    fi
}

main() {
    while true; do
        show_logo
        show_main_menu
        read -r choice
        case $choice in
            1)
                while true; do
                    show_logo
                    show_xui_panel_menu
                    read -r xui_choice
                    case $xui_choice in
                        1) setup_auto_restart ;;
                        2) manage_auto_restart_menu ;;
                        0) break ;;  # back to main menu
                        *) echo -e "${RED}Invalid option! Please try again.${NC}"; sleep 1 ;;
                    esac
                    echo -e "${CYAN}Press Enter to continue...${NC}"
                    read -r
                done
                ;;
            0)
                echo -e "${CYAN}Exiting...${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option! Please try again.${NC}"
                sleep 1
                ;;
        esac
    done
}

install_dependencies
main
