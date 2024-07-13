# Debian Configuration

## Install sudo

First off, you need to install ```sudo```:

run the following command once you are logged in (login@hostname):

```sh
su root
```

Afterwards, run:

```sh
apt update && apt upgrade && apt install sudo
```

## Create sudo log file

Create a sudo folder in ```/var/log/``` if it's not done yet. And also create a file to store logs for sudo commands.

```sh
cd /var/log && mkdir sudo && cd sudo && touch sudo.log
```

Next, you need to edit the sudo ```Defaults``` rules:

```sh
sudo visudo
```

```sh
Defaults     passwd_tries=3
Defaults     badpass_message="Wrong password. Try again!"
Defaults     logfile="/var/log/sudo/sudo.log"
Defaults     log_input
Defaults     log_output
Defaults     requiretty
```
Save the file (```Ctrl```+```O```) and exit (```Ctrl```+```X```).

## Add user to sudo group

Add to group sudo

```sh
sudo usermod -aG sudo login
```

Check if modification successful

```sh
sudo groups login
```

## Create user42 group and add user to it also

Create group ```user42```

```sh
sudo groupadd user42 && sudo usermod -aG user42 login
```

Check if modification successful

```sh
sudo groups login
```

If everything is ok, you can now ```exit``` the root session, and use ```sudo``` command from your login account.

Check again if ```login``` is in ```sudo``` group:

```sh
sudo whoami
```

The answer should be ```root```. If not, run ```sudo visudo``` again and find the line ```root ALL=(ALL:ALL) ALL```.

Right below this line, type

```sh
login ALL=(ALL:ALL) ALL
```

Save and Quit. Then exit root session, and run ```sudo whoami```

### User and Group command

#### Users

Here are some useful commands for user:

```useradd``` : creates a new user.

To change the default variables, use:

```sh
sudo nano /etc/default/useradd
```

Change the following lines:

```SHELL=/bin/sh``` to ```SHELL=/bin/bash```

```CREATE_MAIL_SPOOL=no``` to ```CREATE_MAIL_SPOOL=yes```

Flags:

```-m``` add home folder

```-s /bin/bash``` change default terminal to bash instead of shell

```-g <group>``` assign default group for new user

Here is a command to use once you have modified the useradd file:

```sh
sudo useradd -m -g <group> <user> && sudo passwd <user>
```

To check the password status of a user, run:

```sh
sudo passwd -S <user>
```

---

```usermod``` : changes the user’s parameters

Flags:

```-l``` for the username

```-c``` for the full name

```-g``` for groups by group ID.

---

```userdel -r``` : deletes a user and all associated files.

---

```id -u``` : displays user ID.

---

```users``` : shows a list of all currently logged in users.

---

```cat /etc/passwd | cut -d ":" -f 1``` : displays a list of all users on the machine.

---

#### Groups

Here are some useful commands for groups:

```groupadd <group>``` : creates a new group.

---

```gpasswd -a <user> <group>``` OR ```usermod -aG <group> <user>``` : adds a user to a group.

---

```gpasswd -d <user> <group>``` : removes a user from a group.

---

```groupdel <group>``` : deletes a group.

---

```groups <user>``` : displays the groups of a user.

---

```id -g``` : shows a user’s main group ID.

---

```getent group``` : displays a list of all users in a group.

---

## Password Management

To update password quality there are a few steps to follow.

First, run:

```sh
sudo nano /etc/login.defs
```

Change the following lines:

```sh
PASS_MAX_DAYS  30
PASS_MIN_DAYS  2
PASS_WARN_AGE  7
```

Once done, set manually the rules to ```root``` and ```<login>```

```sh
sudo chage root && sudo chage <login>
```

When you are done with this step, check the status:

```sh
sudo chage -l <user>
```

### Install libpam-pwquality

```sh
sudo apt update && sudo apt upgrade && sudo apt install libpam-pwquality
```

This is an additional tool to check for the quality of a password. Once it is installed, open and edit its config file.

```sh
sudo nano /etc/security/pwquality.conf
```

Edit the following lines, make sure to uncomment the line (remove ```#``` sign):

```sh
difok = 7
minlen = 10
dcredit = -1
ucredit = -1
lcredit = -1
maxrepeat = 3
usercheck = 1
retry = 3
enforce_for_root
```

Since the root account will not be asked for the current password when setting up a new password, the ```difok``` option will not be checked by default. However, all other options will be required.

## Hostname configuration

You may be asked to change the hostname:

```sh
sudo hostnamectl set-hostname <new_hostname>
hostnamectl status
```

To test if the hostname changed successfully, you can also ```exit``` and ```login``` again and check the text after the ```@``` sign on the terminal.

## Monitoring.sh

Here are some useful commands to create the script

```cat /proc/cpuinfo``` CPU information physical and virtual

```cat /proc/net/sockstat``` sockets information for TCP

```man``` manual page for useful information

```grep``` fetch specific lines and pattersn

```sed``` stream editor

```awk``` output format with other functions like printf

```cut``` get specific portion of a file

```uname``` architecture information

```free``` RAM usage information

```crontab```

```df``` Disk usage information

```who``` last boot information

```lsblk``` partition information

```hostname``` hostname information

