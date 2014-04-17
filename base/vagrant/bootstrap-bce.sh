#!/bin/bash

BCE_PROVISION="$1"

START_TIME=$(date '+%s')
# Ubuntu packages
# rabbitvcs pulls in Ubuntu ipython which we displace later with pip
# Python packages
# < = requires package ; > = pulls in
# boilerpipe < default-jre default-jdk
# boilerpipe > JPype1 charade
# rpy2 < liblzma-dev
# pyyaml < libyaml-dev
# pandas > dateutil pytz numpy
# ipython > tornado pyparsing nose backports.ssl-match-hostname 
# sphinx > Pygments docutils Jinja2 markupsafe
# scrapy > Twisted w3lib queuelib cssselect
# scrapy < libxslt1-dev libssl-dev
# flask > Werkzeug itsdangerous
# ipythonblocks < ez_setup
# seaborn < patsy
# seaborn > husl moss statsmodels
# ipython notebook < pyzmq libzmq3-dev
# apt-get installing python-gtk2-dev is much faster than pip-installing gtk2

# rpy2 20140409: Requires this patch to build. Waiting on next release.
# https://bitbucket.org/bioinformed/rpy2/commits/c1c9ddf2910cfb68fe56ee4891ed6785a0b8352b

case "${BCE_PROVISION}" in
	DLAB)
		DEBS="${DEBS} sqlite3 pandoc r-recommended libjpeg62 fonts-mathjax python-software-properties python-dev python-pip python-setuptools python-pip python-gtk2-dev texlive texlive-latex-base texlive-latex-extra texlive-fonts-extra texlive-fonts-recommended texlive-pictures gedit gedit-plugins gedit-developer-plugins gedit-r-plugin gedit-latex-plugin gedit-source-code-browser-plugin rabbitvcs-gedit thunar-vcs-plugin firefox xpdf evince gv libreoffice libyaml-dev libzmq3-dev libssl-dev libxslt1-dev liblzma-dev lightdm xrdp xfce4 xfce4-terminal xubuntu-default-settings"
		PIPS="${PIPS} pandas matplotlib scipy rpy2 ipython==1.2.1 sphinx scrapy distribute virtualenv apiclient BeautifulSoup boilerpipe bson cluster envoy feedparser flask geopy networkx oauth2 prettytable pygithub pymongo readline requests twitter twitter-text-py uritemplate google-api-python-client jinja facebook nltk ez_setup ipythonblocks scikits.learn sklearn-pandas patsy seaborn pyzmq markdown git+git://github.com/getpelican/pelican.git@011cd50e2e7 ghp-import"
		;;
	SCF)
		DEBS="${DEBS} sqlite3 pandoc r-recommended libjpeg62 fonts-mathjax python-software-properties python-dev python-pip python-setuptools python-pip python-gtk2-dev texlive texlive-latex-base texlive-latex-extra texlive-fonts-extra texlive-fonts-recommended texlive-pictures gedit gedit-plugins gedit-developer-plugins gedit-r-plugin gedit-latex-plugin gedit-source-code-browser-plugin thunar-vcs-plugin firefox xpdf evince gv libreoffice libyaml-dev libzmq3-dev libssl-dev libxslt1-dev liblzma-dev lightdm xrdp xfce4 xfce4-terminal xubuntu-default-settings"
		PIPS="${PIPS} pandas matplotlib scipy rpy2 ipython==1.2.1 sphinx scrapy distribute virtualenv apiclient BeautifulSoup boilerpipe bson cluster envoy feedparser flask geopy networkx oauth2 prettytable pygithub pymongo readline requests twitter twitter-text-py uritemplate google-api-python-client jinja facebook nltk ez_setup ipythonblocks scikits.learn sklearn-pandas patsy seaborn pyzmq markdown git+git://github.com/getpelican/pelican.git@011cd50e2e7 ghp-import"
		;;
esac
	
echo "BCE: Updating apt cache..."
apt-get update > /dev/null && \
echo DONE || echo FAIL

echo "BCE: Installing build utilities..."
#apt-get -y install build-essential dkms xserver-xorg dmidecode && \
apt-get -y install xserver-xorg && \
echo DONE || echo FAIL

# Track system changes
apt-get -y install git etckeeper && \
sed -i -e '/^VCS/s/^/#/' -e '/="git"/s/^#//' /etc/etckeeper/etckeeper.conf && \
cd /etc && \
git config --global user.name "BCE provisioner" && \
git config --global user.email "bce@lists.berkeley.edu" && \
etckeeper init && \
echo DONE || echo FAIL

if [ "${BCE_PROVISION}" != "DLAB" ]; then
# Automate VBox guest additions by downloading the ISO from virtualbox.org.
# An alternative method would be to manually share the directory on the host
# which actually contains VBoxGuestAdditions.iso. On a Mac that is
# /Applications/VirtualBox.app/Contents/MacOS/. Just like with the host user's
# home directory however, there's no convenient variable representing this
# location within the Shared Folders configuration.
msg="BCE: Installing Guest Additions..."
echo "$msg"
(
	V=$(dmidecode | grep vboxVer | sed -e 's/.*_//')
	if [ -z "${V}" ]; then
		V=$(modinfo vboxguest | grep ^version | sed -e 's/.* //' -e 's/_.*//')
	fi

	ISO=VBoxGuestAdditions_${V}.iso
	ISO_URL=http://download.virtualbox.org/virtualbox/${V}/${ISO}
	curl -L -o /tmp/${ISO} ${ISO_URL} && \
	mount -o loop,ro /tmp/${ISO} /mnt && \
	/mnt/VBoxLinuxAdditions.run -- --force && \
	umount /mnt && rm /tmp/${ISO} && \
	true
) && \
( echo DONE ; etckeeper commit "$msg" ) || echo FAIL
fi

