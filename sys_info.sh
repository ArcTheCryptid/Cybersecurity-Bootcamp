#!/bin/bash


# Variables
output=$HOME/research/sys_info.sh
ip=$(ip addr | head -9 | tail -1 )

# Prevent users from using this script with Sudo.
if  [ $UID -eq 0 ]
then
 echo "Error: Please do not run this script using sudo."
 exit
fi

# If research directory not present in home folder, make one
if [ ! -d $HOME/research ]
then
 mkdir $HOME/research
fi

# A Quick System Audit that displays date, mach type, username, IP, Hostname, DNS servers, Mem info, CPU info, Disk usage, who's logged in, Exe files, 777 files, and the top 10 memory using processes.
echo "A Quick System Audit Script" > $output
date >> $output
echo "" >> $output
echo "Machine Type Info: " >> $output
echo $MACHTYPE >> $output
echo -e "\n Uname info: $(uname -a) \n" >> $output
echo -e "IP Info:" $ip \n >> $output
echo "Hostname: $(hostname -s) " >> $output
echo "" >> $output
echo "DNS Servers: " >> $output
cat /etc/resolv.conf | head -8 | tail -3 >> $output
echo -e "/nMemory Info:" >> $output
free >> $output
echo -e  "\nCPU Info: " >> $output
lscpu | grep CPU >> $output
echo -e "\nDisk Usage:" >> $output
df -H | head -2 >> $output
echo -e "\nWho is logged in: \n $(who) \n" >> $output
echo -e "\nExecutable Files:" >> $output
echo -e "\n777 Files:" >> $output
find / -type f -perm 777 2>/dev/null >> $output
echo -e "\nTop 10 Processes" >> $output
ps aux -m | awk {'print $1, $2, $3, $4, $11'} | head >> $output


path=('/etc/shadow' '/etc/passwd')

for file in ${path[@]}
  do
    if [ $file == '/etc/shadow' ] || [ $file == '/etc/passwd' ];
    then
      ls -l  $file >> $output
    fi
  done
