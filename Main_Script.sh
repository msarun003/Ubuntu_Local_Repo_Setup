#!/bin/bash
#This Script is to Mirror Online Ubuntu LTS Repository with Local Drive.
#Script Name		: ubuntu_lts_repo.sh
#Dated 				: December 2018
#Author 			: M.S. Arun
#Email 				: msarun003@gmail.com
#Usage				: ./ubuntu_lts_repo.sh
#Last Update		: December 2018


#****************************************************************** Start of Script ********************************************************************#


export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin

web_url="archive.ubuntu.com"
base_dir="/var/www/html/yum6"

#Local Declarations.
backup_directory="/var/ubuntu_localrepo"
rm -rf "$backup_directory" > /dev/null 2>&1
/bin/mkdir -p "$backup_directory"

mkdir -p $base_dir/ubuntu_lts/ubuntu/

#Distros Declarations
distro_list=("xenial" "xenial-security" "xenial-updates" "xenial-backports" "bionic" "bionic-security" "bionic-updates" "bionic-backports")
repo_list=("main" "multiverse" "restricted" "universe")
os_bit=("binary-amd64" "binary-i386")

#Main Program
for ((i=0;i<"${#distro_list[*]}";i++)); do
distro_name="${distro_list[$i]}"
wget --mirror --no-parent --reject "*index.html*" http://$web_url/ubuntu/dists/$distro_name/ -P $base_dir/ubuntu_lts/
for ((j=0;j<"${#repo_list[*]}";j++)); do
repo_name="${repo_list[$j]}"
for ((k=0;k<"${#os_bit[*]}";k++)); do
os_bit_name="${os_bit[$k]}"
mkdir -p "$backup_directory/$distro_name/$repo_name/$os_bit_name"
wget http://$web_url/ubuntu/dists/$distro_name/$repo_name/$os_bit_name/Packages.gz -P "$backup_directory/$distro_name/$repo_name/$os_bit_name/"
gunzip "$backup_directory/$distro_name/$repo_name/$os_bit_name/Packages.gz"
grep "Filename" "$backup_directory/$distro_name/$repo_name/$os_bit_name/Packages" | awk -v full_web_url="http://$web_url" '{print full_web_url"/ubuntu/"$2}' > "$backup_directory/$distro_name/$repo_name/$os_bit_name/download_list.temp"
cat "$backup_directory/$distro_name/$repo_name/$os_bit_name/download_list.temp" | awk 'NF' | awk '{$1=$1;print}' > "$backup_directory/$distro_name/$repo_name/$os_bit_name/download_list.txt"
while read -r package_name; do
wget --mirror --no-parent --reject "*index.html*" "$package_name" -P $base_dir/ubuntu_lts/
done < "$backup_directory/$distro_name/$repo_name/$os_bit_name/download_list.txt"
done; done; done;
ln -sfn $base_dir/ubuntu_lts/$web_url/ubuntu/dists $base_dir/ubuntu_lts/ubuntu/
ln -sfn $base_dir/ubuntu_lts/$web_url/ubuntu/pool $base_dir/ubuntu_lts/ubuntu/
touch "$base_dir/ubuntu_lts"
touch "$base_dir/ubuntu_lts/ubuntu"
rm -rf "$backup_directory" > /dev/null 2>&1


#****************************************************************** End of the Script ******************************************************************#
