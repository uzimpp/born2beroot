# Architecture
	arc=$(uname -a)

# CPU physical
	pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
# vCPU
	vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)
# CPU load
	cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')

# Memory Usage
	fram=$(free -m | awk '$1 == "Mem:" {print $2}')
	uram=$(free -m | awk '$1 == "Mem:" {print $3}')
	pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

# Disk Usage
	fdisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
	udisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
	pdisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{utar += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')

# Last boot
	lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')
	lvmt=$(lsblk | grep "lvm" | wc -l)
	lvmu=$(if [ $lvmt -eq 0 ]; then echo No; else echo Yes; fi)

# Connections TCP
	ctcp=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')

# User log
	ulog=$(users | wc -w)

# Network IP
	ip=$(hostname -I)
	mac=$(ip link show | awk '$1 == "link/ether" {print $2}')

# Sudo
	cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)


wall "  #Architecture: $arc
	#CPU physical: $pcpu
	#vCPU: $vcpu
	#CPU load: $udisk/${fdisk}Gb ($pdisk%)
	#Memory Usage: $uram/${fram}MB ($pram%)
	#Disk Usage: $cpul
	#Last boot: $lb
	#LVM use: $lvmu
	#Connections TCP: $ctcp ESTABLISHED
	#User log: $ulog
	#Network IP: IP $ip ($mac)
	#Sudo: $cmds cmd"
