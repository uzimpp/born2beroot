# ====== Initial setup ======
lsblk
su
apt install sudo
sudo apt update
adduser <user_name> sudo
# adduser will ask for password and informations
# while useradd will not
# both can be used for achieving the same result
hostname
sudo hostnamectl set-hostname <new_hostname>
hostnamectl status
# You can skip this part if you use nano
sudo apt install vim
	# ====== extra ======
	# if you face an issue with your vm time or timezone try this
	timedatectl
	timedatectl list-timezones
	timedatectl set-timezone "bla bla bla"
sudo aa-status

# ====== Password ======
# In /etc/sudoers
sudo vim /etc/sudoers
Defaults		passwd_tries=3
Defaults        email
Defaults		secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin" # Follow the subject

# Should not edit in the /etc/sudoers, instead do this
sudo visudo -f /etc/sudoers.d/newrule
Defaults		badpass_message="Bad password, please try again :("
Defaults		logfile="/var/log/sudo/sudo.logs"	# Don't forget that /var/log/sudo/sudo.logs should exist too, otherwise create them by mkdir and cd
Defaults		log_input
Defaults		log_output
Defaults		iolog_dir="/var/log/sudo"
Defaults		requiretty

	# ---- Test ----
	# Try to sudo from your account
	# You should check for the error message when wrong password is typed
	sudo
	sudo echo "                                This is the text                               "
	sudo cat /var/log/sudo/sudo.logs

sudo vim /etc/login.defs
>>	PASS_MAX_DAYS   99999		--> PASS_MAX_DAYS   30
>>	PASS_MIN_DAYS   0			--> PASS_MIN_DAYS   2
>>	PASS_WARN_AGE   7

sudo chage -M 30 <user_name>
sudo chage -m 2 <user_name>
sudo chage -W 7 <user_name>
	# ---- Test ----
	sudo chage -l <user_name>

sudo apt install libpam-pwquality
sudo vim /etc/security/pwquality.conf
>>	retry=3
	minlen=10					# Minimum length 10
	ucredit=-1					# Must contain at least one uppercase
	lcredit=-1					# Must contain at least one lowercase
	dcredit=-1					# Must contain at least one numeric character
	maxrepeat=3					# Maximum 3 consecutive characters can be used
	usercheck=1					# Must not contain the username
	enforce_for_root			# We made the rules valid for root as well

sudo vim /etc/pam.d/common-password
>>	password        requisite                       pam_pwquality.so difok=7

	# ---- Test ----
	sudo passwd root
	passwd
	sudo addgroup user42					--> We created a new group named "user42".
	sudo adduser <user_name> user42			--> We added the specified user to the user42 group.
	sudo passwd <user_name>					--> change the passwords.
	sudo deluser <user_name>				# must logout or exit First
	sudo deluser -remove-home <user_name>


# ====== ufw ======
sudo apt install ufw
sudo ufw enable
sudo ufw allow 4242
sudo ufw status
	# IMPORTANT: TO BE ABLE TO ESTABLISH AN SSH CONNECTION, WE NEED TO DO PORT FORWARDING THROUGH VM
	# -Right-click on the virtual server we installed in the VM interface, go to settings, then network section, and click on the port forwarding section under the advanced menu
	# -On the right side of the new window, there's a green new connection rule button, let's click it once. Then
	# -NAME: SSH
	# -PROTOCOL: TCP
	# -HOST PORT: // This is lock try to user other aviable ports such as 2424
	# -GUEST PORT: 4242
	# You can edit it like this and click OK below.
	# ---- Test ----
	sudo ufw allow 1234
	sudo ufw deny 1234
	sudo ufw delete allow 1234
ss -tunlp


# ====== SSH =======
sudo apt install openssh-server
sudo vim /etc/ssh/sshd_config
		#Port 22                            ->  Port 4242
		#PermitRootLogin prohibit-password  ->  PermitRootLogin no
		# Don't forget to remove #
sudo reboot
sudo service ssh status

	# ---- Test ----
	# Now let's try running on the workstation terminal or your personal laptop
	To begin with, run this on your workstation
	ip a
	>> 10.12.17.1	# user the ip of the second one
	ssh <user_name>@<ip> -p <Your host port>	# such as ssh wkullana@10.12.17.1 -p 2424
# !!! if you are able to connect to your VM, you can now copy and paste the next step :D !!!


# ====== monitoring ======
sudo crontab -u root -e
>> */10 * * * * sh /usr/bin/bashscript/

cd /usr/bin/
mkdir bashscript
cd bashscript

sudo vim monitoring.sh
>> use the code in /born2beroot/monitoring.sh

# ====== signature.txt ======
cd /sgoinfre/born2beroot
sha1sum born2beroot.vdi