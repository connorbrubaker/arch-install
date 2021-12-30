#! /bin/bash

# synchronize and update system
sudo pacman -Syu 
# install packages from official repos
# comment out lines of packages that should not be installed
sudo pacman -S \
# desktop environment and display manager
	gnome \
	gnome-extra \
	gdm \
	# budgie-desktop \
	# cinnamon \
	# deepin \
	# plasma \
	# mate \
	# xfce4 \
	# sddm \
	# lightdm \
	# lightdm-gtk-greeter \
# fonts
	ttf-fira-code \
	ttf-fira-sans \
	ttf-dejavu \
	gnu-free-fonts \
	ttf-liberation noto-fonts \
	ttf-roboto \
	ttf-ubuntu-font-family \
	ttf-inconsolata \
	ttf-opensans \
	inter-font \
	cantarell-fonts \
	adobe-source-sans-fonts \
# other applications and programs
	discord \
	libreoffice-still \
	r \
	gcc-fortran \
	julia \
	docker \
	curl \
	grep \
	linux-headers \
	git \
	code \
	wget \
	python \
	texlive-most \
	gnome-latex \
	texstudio \
	shotwell \
	ant \
	boost-libs \
	qt5-sensors \
	qt5-svg \
	qt5-webengine \
	qt5-xmlpatterns \
	postgresql-libs \
	sqlite3 \
	soci \
	clang \
	hunspell-en_US \
	mathjax2 \
	pandoc \
	yaml-cpp \
	boost \
	desktop-file-utils \
	jdk8-openjdk \
	apache-ant \
	unzip \
	openssl \
	libcups \
	pam \
	patchelf \
	wget \
	yarn \
	--noconfirm
	
# enable services
sudo systemctl enable gdm.service
# sudo systemctl enable lightdm
# sudo systemctl enable sddm.service

# install rstudio from AUR
mkdir -p /tmp/aur/rstudio-desktop-bin
git clone https://aur.archlinux.org/rstudio-desktop-bin.git /tmp/aur/rstudio-desktop-bin
cd /tmp/aur/rstudio-desktop-bin && makepkg -si --nocheck --noconfirm
cd /home && rm -rf /tmp/aur/rstudio-desktop-bin

# install spotify from AUR
mkdir -p /tmp/aur/spotify
git clone https://aur.archlinux.org/spotify.git /tmp/aur/spotify
cd /tmp/aur/spotify && makepkg -si --nocheck --noconfirm
cd /home && rm -rf /tmp/aur/spotify

# install google chrome from AUR
mkdir -p /tmp/aur/google-chrome
git clone https://aur.archlinux.org/google-chrome.git /tmp/aur/google-chrome
cd /tmp/aur/google-chrome && makepkg -si --nocheck --noconfirm
cd /home && rm -rf /tmp/aur/google-chrome

# install zoom from AUR
mkdir -p /tmp/aur/zoom
git clone https://aur.archlinux.org/zoom.git /tmp/aur/zoom
cd /tmp/aur/zoom && makepkg -si --nocheck --noconfirm
cd /home && rm -rf /tmp/aur/zoom