# CRAN repo
# There is no 14.04 CRAN archive yet so it is commented out
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
#echo "#deb http://cran.cnr.berkeley.edu/bin/linux/ubuntu trusty/" > \
#	/etc/apt/sources.list.d/cran.list && \
# Prefer rrutter and c2d4u PPAs
msg="BCE: Installing R PPAs..."
echo "$msg"
add-apt-repository -y ppa:marutter/rrutter && \
add-apt-repository -y ppa:marutter/c2d4u && \
( echo DONE ; etckeeper commit "$msg" ) || echo FAIL

msg="BCE: Updating OS..."
echo "$msg"
apt-get update && \
DEBIAN_PRIORITY=high DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade && \
( echo DONE ; etckeeper commit "$msg" ) || echo FAIL

msg="BCE: Installing selective packages..."
echo "$msg"
apt-get -y install ${DEBS} && \
( echo DONE ; etckeeper commit "$msg" ) || echo FAIL

# Google Chrome
msg="BCE: Installing google chrome..."
echo "$msg"
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > \
	/etc/apt/sources.list.d/google-chrome.list && \
curl -L https://dl-ssl.google.com/linux/linux_signing_key.pub | \
	apt-key add - && \
apt-get update > /dev/null && \
apt-get -y install google-chrome-stable && \
( echo DONE ; etckeeper commit "$msg" ) || echo FAIL

# R, RStudio
msg="BCE: Installing RStudio..."
echo "$msg"
RSTUDIO_URL=`python /vagrant/getrstudio` && \
curl -L -O ${RSTUDIO_URL} && \
dpkg -i $(basename ${RSTUDIO_URL}) && \
( echo DONE ; etckeeper commit "$msg" ) || echo FAIL

msg="BCE: Installing Python modules..."
echo "$msg"
for p in ${PIPS} ; do \
	printf "%20s =========================================\n" "${p}"
	pip install --upgrade "${p}" 2>/tmp/pip-err-${p}.log | \
		tee /tmp/pip-out-${p}.log
done && \
( echo DONE ; etckeeper commit "$msg" ) || echo FAIL

# Configure desktop
msg="BCE: Setting Xfce4 as default X session"
echo "$msg"
update-alternatives --set x-session-manager /usr/bin/xfce4-session && \
( echo DONE ; etckeeper commit "$msg" ) || echo FAIL

msg="BCE: Hide boot messages"
echo "$msg"
sed -i \
	-e '/GRUB_HIDDEN_TIMEOUT=/s/^#//' \
	-e '/^GRUB_CMDLINE_LINUX_DEFAULT=""/s/""/"quiet splash"/' \
	/etc/default/grub && \
( echo DONE ; etckeeper commit "$msg" ) || echo FAIL

msg="BCE: Disable sudo password for those in the sudo group"
echo "$msg"
printf "%%sudo\tALL=(ALL:ALL) NOPASSWD: ALL\n" > /etc/sudoers.d/nopasswd && \
( echo DONE ; etckeeper commit "$msg" ) || echo FAIL

msg="BCE: Set a 4-space tabstop for nano"
echo "$msg"
sed -i -e '/# set tabsize 8/s/.*/set tabsize 4/' /etc/nanorc && \
( echo DONE ; etckeeper commit "$msg" ) || echo FAIL

if [ "${BCE_PROVISION}" != "DLAB" ]; then
msg="BCE: Create oski user"
echo "$msg"
( 
	adduser --gecos "" --disabled-password oski && echo oski:oski | chpasswd 
	# Enable oski to sudo without a password
	adduser oski sudo
	# Enable oski to mount shared folders
	adduser oski vboxsf
	# Enable oski to login without a password
	adduser oski nopasswdlogin
) && \
( echo DONE ; etckeeper commit "$msg" ) || echo FAIL

msg="BCE: Configure oski desktop"
echo "$msg"
(
	sudo -u oski mkdir /home/oski/Desktop /home/oski/.config
	# Create a convenient place on the desktop for people to mount
	# their Shared Directories.
	cd /home/oski/Desktop
	sudo -u oski ln -s /media Shared
	# Fetch and install Xfce configuration
	# - change desktop background from image to solid color
	# - panel launcher for terminal, file manager, browser, gedit
	# - remove desktop icon for Trash, File System; leave Home
	# - change Application Menu widget to use a generic computer icon from
	#   whatever it is that XFCE uses.
	# - Benoit prefers black-on-white terminal; easier to see on projectors
	sudo -u oski rsync -av /vagrant/xfce4 /home/oski/.config/
) && \
echo DONE || echo FAIL

# Automatically login oski at boot
msg="BCE: Automatically login oski at boot"
echo "$msg"
printf "[SeatDefaults]\nautologin-user=oski\nautologin-user-timeout=0\n" >> \
	/etc/lightdm/lightdm.conf.d/20-BCE.conf && \
	#/usr/lib/lightdm/lightdm-set-defaults --autologin oski
( echo DONE ; etckeeper commit "$msg" ) || echo FAIL
fi

# Clean up the image before we export it
apt-get clean
END_TIME=$(date '+%s')

ELAPSED_SECS=$((END_TIME-START_TIME))
printf "Elapsed time: %s minutes\n" $((ELAPSED_SECS/60))
