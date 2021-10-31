# FAT12

FAT12(**F**ile **A**llocation **T**able) file system remains in use on all common floppy disks, including 1.44 MB and later 2.88 MB disks. 1.44 MB FAT12 will be described on this page.

1.44 MB floppy disk has 2880 sectors，one sectors is 512 bytes.

The FAT12 file system divides 2880 sectors into 5 parts:

```txt

  +-----+------------+------------+----------------+-------------------~~~~~+
  | MBR | FAT1 table | FAT2 table | Root Directory |       Data Area        |
  +-----+------------+------------+----------------+-------------------~~~~~+
  |  0  | 1        9 | 10      18 | 19          32 | 33                2879 |
```



## 1. MBR

MBR(Master Boot Record, aka Boot Section)

Note: BS(Boot Sector)，BPB(BIOS Paramter Block)

The following data is used in the MuOS project:

|          Name           | Start(byte) | Length(bytes) |                        Content                        |
| :---------------------: | :---------: | :-----------: | :---------------------------------------------------: |
|      `BS_JmpBoot`       |      0      |       3       |                     Jump to boot                      |
|      `BS_OEMName`       |      3      |       8       |        Original Equipment Manufacturer("...")         |
|  `BPB_BytesPerSector`   |     11      |       2       |                 Bytes per sector(512)                 |
| `BPB_SectorPerCluster`  |     13      |       1       |                Sectors per cluster(1)                 |
| `BPB_NumReservedSector` |     14      |       2       |          Number of reserved sectors(1, MBR)           |
|      `BPB_NumFATs`      |     16      |       1       |                Number of FAT tables(2)                |
|   `BPB_NumRootEntry`    |     17      |       2       |     Maximum number of root directory entries(224)     |
|   `BPB_TotalSector16`   |     19      |       2       |               Total sector count(2880)                |
|       `BPB_Media`       |     21      |       1       |                Media descriptor(0xF0)                 |
|     `BPB_FATSize16`     |     22      |       2       |                  Sectors per FAT(9)                   |
|  `BPB_SectorPerTrack`   |     24      |       2       |                 Sectors per track(18)                 |
|     `BPB_NumHeads`      |     26      |       2       |                  Number of heads(2)                   |
|    `BPB_HideSector`     |     28      |       4       |                    Hide Sector(0)                     |
|   `BPB_TotalSector32`   |     32      |       4       |            Total sector count for FAT32(0)            |
|      `BS_DriverID`      |     36      |       1       |       Driver number ID(int 13h, 0x0 for floppy)       |
|     `BS_Reserved1`      |     37      |       1       | Unused(0x0, Flags in Windows NT. Reserved otherwise.) |
|   `BS_BootSignature`    |     38      |       1       |                 Boot signature(0x29)                  |
|      `BS_VolumeID`      |     39      |       4       |                    Volume ID(0x0)                     |
|    `BS_VolumeLabel`     |     43      |      11       |              Volume label("boot loader")              |
|   `BS_FileSystemType`   |     54      |       8       |               File system type("FAT12")               |
|        BootCode         |     62      |      448      |                 Boot code, data, etc.                 |
|           End           |     510     |       2       |          Bootable partition signature 0xAA55          |





## 2. FAT Table

FAT1 and FAT2 are the same. The purpose of the FAT2 table is to repair the FAT1 table. Therefore, the FAT1 table can be assigned to FAT2 when the machine is shutdown.

FAT table is similar to an **array** and **each entry** in the FAT corresponds to a **cluster** of data on the disk. FAT table entry ID <=> cluster ID.

FAT12 table each entry is 12 bits (1.5 bytes). Also FAT16 is 16 bits(2 bytes). A FAT table has $512*9$​ bytes(4608 bytes).

Therefore, FAT12 has a maximum of 4608 / 1.5 = 3072 clusters.

`FAT[i]` represents the i-th entry in the FAT table.  The values of `FAT[0]` and `FAT[1]` are 0xFF0 and 0xFFF, but usually these two values will not be tested.

FAT entry values signify the following:

|    Value    |                           Meaning                            |
| :---------: | :----------------------------------------------------------: |
|     0x0     |                            Unused                            |
| 0xFF0-0xFF6 |                       Reserved cluster                       |
|    0xFF7    |                         Bad cluster                          |
| 0xFF8-0xFFF |                    Last cluster in a file                    |
|    else     | Number of the next cluster in the file (just like linked list) |



For the FAT12 system, the first 33 sectors are predefined. And `FAT[0]` and `FAT[1]` are reserved, it is entry 2 of the FAT that actually contains the description for physical sector number 33.

THEREFORE, **physical sector number = 33 + FAT entry number - 2**



## 3. Directories

Directories (such as the root directory) exist like files on the disk, in that they occupy one or more sectors.

Each sector of a directory contains 16 directory entries (each of which is 32 bytes long).

Each directory entry contains the following information about the file or subdirectory to which it points:

|        Name         | Offset | Length |
| :-----------------: | :----: | :----: |
|        Name         |   0    |   8    |
|      Extension      |   8    |   3    |
|     Attributes      |   11   |   1    |
|      Reserved       |   12   |   2    |
|     CreateTime      |   14   |   2    |
|     CreateDate      |   16   |   2    |
|   LastAccessDate    |   18   |   2    |
|       Ignore        |   20   |   2    |
|    LastWriteTime    |   22   |   2    |
|    LastWriteDate    |   24   |   2    |
| FirstLogicalCluster |   26   |   2    |
| FileSize(in bytes)  |   28   |   4    |

Notes:

- If the first byte of the Filename field is 0xE5, then the directory entry is free (i.e., currently unused).
- If the first byte of the Filename field is 0x00, then this directory entry is free and all the remaining directory entries in this directory are also free



Attributes:

|  Attribute   | Mask |
| :----------: | :--: |
|  Read only   | 0x01 |
|    Hidden    | 0x02 |
|    System    | 0x04 |
| Volume label | 0x08 |
| Subdirectory | 0x10 |
|   Archive    | 0x20 |



# References

[FAT12 Description](https://www.eit.lth.se/fileadmin/eit/courses/eitn50/Literature/fat12_description.pdf)

[FAT12 Github repo](https://github.com/qihaiyan/fat12)

[osdev_FAT](https://wiki.osdev.org/FAT)

