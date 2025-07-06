# 📦 Mapsim_Assistance
_Assistance For You ..._

---

## 🧰 Features

- Easy-to-use interactive menu
- Automatic restart setup for `x-ui` panel
- Manage crontab jobs visually
- View restart logs
- Beautiful CLI logo interface
- One-line automatic installation

---

## 💻 Requirements

- OS: Debian or Ubuntu
- Recommended: `Ubuntu 22.04 LTS`
- Must be run as **root**

---

## Logo Script

![Logo Script](https://github.com/MAPSIM-co/Mapsim_Assistance/blob/main/Logo/Mapsim_Assistance_logo.png?raw=true)


---

## 🚀 Installation and Usage

### 1. Automatic Install

> One-liner install via curl:

```bash
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/MAPSIM-co/Mapsim_Assistance/main/Auto_installing_Mapsim_Assistance.sh)"
```

### This will:

- Install dependencies
- Download the latest version of the script
- Set it up as a global command mapsim_assistance
- Create and enable the systemd service

---

## 2. Manual Method


### 1. Clone the repository or download the script:

    git clone https://github.com/MAPSIM-co/Mapsim_Assistance.git
    cd Mapsim_Assistance
    chmod +x Mapsim_Assistance.sh
    
### 2. Run the script manually:

    sudo ./Mapsim_Assistance.sh

### 3. Once installed, run:

    sudo mapsim_assistance

---

## Usage

-  From the X-ui Panel you can:

-  Setup auto-restart schedule (minutes/hours)
  
-  View current schedule
  
-  Modify or remove the cron job
  
-  View logs in /var/log/xui_cron.log


---

##  Sample Cron Job Created

  ``*/30 * * * * /usr/local/bin/x-ui restart >> /var/log/xui_cron.log 2>&1``

---

## Important Notes

-  The script checks for x-ui in the PATH and configures crontab automatically.
-  All logs are stored in /var/log/xui_cron.log
-  The systemd service will ensure the assistant is available after reboot.

---

## License

This project is licensed under the [MIT](https://github.com/MAPSIM-co/Mapsim_Assistance/blob/main/LICENSE) License.

---

## Contribution

If you have suggestions or find issues, please submit a Pull Request or open an issue.

