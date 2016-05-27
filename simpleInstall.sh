sudo apt-get install -y apache2 php5 libapache2-mod-php5 gpac motion python-flup lighttpd

sudo cp -r www/* /var/www/
sudo mkdir -p /var/www/media
sudo chown -R www-data:www-data /var/www


sudo mknod /var/www/FIFO p
sudo chmod 666 /var/www/FIFO
sudo mknod /var/www/FIFO1 p
sudo chmod 666 /var/www/FIFO1
sudo ln -sf /run/shm/mjpeg/cam.jpg /var/www/cam.jpg

# modify "sudo nano /etc/apache2/sites-enabled/000-default.conf ":  "DocumentRoot /var/www "
sudo cp -r etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf
sudo /etc/init.d/apache2 restart


sudo cp etc/sudoers.d/RPiROV /etc/sudoers.d/
sudo chmod 440 /etc/sudoers.d/RPiROV

sudo cp -r bin/raspimjpeg /opt/vc/bin/
sudo chmod 755 /opt/vc/bin/raspimjpeg
sudo ln -s /opt/vc/bin/raspimjpeg /usr/bin/raspimjpeg


cat etc/raspimjpeg/raspimjpeg.1 > etc/raspimjpeg/raspimjpeg
sudo cp -r etc/raspimjpeg/raspimjpeg /etc/
sudo chmod 644 /etc/raspimjpeg
sudo ln -s /etc/raspimjpeg /var/www/raspimjpeg

sudo chmod 755 /var/www/html/doStuff.py
sudo cp /usr/bin/python2.7 /usr/bin/pythonRoot
sudo chmod u+s /usr/bin/pythonRoot
sudo cp etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf



cat etc/rc_local_run/rc.local.1 > etc/rc_local_run/rc.local
sudo cp -r etc/rc_local_run/rc.local /etc/
sudo chmod 755 /etc/rc.local

sudo usermod -a -G video www-data

## edit /etc/passwd to make www-data available
sudo chsh -s /bin/bash www-data


sudo mkdir -p /dev/shm/mjpeg
sudo chown www-data:www-data /dev/shm/mjpeg
sudo chmod 777 /dev/shm/mjpeg
sleep 1;sudo su -c 'raspimjpeg > /dev/null &' www-data
sleep 1;sudo su -c 'php /var/www/schedule.php > /dev/null &' www-data
killall -9 python lighttpd
sudo /etc/init.d/lighttpd start
echo "Started"

