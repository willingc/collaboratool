#!/bin/bash

# We set BCE_PROVISION from the shell
# BCE_PROVISION="$1"

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

DEBS="${DEBS} curl sqlite3 pandoc r-recommended libjpeg62 fonts-mathjax python-software-properties python-dev python-pip python-setuptools python-pip python-gtk2-dev texlive texlive-latex-base texlive-latex-extra texlive-fonts-extra texlive-fonts-recommended texlive-pictures gedit gedit-plugins gedit-developer-plugins gedit-r-plugin gedit-latex-plugin gedit-source-code-browser-plugin rabbitvcs-gedit thunar-vcs-plugin firefox xpdf evince gv libreoffice libyaml-dev libzmq3-dev libssl-dev libxslt1-dev liblzma-dev lightdm xrdp xfce4 xfce4-terminal xubuntu-default-settings"
# I've reverted to latest IPython here. It's good stuff, and introduces a
# UI change, so I'd rather users have that
PIPS="${PIPS} pandas matplotlib scipy rpy2 ipython sphinx scrapy distribute virtualenv apiclient BeautifulSoup boilerpipe bson cluster envoy feedparser flask geopy networkx oauth2 prettytable pygithub pymongo readline requests twitter twitter-text-py uritemplate google-api-python-client jinja facebook nltk ez_setup ipythonblocks scikits.learn sklearn-pandas patsy seaborn pyzmq markdown git+git://github.com/getpelican/pelican.git@011cd50e2e7 ghp-import"

# XXX - apt in general is probably too verbose for our useage - it's hard to
# detect where actual failures may have occurred. Maybe we can reduce verbosity?
msg="BCE: Updating apt cache..."
echo $msg
apt-get update > /dev/null && \
echo DONE: $msg || echo FAIL: $msg

msg="BCE: configure etckeeper with git..."
echo $msg
# Track system changes
apt-get -y install git etckeeper && \
sed -i -e '/^VCS/s/^/#/' -e '/="git"/s/^#//' /etc/etckeeper/etckeeper.conf && \
cd /etc && \
git config --global user.name "BCE provisioner" && \
git config --global user.email "bce@lists.berkeley.edu" && \
etckeeper init && \
echo DONE: $msg || echo FAIL: $msg

echo "BCE: Installing build utilities..."
# This is more robust - redundancy is not a problem!
apt-get -y install build-essential dkms xserver-xorg dmidecode curl software-properties-common && \
# apt-get -y install xserver-xorg && \
echo DONE: $msg || echo FAIL: $msg

# Automate VBox guest additions by downloading the ISO from virtualbox.org.
# An alternative method would be to manually share the directory on the host
# which actually contains VBoxGuestAdditions.iso. On a Mac that is
# /Applications/VirtualBox.app/Contents/MacOS/. Just like with the host user's
# home directory however, there's no convenient variable representing this
# location within the Shared Folders configuration.
# Note that there's also a `vboxmanage guestcontrol updateadditions` command
# And, I'm now attaching the Guest additions iso via Packer (but not yet
# mounting it). But it's a way to move in a slightly more efficient direction.

msg="BCE: Installing Guest Additions..."
echo "$msg"
(
    # if [ "${BCE_PROVISION}" != "DLAB" ]; then
    # fi
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
    true # XXX - does this do anything?
) && \
echo DONE: $msg || echo FAIL: $msg
# ( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg
# XXX - for some reason, while this appears to succeed, I get a FAIL message,
# maybe it's etckeeper?

# CRAN repo
# There is no 14.04 CRAN archive yet so it is commented out
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
#echo "#deb http://cran.cnr.berkeley.edu/bin/linux/ubuntu trusty/" > \
#	/etc/apt/sources.list.d/cran.list && \
# Prefer rrutter and c2d4u PPAs
msg="BCE: Installing R PPAs..."
echo "$msg"
apt-add-repository -y ppa:marutter/rrutter && \
apt-add-repository -y ppa:marutter/c2d4u && \
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

msg="BCE: Updating OS..."
echo "$msg"
apt-get update && \
DEBIAN_PRIORITY=high DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade && \
echo DONE: $msg  || echo FAIL: $msg
# etckeeper above fails because there were no changes to /etc
# There are hooks where apt upgrades will be committed automatically with
# etckeeper. So, we should probably just not include the etckeeper step for pure
# apt steps

msg="BCE: Installing scientific packages..."
echo "$msg"
apt-get -y install ${DEBS} && \
apt-get clean && \ # I guess we need this to avoid running out of memory
echo DONE: $msg  || echo FAIL: $msg
# etckeeper also FAILs because of no changes to etc.

# Google Chrome
msg="BCE: Installing google chrome..."
echo "$msg"
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > \
	/etc/apt/sources.list.d/google-chrome.list && \
curl -L https://dl-ssl.google.com/linux/linux_signing_key.pub | \
	apt-key add - && \
