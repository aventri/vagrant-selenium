#!/bin/sh
echo "Setting autologin for the ubuntu user..."
if [ ! -d /etc/systemd/system/getty@tty1.service.d ]; then
  mkdir /etc/systemd/system/getty@tty1.service.d
fi
AUTO_LOGIN=$(cat <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin ubuntu %I $TERM
Type=idle
EOF
)
echo "${AUTO_LOGIN}" > /etc/systemd/system/getty@tty1.service.d/override.conf

cd /home/ubuntu

echo "Start X on login..."
PROFILE_STRING=$(cat <<EOF
if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

if [ ! -e "/tmp/.X0-lock" ] ; then
    startx
fi
EOF
)
echo "${PROFILE_STRING}" > .profile

echo "Downloading the latest chrome..."
wget --no-verbose "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb
apt-get install -y -f

echo "Downloading the latest selenium server..."
SELENIUM_VERSION=$(curl "https://selenium-release.storage.googleapis.com/" | perl -n -e'/.*<Key>([^>]+selenium-server-standalone-2[^<]+)/ && print $1')
wget --no-verbose "https://selenium-release.storage.googleapis.com/${SELENIUM_VERSION}" -O selenium-server-standalone.jar
chown ubuntu:ubuntu selenium-server-standalone.jar

echo "Downloading the latest chrome driver..."
CHROMEDRIVER_VERSION=$(curl "http://chromedriver.storage.googleapis.com/LATEST_RELEASE")
wget --no-verbose "http://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip"
unzip chromedriver_linux64.zip
rm chromedriver_linux64.zip
chown ubuntu:ubuntu chromedriver

echo -n "Installing tmux scripts..."
TMUX_SCRIPT=$(cat <<EOF
#!/bin/sh
tmux start-server

tmux new-session -d -s selenium
tmux send-keys -t selenium:0 './chromedriver' C-m

tmux new-session -d -s chrome-driver
tmux send-keys -t chrome-driver:0 'java -jar selenium-server-standalone.jar' C-m
EOF
)
echo "${TMUX_SCRIPT}"
echo "${TMUX_SCRIPT}" > tmux.sh
chmod +x tmux.sh
chown ubuntu:ubuntu tmux.sh

echo -n "Installing startup scripts..."
STARTUP_SCRIPT=$(cat <<EOF
#!/bin/sh
~/tmux.sh &
xrandr -s 1920x1080 &
EOF
)
echo "${STARTUP_SCRIPT}" > /etc/X11/Xsession.d/9999-common_start
chmod +x /etc/X11/Xsession.d/9999-common_start

# Automatically log in and start X on first build
reboot now
