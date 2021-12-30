#! /bin/bash

# synchronize and update system
echo "Updating system..."
sleep 1s
sudo pacman -Syu --noconfirm

# install packages from official repos
echo "Installing packages..."
sleep 1s
sudo pacman -S \
	plasma \
	kde-applications \
	sddm \
	sddm-kcm \
	ntp \
	cups \
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
	wget \
	python \
	texlive-most \
	gnome-latex \
	texstudio \
	shotwell \
	--noconfirm
	
# install packages from AUR
PackageList=(
	"rstudio-desktop-bin"
	"spotify"
	"google-chrome"
	"zoom"
	"visual-studio-code-bin"
)

# for each package in the above list, create a directory in /tmp/aur/
# and clone that repo into its respective folder; then enter each of
# those directories and install the package
rm -rf /tmp/aur/
mkdir -p /tmp/aur/
for package in ${PackageList[*]}; do 
	echo "Installing ${package} from AUR..."
	sleep 1s
	mkdir "/tmp/aur/${package}"
	git clone "https://aur.archlinux.org/${package}.git" "/tmp/aur/${package}"
	cd "/tmp/aur/${package}" && makepkg -rsi --noconfirm 
	cd /tmp/aur && rm -rf "/tmp/aur/${package}"
	echo "Finished installing ${package}"
	echo ""
done

# enable services
sudo systemctl enable sddm.service
sudo systemctl enable ntpd.service
sudo systemctl enable cups.service

# reboot
sudo reboot
