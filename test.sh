# Go ahead and keep all the files up to date
apk --no-cache update

# Delete some utilities that IF we wind up needing, will be pulled in as dependencies later
apk --no-cache --purge del libc-dev libc-utils scanelf pax-utils

# Delete some Alpine base packages that ultimately add empty folders and some non-essential files
# I doubt these files will much ever be needed, and if they wind up being needed, revisions can be made
apk --no-cache --no-scripts --purge del alpine-baselayout alpine-baselayout-data

# Delete the Root file directory, since in Docker it is never needed
rm -rf /root

# Here I deleted some stuff from /etc that ultimately serves minimal purpose inside Docker. I did minor testing abd found
# No issues with these files removed - Networking and APK still function as expected, probably since Docker forcibly handles
# Many of the things these files would normally handle otherwise. I also removed identifier files to not only slim this down
# Further but to potentially cut down on possible unwanted data revealing what distro is running to prevent possible exploits.
rm -rf /etc/logrotate.d /etc/os-release /etc/alpine-release /etc/busybox-paths.d /etc/secfixes.d /etc/udhcpc /etc/udhcpd.conf /etc/issue

# Here we are just resetting some /var folders to ensure they are empty after everything is done. These specific files are
# Regularly removed to save space and in theory shouldn't have anything in them in the first place. This is just a double-check.
# Deleting all of /var may feel pretty nuclear but ultimately it's not much different than running 3 commands to empty it.
rm -rf /var
mkdir /var

# Remove /usr/local since the folders are normally empty
rm -rf /usr/local

# I also want to go ahead and move all commands that don't already exist into one part of the PATH instead of segmenting them
mv -n /usr/bin/* /bin/
mv -n /usr/sbin/* /sbin/
mv -n /usr/lib/* /lib/
mv -n /usr/local/bin/* /bin/
mv -n /usr/local/sbin/* /sbin/
mv -n /usr/local/lib/* /lib/
mv -n /usr/lib/modules-load.d/* /lib/modules-load.d/

# And now we purge whatever is left
rm -rf /usr/bin /usr/sbin /usr/lib /usr/local

# And we have to stop APK from freaking out over the missing files - we know where they are so it is OK
# This is nuclear, but it does seemingly stop APK from getting confused later on
# It also frees up a whole fraction of a kilobyte so it's great for minimalism!
rm -rf /lib/apk/db/triggers
touch /lib/apk/db/triggers

# Go ahead and run any final updates needed
apk --no-cache --purge upgrade

# du -Hhad 1 /