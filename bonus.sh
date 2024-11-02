# ====== Web Server (lighttpd) ======
sudo apt install lighttpd		# An alternative HTTP server besides NGINX and APACHE
sudo ufw allow 80				# Port 80 is the standard port for HTTP
sudo systemctl start lighttpd
sudo systemctl enable lighttpd
	# ---- Test ----
	sudo systemctl status lighttpd

# ====== Database (MariaDB) ======
sudo apt install mariadb-server	# MariaDB is a relational database derived from MySQL
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation	# To configure default and insecure settings
	# Answer these questions:
	# Enter current password for root -> Press Enter
	# Switch to unix_socket authentication? -> N
	# Change the root password? -> N
	# Remove anonymous users? -> Y
	# Disallow root login remotely? -> Y
	# Remove test database and access to it? -> Y
	# Reload privilege tables now? -> Y

# ====== Database Setup ======
sudo mariadb						# Enter MariaDB console
	CREATE DATABASE wordpress_db;	# Create a new database
	CREATE USER 'wkullana'@'localhost' IDENTIFIED BY 'password1234';
	GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wkullana'@'localhost';	# Give permissions to new user
	FLUSH PRIVILEGES;				# Apply changes
	exit
	# ---- Test ----
	mariadb -u wkullana -p		# Try connecting with new user
	SHOW DATABASES;				# Should see wordpress_db and information_schema
	exit

# ====== PHP Setup ======
sudo apt install php-cgi php-mysql	# CGI allows web servers to communicate with PHP
									# php-mysql allows PHP to interact with MariaDB

# ====== WordPress Setup ======
sudo apt install wget				# Tool to download files from web
cd /var/www/html/					# Web server's root directory
sudo wget http://wordpress.org/latest.tar.gz	# Download WordPress
sudo tar -xzvf latest.tar.gz		# Extract the downloaded archive
sudo rm latest.tar.gz				# Remove the archive file
sudo cp -r wordpress/* .			# Copy WordPress files to current directory
sudo rm -rf wordpress				# Remove the now-empty WordPress directory
sudo cp wp-config-sample.php wp-config.php	# Create configuration file from sample
sudo nano wp-config.php				# Edit WordPress configuration
	# Edit these lines:
	define('DB_NAME', 'wordpress_db');		# Database name we created
	define('DB_USER', 'wkullana');			# Database user we created
	define('DB_PASSWORD', 'password1234');	# Database password we set

# ====== Configure lighttpd ======
sudo lighty-enable-mod fastcgi		# Enable FastCGI module
sudo lighty-enable-mod fastcgi-php	# Enable PHP through FastCGI
sudo service lighttpd force-reload	# Restart web server to apply changes

# run this command and look for enp6s0
ip a
>> http://<ip>:8080 #http://10.12.13.3:8080

# ====== FTP Server Setup ======
sudo apt install vsftpd				# Install FTP server
sudo ufw allow 21					# Allow FTP port through firewall
sudo nano /etc/vsftpd.conf			# Configure FTP server
	# Remove # from:
	write_enable=YES				# Allow write commands
	# Add these lines:
	user_sub_token=$USER			# Use username in paths
	local_root=/home/$USER/ftp		# FTP root directory
	userlist_enable=YES				# Enable user list
	userlist_file=/etc/vsftpd.userlist	# File containing allowed users
	userlist_deny=NO				# Allow only users in list

# ====== FTP Directory Setup ======
sudo mkdir /home/$USER/ftp			# Create FTP root directory
sudo mkdir /home/$USER/ftp/files	# Create directory for files
sudo chown nobody:nogroup /home/$USER/ftp	# Set directory ownership
sudo chmod a-w /home/$USER/ftp				# Remove write permissions


# ====== FTP User Setup ======
sudo touch /etc/vsftpd.userlist		# Create allowed users list
echo $USER | sudo tee -a /etc/vsftpd.userlist	# Add current user to list
sudo systemctl restart vsftpd		# Restart FTP server

	# ---- Test FTP ----
	sudo systemctl status vsftpd		# Check if FTP server is running
	# Try connecting with FTP client using:
	# Host: Your VM IP
	# Port: 21
	# Username: Your username
	# Password: Your password
	
	# Create test file
	cd ~
	echo "Hello FTP" > test.txt
	
	# In FTP client:
	put test.txt    # Upload file
	get test.txt    # Download file


# ====== Stress ======
sudo apt install stress
uptime
sudo stress --cpu 8 --timeout 20