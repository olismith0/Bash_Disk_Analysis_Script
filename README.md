# Bash Disk Analysis Script
This is a bash disk analysis script that i was tasked to create in my first year of studying Computer Networks And Cyber Security. The Purpose of the Script is to scrape all data from a mounted disk image. 

---
## Setup
To run this script in a Linux enviroment you use the following commands to:

To Create a directory for us to use the script in. To Copy the script to the /bin folder in the new directory we have made. To give the copied script execute privileges. For this assignment, i had to use, w20000418 and kf4005 as directory names. 
```sh 
$ sudo mkdir -p w20000418/kf4005/bin 

$ sudo cp disk_analysis.sh w20000418/kf4005/bin/

$ sudo chmod +x w20000418/kf40005/bin/disk_analysis.sh
```
Next we have to copy the .img file that we would like to  analyse into the kf4005/ directory. 
```sh 
$ sudo cp KF4005.img w20000418/kf4005/
```
Now we have to create a mountpoint directory to mount the .img file onto. And then mount the image with the offset: 1048576
```sh 
$ sudo mkdir w20000418/kf4005/image
$ sudo mount -o loop,offset=1048576 KF4005.img image
```
---

## Execution

Finally we can run the script using:

```sh 
sudo disk_analysis.sh -n
```
After running the script a number of things will happen. A Extracted data directory will be created. The raw extracted data will be piped into filedata.txt and a sql database will be initalised with mysql. A formatted .txt will be produced from the database, named sqlout.txt .

---
# Author
Name: Oli Smith

University Email: w20000418@northumbria.ac.uk

University ID: w20000418
