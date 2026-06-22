jade@MrSaturn:~/HPLaptop17MicFix$ sudo dmidecode -s system-product-name
sudo dmidecode -s baseboard-product-name
sudo dmidecode -s system-version
HP Laptop 17-cp2xxx
8DC5
Type1ProductConfigId
jade@MrSaturn:~/HPLaptop17MicFix$ grep -n "DMI_MATCH(DMI_BOARD_VENDOR, \"HP\")" \
    /usr/src/linux-source-7.0.0/sound/soc/amd/yc/acp6x-mach.c
grep: /usr/src/linux-source-7.0.0/sound/soc/amd/yc/acp6x-mach.c: No such file or directory
jade@MrSaturn:~/HPLaptop17MicFix$ lspci -nn | grep -i audio

cat /proc/asound/cards

uname -r
03:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Radeon High Definition Audio Controller [1002:1640]
03:00.5 Multimedia controller [0480]: Advanced Micro Devices, Inc. [AMD] Audio Coprocessor [1022:15e2] (rev 6f)
03:00.6 Audio device [0403]: Advanced Micro Devices, Inc. [AMD] Ryzen HD Audio Controller [1022:15e3]
 0 [Generic        ]: HDA-Intel - HD-Audio Generic
                      HD-Audio Generic at 0xc04c8000 irq 77
 1 [Generic_1      ]: HDA-Intel - HD-Audio Generic
                      HD-Audio Generic at 0xc04c0000 irq 78
 2 [acp6x          ]: acp6x - acp6x
                      HP-HPLaptop17_cp2xxx-Type1ProductConfigId-8DC5
7.0.0-22-generic
jade@MrSaturn:~/HPLaptop17MicFix$ arecord -l
**** List of CAPTURE Hardware Devices ****
card 1: Generic_1 [HD-Audio Generic], device 0: ALC236 Analog [ALC236 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 2: acp6x [acp6x], device 0: DMIC capture dmic-hifi-0 []
  Subdevices: 1/1
  Subdevice #0: subdevice #0
jade@MrSaturn:~/HPLaptop17MicFix$ 

