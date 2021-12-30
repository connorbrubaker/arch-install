# Installation instructions
These are instructions for installing Arch Linux on an encrypted (LVM on LUKS) system 
using UEFI. These instructions assume the system will be installed on a single disk.
The main references for these instructions are

* [Arch Linux official installation guide](https://wiki.archlinux.org/title/installation_guide)
* [Arch Linux dm-crypt guide](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system)

## Create bootable USB media
### Download an ISO
Start by downloading an official Arch Linux ISO from one of the sites
listed [here](https://archlinux.org/download/). An image can be acquired
using `curl` or `wget`, for example,

```{bash}
# curl -O https://mirror.clarkson.edu/archlinux/iso/2021.12.01/archlinux-2021.12.01-x86_64.iso
```

### Verify the downloaded image
Optionally, verify the downloaded image using the PGP signature from the 
Arch Linux site. Start by downloading the PGP signature to the same directory
as the ISO downloaded above:

```{bash}
# curl -O https://archlinux.org/iso/2021.12.01/archlinux-2021.12.01-x86_64.iso.sig
```

Then run

```{bash}
# gpg --keyserver-options auto-key-retrieve --verify archlinux-version-x86_64.iso.sig
```

### Prepare the installation media
On a Linux system, insert a USB drive at least 4GB in size. Format the disk 
with a MBR partition table and create a single partition. Format this partition
with the `ext4` file system. Copy the Arch Linux ISO to this drive using

```{bash}
# sudo dd bs=4M if=path/to/archlinux-version-x86_64.iso \
    of=/dev/sdx conv=fsync oflag=direct status=progress
```

Replace `/dev/sdx` with the path to the USB which can be found using a command 
such as `fdisk -l`. 

To create media on Windows, use [Rufus](https://rufus.ie/en/).

## Pre-installation steps
Once the USB installation media is ready, boot into it. 

### Verify the boot mode
Verify that the boot mode is UEFI by checking that the `efivars` 
directory exists:

```{bash}
# ls /sys/firmware/efi/efivars
```

### Connect to the internet
Ensure the network interface is recognized and enabled:

```{bash}
# ip link
```

If using a wireless connection, use `iwctl` to connect the wireless
interface to the network. To get an interactive prompt, start by 
executing

```{bash}
# iwctl
```

List available network devices using

```{bash}
[iwd]# device list
```

In the steps below, replace DEVICE with the name of the network
device you wish to use. Scan for available networks via

```{bash}
[iwd]# station DEVICE scan
```

then list these networks using

```{bash}
[iwd]# station DEVICE get-networks
```

Connect to the network by

```{bash}
[iwd]# station DEVICE connect SSID
```

If the network requires a passphrase, you will be prompted for it. 
Exit the interactive prompt and use the following to verify an active
connection to the network.

```{bash}
# ping -c 3 archlinux.org
```

### Update the system clock
Use the following command to ensure the system clock is accurate

```{bash}
# timedatectl set-ntp true
```

Verify the correct date and time using `timedatectl status`. 

### Set-up full system encryption
The next step is to setup full system encryption. Identify the disk
you want to encrypt and install the system to using 

```{bash}
# fdisk -l
```

Then use `fdisk /dev/sdx`, where `/dev/sdx` is the block device of
the desired disk, to create two partitions:

1. A 512MB boot partition of type `EFI System` (type code `1`). This
will be refered to as `/dev/sdx1`.
2. A partition taking up the remaining disk space. This will be the 
encrypted partition. and will be refered to as `/dev/sdx2`.

Create the LUKS encrypted container on the second partition using

```{bash}
# cryptsetup luksFormat /dev/sdx2
```

then open the container by

```{bash}
# cryptsetup open /dev/sdx2 cryptlvm
```

Create a physical volume on top of the of the container:

```{bash}
# pvcreate /dev/mapper/cryptlvm
```

Create a volume group and add the previously created physical volume
to it:

```{bash}
# vgcreate cryptlvm-vg /dev/mapper/cryptlvm
```

Create the following logical volumes within this volume group:

```{bash}
# lvcreate -L 8G cryptlvm-vg -n swap
# lvcreate -L 64G cryptlvm-vg -n root
# lvcreate -l 100%FREE cryptlvm-vg -n home
```

Format the filesystems on each volume as well as the boot partition:

```{bash}
# mkfs.ext4 /dev/cryptlvm-vg/root
# mkfs.ext4 /dev/cryptlvm-vg/home
# mkswap /dev/cryptlvm-vg/swap
# mkfs.fat -F 32 /dev/sdx1
```

Mount the partitions and enable the swap partition:

```{bash}
# mount /dev/cryptlvm-vg/root /mnt
# mkdir /mnt/home
# mount /dev/cryptlvm-vg/home /mnt/home
# swapon /dev/cryptlvm-vg/swap
# mkdir /mnt/boot
# mount /dev/sdx1 /mnt/boot
```

