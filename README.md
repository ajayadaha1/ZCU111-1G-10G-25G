# ZCU111 PL 1G/10G Switching Ethernet Design HW v2022.2 SW v2023.2

## **Design Summary**

This project utilizes 1G/10G/25G Switching Ethernet Subsystem configured for GTY based device. This has been routed to the SFP cage on SFP0 for use on a ZCU111 board. System is configured to use the ZCU111 si570 at 156.25MHz.

- `eth0` is configured as 1G/10G/25G Ethernet Subsystem routed to SFP0.
- `eth1` is configured as GEM3 routed via RGMII to the on-board PHY.

---

## **Required Hardware**

- ZCU111
- DAC cable or 10G cabale SFP module
- 10G capable link partner

---

## **Build Instructions**

### **Vivado 2022.2:**

Enter the `Scripts` directory. From the command line run the following:

`vivado -source *top.tcl`

The Vivado project will be built in the `Hardware` directory.

### **Vitis**:

There is currently no baremetal Vitis support for the 1G/10G/25G IP.

### **PetaLinux 2023.2**:

Enter the `Software/PetaLinux/` directory. From the command line run the following:

`petalinux-config --get-hw-description ../../Hardware/pre-built/ --silentconfig`

followed by:

`petalinux-build`

The PetaLinux project will be rebuilt using the configurations in the PetaLinux directory. To reduce repo size, the project is shipped pre-configured, but un-built.

Once the build is complete, the built images can be found in the `PetaLinux/images/linux/`
directory. To package these images for SD boot, run the following from the `PetaLinux` directory:

`petalinux-package --boot --fsbl images/linux/zynqmp_fsbl.elf --fpga images/linux/*.bit --pmufw images/linux/pmufw.elf --u-boot --force`

Once packaged, the `BOOT.bin` and `image.ub` files (in the `PetaLinux/images/linux` directory) can be copied to an SD card, and used to boot.

---

## **Validation**
### **Kernel:**
**NOTE:** The interfaces are assigned as follows:
 - `eth0` -> 10G
 - `eth1` -> 1G - PS GEM
```
PetaLinux:/home/petalinux# ifconfig
eth0      Link encap:Ethernet  HWaddr F6:A7:6C:88:AB:C6  
          inet6 addr: fe80::f4a7:6cff:fe88:abc6/64 Scope:Link
          UP BROADCAST RUNNING  MTU:1500  Metric:1
          RX packets:12 errors:0 dropped:0 overruns:0 frame:0
          TX packets:12 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:1944 (1.8 KiB)  TX bytes:1944 (1.8 KiB)

eth1      Link encap:Ethernet  HWaddr BA:9A:D8:7C:14:6F  
          inet addr:10.10.70.2  Bcast:10.10.70.255  Mask:255.255.255.0
          inet6 addr: fe80::b89a:d8ff:fe7c:146f/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:8 errors:0 dropped:0 overruns:0 frame:0
          TX packets:25 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:1408 (1.3 KiB)  TX bytes:2902 (2.8 KiB)
          Interrupt:45 

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:82 errors:0 dropped:0 overruns:0 frame:0
          TX packets:82 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:6220 (6.0 KiB)  TX bytes:6220 (6.0 KiB)


PetaLinux:/home/petalinux# ifconfig eth0 192.168.1.2
PetaLinux:/home/petalinux# ping -A -q -w 3 -I eth0 192.168.1.1 
PING 192.168.1.1 (192.168.1.1): 56 data bytes



--- 192.168.1.1 ping statistics ---
45914 packets transmitted, 45914 packets received, 0% packet loss
round-trip min/avg/max = 0.054/0.064/0.261 ms

```
### **Performance:**
**NOTE:** These are rough performance numbers - your actual performance may vary based on a variety of factors such as network topology and kernel load.

These performance numbers reflect an MTU of 1500.
```
PetaLinux:/home/petalinux# iperf3 -c 192.168.1.1 -I eth0        
Connecting to host 192.168.1.1, port 5201
[  5] local 192.168.1.2 port 35132 connected to 192.168.1.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   108 MBytes   902 Mbits/sec   16    361 KBytes       
[  5]   1.00-2.00   sec   101 MBytes   848 Mbits/sec    0    399 KBytes       
[  5]   2.00-3.00   sec   107 MBytes   895 Mbits/sec   10    390 KBytes       
[  5]   3.00-4.00   sec   109 MBytes   918 Mbits/sec    5    331 KBytes       
[  5]   4.00-5.00   sec   110 MBytes   920 Mbits/sec    2    378 KBytes       
[  5]   5.00-6.00   sec   102 MBytes   857 Mbits/sec    8    378 KBytes       
[  5]   6.00-7.00   sec   106 MBytes   892 Mbits/sec   12    372 KBytes       
[  5]   7.00-8.00   sec   108 MBytes   905 Mbits/sec   17    290 KBytes       
[  5]   8.00-9.00   sec   105 MBytes   883 Mbits/sec    0    431 KBytes       
[  5]   9.00-10.00  sec   107 MBytes   895 Mbits/sec   45    376 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.04 GBytes   891 Mbits/sec  115             sender
[  5]   0.00-10.00  sec  1.04 GBytes   889 Mbits/sec                  receiver

iperf Done.

```
---

## **Known Issues**

---
