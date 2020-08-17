#/usr/bin/env bash
set -x

# update
sudo apt update &&  sudo apt upgrade

# set user password
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

sudo /etc/init.d/ssh restart

sudo passwd ubuntu

# install xrdp
sudo apt install xrdp xfce4 xfce4-goodies tightvncserver

echo xfce4-session> /home/ubuntu/.xsession

sudo cp /home/ubuntu/.xsession /etc/skel

sudo sed -i '0,/-1/s//ask-1/' /etc/xrdp/xrdp.ini

sudo service xrdp restart

# install Android Virtual device
sudo apt-get install openjdk-8-jdk

wget https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip
sudo cp commandlinetools-linux-6609375_latest.zip /opt/android/sdk/sdk.zip

sudo mkdir /opt/android
sudo mkdir /opt/android/sdk
cd /opt/android/sdk

export PATH="/home/ubuntu/:$PATH"
export PATH="/opt/android/sdk:$PATH"
export ANDROID_SDK_ROOT="/opt/android/sdk"
export ANDROID_HOME="/opt/android/sdk"
source ~/.bashrc

sudo unzip sdk.zip
sudo mkdir /opt/android/sdk/cmdline-tools
sudo cp -r tools cmdline-tools
cd cmdline-tools/tools/bin/

# install Android image
sudo ./sdkmanager platform-tools emulator
sudo ./sdkmanager "system-images;android-25;google_apis;armeabi-v7a"
sudo ./sdkmanager "platforms;android-25"

./avdmanager -v create avd -f -n ojos -k "system-images;android-25;google_apis;armeabi-v7a"

# Run Android emulator
cd ../../../platform-tools
./adb start-server

cd ../emulator
./emulator -memory 1024 -avd ojosfinal -no-audio -gpu swiftshader_indirect -show-kernel -no-snapshot-load
