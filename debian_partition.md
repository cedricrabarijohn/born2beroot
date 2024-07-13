# Debian Partition Setup

## Create a new VM

Use Oracle VM:

- Open ```Oracle VM VirtualBox Manager``` on 42 pc linux
- Click on ```New```

A new window will pop-up:

- Name the VM: ```born2beroot```
- Select a folder with enough space: ```/home/user/goinfre/VMs```
- Leave the ```ISO Image``` untouched
- Type: ```Linux```
- Version: ```Debian (64-bit)```
- Click ```Next```

Hardware:

- Base Memory: ```1024 MB```
- Processors: ```1 CPU```
- DO NOT CHECK THE BOX ```Enable EFI```

Create a VHD
If you intend to complete the bonus part, ```30 GB``` is a reasonable size.

Otherwise, ```8 GB``` to ```12 GB``` should be sufficient.

## Initial Settings

- Download ```Debian ISO``` latest [here](https://www.debian.org/download)
- Select the VM you just created
- ```Ctrl + S``` to open settings
- Under ```Storage``` >> ```Controller: IDE```, select ```Empty```
- Choose a ```Virtual Optical Disk```
- Select the ```Debian ISO``` file you downloaded

DO NOT CLICK OK YET

- Under ```Network``` >> ```Adapter 1```, check ```Enable Network Adapter```
- Attached to: ```Bridged Adapter```
- Name: ```enp0sxxxx```
- Click ```OK```

## Stating VM

- Select the VM
- Click ```Start```

A new window should now open, with a user interface

- Choose ```Install```
- DO NOT CLICK ON GRAPHICAL INSTALL
- Select Language, Region, and Keymap (Default ```English```, ```USA```, ```American```)
- Hostname: ```login42``` (if your 42 username is ```login```, add ```42``` at the end, for hostname)
- Leave ```Domain name``` untouched

You will eventually be prompted to enter password. DO NOT FORGET IT.

- Setup root password

Now, it's time to create the first user (apart from ```root```)

- Full name: ```login```
- Username: ```login```
- Setup password
- Select time zone

## Creating partitions

A few seconds after the time zone selection, you will be prompted to create the partitions.

- Click ```Manual```
- Select ```SCSI2 (0,0,0) (sda) XX GB``` >>> ```Yes```
- Select ```pri/log XX GB FREE SPACE```

The subject requires to create two partitions: the first one is primary, and second one is logical.

### Primary partition
- Choose ```Create a new partition```
- Partition size: ```500 MB``` >> ```Primary``` >> ```Beginning```
- Use as: ```Ext4```
- Mount point: ```/boot```
- ```Done```

### Logical partition
- Choose ```Create a new partition```
- Partition size: ```max``` >> ```Logical```
- Use as: ```Ext4```
- Mount point: DO NOT MOUNT
- ```Done```

## Partition Configurations

Before hiting the ```Finish``` button, you need to configure the partitions:

- Select ```Configure encrypted volumes``` >> ```Yes``` >> ```Create encrypted volumes```
- Choos only ```/dev/sda5``` (hint: ```Space``` to select)
- ```Done``` >> ```Finish``` >> ```Yes```

Wait for the partition to be formatted. Once done, follow below steps:

- Step 1: Set a strong encryption password.
- Step 2: DO NOT FORGET IT.

### Logical Volumes Setup

- Select ```Configure the Logical Volume Manager``` >> ```Yes```
- Choose ```Create Volume Group```
- Name: ```LVMGroup```
- Select ```dev/mapper/sda5_crypt```

### Logical Volumes Config

Now it's time to create each part of the structure individually: root, swap, home, var, srv, tmp, var-log.

- ```Create Logical Volume``` >> ```LVMGroup``` >> Name: ```root``` >> Size: ```10G```
- ```Create Logical Volume``` >> ```LVMGroup``` >> Name: ```swap``` >> Size: ```2.3G```
- ```Create Logical Volume``` >> ```LVMGroup``` >> Name: ```home``` >> Size: ```5G```
- ```Create Logical Volume``` >> ```LVMGroup``` >> Name: ```var``` >> Size: ```3G```
- ```Create Logical Volume``` >> ```LVMGroup``` >> Name: ```srv``` >> Size: ```3G```
- ```Create Logical Volume``` >> ```LVMGroup``` >> Name: ```tmp``` >> Size: ```3G```
- ```Create Logical Volume``` >> ```LVMGroup``` >> Name: ```var-log``` >> Size: ```4G```
- Click on ```Display configuration details``` to check if everything is setup correctly
- Click ```Finish```

### LVM VG LVMGroup Config

Under ```LVM VG LVMGroup, LV home - 5 GB```

- Select ```#1        5 GB```
- Use as: ```Ext4```
- Mount point: ```/home```

Under ```LVM VG LVMGroup, LV root - 10 GB```

- Select ```#1        10 GB```
- Use as: ```Ext4```
- Mount point: ```/```

Under ```LVM VG LVMGroup, LV srv - 3 GB```

- Select ```#1        3 GB```
- Use as: ```Ext4```
- Mount point: ```/srv```

Under ```LVM VG LVMGroup, LV swap - 2.3 GB```

- Select ```#1        2.3 GB```
- Use as: ```swap area```

Under ```LVM VG LVMGroup, LV tmp - 3 GB```

- Select ```#1        3 GB```
- Use as: ```Ext4```
- Mount point: ```/tmp```

Under ```LVM VG LVMGroup, LV var - 3 GB```

- Select ```#1        3 GB```
- Use as: ```Ext4```
- Mount point: ```/var```

Under ```LVM VG LVMGroup, LV var-log - 4 GB```

- Select ```#1        4 GB```
- Use as: ```Ext4```
- Mount point: ```Enter Manually``` >> ```/var/log```

Once everything is done, click on ```Finish``` >> ```Yes``` >> ```No``` (for Scan) >> ```USA``` >> ```deb.debian.org```
Leave ```Proxy``` untouched >> ```No``` (for Survey)
Uncheck ```ALL``` options >> ```Continue``` >> ```Yes``` (for GRUB) >> ```/dev/sda```

## First VM Check

To check if everything is good, run the following commands:

```sh
lsblk
```

```sh
cat /etc/os-release
```