apt-get update > /dev/null && \
apt-get -y install google-chrome-stable && \
echo DONE: $msg  || echo FAIL: $msg
# XXX - maybe we should just use Chromium? Did we get a request to do otherwise?
# Personally, I'd prefer to just stick with the default Firefox.
# Also - if you haven't run Chrome yet, ipython notebook won't give the
# option

# R, RStudio
msg="BCE: Installing RStudio..."
echo "$msg"
# XXX - Using Packer, we could just put extra scripts in Packer's json config
# But this needs to be refactored
# XXX - Also, couldn't we just hard-code a URL?
if [ "${BCE_PROVISION}" != "DLAB" ]; then
    RSTUDIO_URL=`python /vagrant/getrstudio`
else
    RSTUDIO_URL=`python /tmp/getrstudio`
fi && \
curl -L -O ${RSTUDIO_URL} && \
dpkg -i $(basename ${RSTUDIO_URL}) && \
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

# XXX - Output here is also currently very verbose, maybe we should make pip
# more quiet?  More importantly, we should probably use the requirements file
# approach, and include version numbers
# XXX - Currently boilerpipe complains about lack of Java - we should probably
# install java (and perhaps scala - though that seems less necessary for JVM
# language)
msg="BCE: Installing Python modules..."
echo "$msg"
for p in ${PIPS} ; do \
	printf "%20s =========================================\n" "${p}"
	pip install --upgrade "${p}" 2>/tmp/pip-err-${p}.log | \
		tee /tmp/pip-out-${p}.log
done && \
echo DONE: $msg || echo FAIL: $msg
# XXX - pip won't change /etc

# XXX This currently errors out with
# update-alternatives: error: no alternatives for x-session-manager
msg="BCE: Setting Xfce4 as default X session"
echo "$msg"
update-alternatives --set x-session-manager /usr/bin/xfce4-session && \
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

msg="BCE: Hide boot messages"
echo "$msg"
sed -i \
	-e '/GRUB_HIDDEN_TIMEOUT=/s/^#//' \
	-e '/^GRUB_CMDLINE_LINUX_DEFAULT=""/s/""/"quiet splash"/' \
	/etc/default/grub && \
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

msg="BCE: Disable sudo password for those in the sudo group"
echo "$msg"
printf "%%sudo\tALL=(ALL:ALL) NOPASSWD: ALL\n" > /etc/sudoers.d/nopasswd && \
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

# XXX - we should also set sensible defaults for gedit
msg="BCE: Set a 4-space tabstop for nano"
echo "$msg"
sed -i -e '/# set tabsize 8/s/.*/set tabsize 4/' /etc/nanorc && \
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

msg="BCE: Create oski user"
echo "$msg"
(
  if [ "${BCE_PROVISION}" != "DLAB" ]; then
      # XXX Get explanation from Ryan
      adduser --gecos "" --disabled-password oski && echo oski:oski | chpasswd
      # Enable oski to sudo without a password
      adduser oski sudo
  fi
  # XXX - need to create this group in Packer setup, and then do the steps
  # below? I think maybe just didn't happen because of guest extension failure
  # Enable oski to mount shared folders
  adduser oski vboxsf
  # XXX - This group doesn't exist
  # Enable oski to login without a password
  # adduser oski nopasswdlogin
) && \
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

msg="BCE: Configure oski desktop"
echo "$msg"
(
    # Create a convenient place on the desktop for people to mount
    # their Shared Directories.
    sudo -u oski mkdir /home/oski/Desktop
    sudo -u oski ln -s /media /home/oski/Desktop/Shared

    # Fetch and install Xfce configuration
    # - change desktop background from image to solid color
    # - panel launcher for terminal, file manager, browser, gedit
    # - remove desktop icon for Trash, File System; leave Home
    # - change Application Menu widget to use a generic computer icon from
    #   whatever it is that XFCE uses.
    # - Benoit prefers black-on-white terminal; easier to see on projectors

    # ~/.config already exists if oski is created by debian installer
    # And we use a file provisioner to copy our xfce4 files directly there
    # Packer file provisioner copies those files directly to .config
    if [ "${BCE_PROVISION}" != "DLAB" ]; then
        sudo -u oski mkdir /home/oski/.config
        sudo -u oski rsync -av /vagrant/dot-config/xfce4 /home/oski/.config/
    fi
) && \
echo DONE: $msg || echo FAIL: $msg

# Automatically login oski at boot
msg="BCE: Automatically login oski at boot"
echo "$msg"
printf "[SeatDefaults]\nautologin-user=oski\nautologin-user-timeout=0\n" >> \
	/etc/lightdm/lightdm.conf.d/20-BCE.conf && \
	#/usr/lib/lightdm/lightdm-set-defaults --autologin oski
( echo DONE: $msg ; etckeeper commit "$msg" ) || echo FAIL: $msg

# Clean up the image before we export it
apt-get clean
END_TIME=$(date '+%s')

ELAPSED_SECS=$((END_TIME-START_TIME))
printf "Elapsed time: %s minutes\n" $((ELAPSED_SECS/60))
