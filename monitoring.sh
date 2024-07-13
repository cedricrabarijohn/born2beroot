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