# Installation instructions
These are instructions for installing Arch Linux on an encrypted system 
(using LVM on LUKS) using UEFI. The main references for these instructions
are

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

In the steps below, replace *device* with the name of the network
interface you wish to use. Scan for available networks via

```{bash}
[iwd]# station *device* scan
```

then list these networks using

```{bash}
[iwd]# station *device* get-networks
```

Connect to the network by

```{bash}
[iwd]# station *device* connect *SSID*
```

If the network requires a passphrase, you will be prompted for it. 
Exit the interactive prompt and use the following to verify an active
connection to the network.

```{bash}
# ping -c 3 archlinux.org
```

### Update the system clock