```ip link show``` and ```ip a``` IP and MAC address information

```wall``` to display the message on the standard output

## Script - monitoring.sh

Create a new file in root folder ```/monitoring.sh```

```sh
sudo touch monitoring.sh && sudo chmod 755 monitoring.sh
```

Create the script

```sh
# Enable crontab to use monitoring.sh every 10 minutes
ARCH=$(uname -srvmo)
PCPU=$(grep "physical id" /proc/cpuinfo | cut -d ":" -f 2)
VCPU=$(grep "processor" /proc/cpuinfo | cut -d ":" -f 2)
RAM_TOT=$(free --mega -h | grep "Mem" | awk '{print $2}')
RAM_USE=$(free --mega -h | grep "Mem" | awk '{print $3}')
RAM_PRC=$(free -b | grep "Mem" | awk '{printf("%.2f%%", $3 / $2 * 100)}')
DSK_TOT=$(df -h --total | grep "total" | awk '{print $2}')
DSK_USE=$(df -h --total | grep "total" | awk '{print $3}')
DSK_PRC=$(df -k --total | grep "total" | awk '{printf("%.2f%%"), $5}')
CPU_LOD=$(top -bn1 | grep "%Cpu" | awk '{printf("%.2f%%", $2 + $4)}')
LAST_BT=$(who | awk '{print $3 " " $4}')
LVM_USE=$(if[$(lsblk | grep -c "lvm") -eq 0]; then echo no; else echo yes; fi)
TCP_CNX=$(grep "TCP" /proc/net/sockstat | awk '{print $3}')
USR_LOG=$(who | wc -l)
NET_IPA=$(hostname -I | awk '{print $1}')
NET_MAC=$(ip a | grep "link/ether" | awk '{print $2}')
SUDO_CT=$(grep -c "COMMAND" /var/log/sudo/sudo.log)

wall "
#Architecture: $ARCH
#CPU physical: $PCPU
#vCPU: $VCPU
#Memory Usage: $RAM_USE/$RAM_TOT ($RAM_PRC)
#Disk Usage: $DSK_USE/$DSK_TOT ($DSK_PRC)
#CPU Load: $CPU_LOD
#Last boot: $LAST_BT
#LVM use: $LVM_USE
#Connexions TCP: $TCP_CNX ESTABLISHED
#User log: $USR_LOG
#Network: IP $NET_IPA ($NET_MAC)
#Sudo: $SUDO_CT cmd
"
```

```sh
# Enable crontab to use monitoring.sh every 10 minutes
ARCH=$(uname -srvmo)
PCPU=$(grep "physical id" /proc/cpuinfo | uniq | wc -l)
VCPU=$(grep "processor" /proc/cpuinfo | uniq | wc -l)
RAM_TOT=$(free --mega -h | grep "Mem" | awk '{print $2}')
RAM_USE=$(free --mega -h | grep "Mem" | awk '{print $3}')
RAM_PRC=$(free -b | grep "Mem" | awk '{printf("%.2f%%", $3 / $2 * 100)}')
DSK_TOT=$(df -h --total | grep "total" | awk '{print $2}')
DSK_USE=$(df -h --total | grep "total" | awk '{print $3}')
DSK_PRC=$(df -k --total | grep "total" | awk '{printf("%.2f%%"), $5}')
CPU_LOD=$(top -bn1 | grep "%Cpu" | awk '{printf("%.2f%%", $2 + $4)}')
LAST_BT=$(who | awk '{print $3 " " $4}')
LVM_USE=$(if[$(lsblk | grep -c "lvm") -eq 0]; then echo no; else echo yes; fi)
TCP_CNX=$(grep "TCP" /proc/net/sockstat | awk '{print $3}')
USR_LOG=$(who | wc -l)
NET_IPA=$(hostname -I | awk '{print $1}')
NET_MAC=$(ip a | grep "link/ether" | awk '{print $2}')
SUDO_CT=$(grep -c "COMMAND" /var/log/sudo/sudo.log)

wall "
#Architecture: $ARCH
#CPU physical: $PCPU
#vCPU: $VCPU
#Memory Usage: $RAM_USE/$RAM_TOT ($RAM_PRC)
#Disk Usage: $DSK_USE/$DSK_TOT ($DSK_PRC)
#CPU Load: $CPU_LOD
#Last boot: $LAST_BT
#LVM use: $LVM_USE
#Connexions TCP: $TCP_CNX ESTABLISHED
#User log: $USR_LOG
#Network: IP $NET_IPA ($NET_MAC)
#Sudo: $SUDO_CT cmd
"
```

## Crontab

To make the ```monitoring.sh``` script run every 10 minutes, you can use ```crontab```:

Check for crontab status

```sh
sudo systemctl status cron
```

If it is not yet enabled, enable it

```sh
sudo enable crontab
```

Open a new crontab file

```sh
crontab -e
```

In the crontab file add the following line, which is equivalent to ```bash monitoring.sh``` when you are in the root directory.

```sh
*/10 * * * * bash /monitoring.sh
```

First ```*/10``` means every 10th minute

The following ```*``` mean the ```hour```, ```day_of_month```, ```month```, and ```day_of_week``` resplectively. Use ```*``` to specify ```any```

The last portion of the script is the command to run.
