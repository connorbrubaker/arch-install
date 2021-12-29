# Installation instructions

## Create bootable USB media
I always have at least one machine running Linux or MacOS besides the
target machine, so the instructions included in this section are for
creating a bootable USB on one of those machines using `dd`. 

```{bash}
sudo dd bs=4M if=path/to/archlinux-version-x86_64.iso \
    of=/dev/sdx conv=fsync oflag=direct status=progress
```

To create media on Windows, using the tool [Rufus](https://rufus.ie/en/). 