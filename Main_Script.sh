#!/bin/bash
#This Script is to Mirror Online Ubuntu LTS Repository with Local Drive.
#Script Name	: ubuntu_lts_repo.sh
#Dated 			  : December 2018
#Author 		  : M.S. Arun
#Email 			  : amsarun003@gmail.com
#Usage			  : ./ubuntu_lts_repo.sh
#Last Update	: December 2018


#****************************************************************** Start of Script ********************************************************************#


export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin

#Local Declarations.
backup_directory="/var/ubuntu_localrepo"
rm -rf "$backup_directory" > /dev/null 2>&1
/bin/mkdir -p "$backup_directory"

mkdir -p /var/www/html/yum6/ubuntu_lts/ubuntu/

distro_list=("trusty" "trusty-security" "trusty-updates" "xenial" "xenial-security" "xenial-updates" "bionic" "bionic-security" "bionic-updates")
repo_list=("main" "multiverse" "restricted" "universe")

for ((i=0;i<"${#distro_list[*]}";i++)); do
distro_name="${distro_list[$i]}"
wget --mirror --no-parent --reject "*index.html*" http://archive.ubuntu.com/ubuntu/dists/$distro_name/ -P /var/www/html/yum6/ubuntu_lts/
for ((j=0;j<"${#repo_list[*]}";j++)); do
repo_name="${repo_list[$j]}"
mkdir -p "$backup_directory/$distro_name/$repo_name"
wget http://archive.ubuntu.com/ubuntu/dists/$distro_name/$repo_name/binary-amd64/Packages.gz -P "$backup_directory/$distro_name/$repo_name/"
wget http://archive.ubuntu.com/ubuntu/dists/$distro_name/$repo_name/binary-i386/Packages.gz -P "$backup_directory/$distro_name/$repo_name/"
gunzip "$backup_directory/$distro_name/$repo_name/Packages.gz"
grep "Filename" "$backup_directory/$distro_name/$repo_name/Packages" | awk '{print "http://archive.ubuntu.com/ubuntu/"$2}' > "$backup_directory/$distro_name/$repo_name/download_list.temp"
cat "$backup_directory/$distro_name/$repo_name/download_list.temp" | awk 'NF' | awk '{$1=$1;print}' > "$backup_directory/$distro_name/$repo_name/download_list.txt"
while read -r package_name; do
wget --mirror --no-parent --reject "*index.html*" "$package_name" -P /var/www/html/yum6/ubuntu_lts/
done < "$backup_directory/$distro_name/$repo_name/download_list.txt"
done; done;
ln -sfn /var/www/html/yum6/ubuntu_lts/archive.ubuntu.com/ubuntu/dists /var/www/html/yum6/ubuntu_lts/ubuntu/
ln -sfn /var/www/html/yum6/ubuntu_lts/archive.ubuntu.com/ubuntu/pool /var/www/html/yum6/ubuntu_lts/ubuntu/
rm -rf "$backup_directory" > /dev/null 2>&1


#****************************************************************** End of the Script ******************************************************************#