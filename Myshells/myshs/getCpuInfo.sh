#!/bin/bash
#获取cpu相关信息

#processor	: 0
#vendor_id	: GenuineIntel
#cpu family	: 6
#model		: 13
#model name	: QEMU Virtual CPU version 1.5.3
#stepping	: 3
#microcode	: 0x1
#cpu MHz		: 3191.988
#cache size	: 4096 KB
#physical id	: 0
#siblings	: 1
#core id		: 0
#cpu cores	: 1
#apicid		: 0
#initial apicid	: 0
#fpu		: yes
#fpu_exception	: yes
#cpuid level	: 4
#wp		: yes
#flags		: fpu de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pse36 clflush mmx fxsr sse sse2 syscall nx lm rep_good nopl pni cx16 hypervisor lahf_lm abm
#bogomips	: 6383.97
#clflush size	: 64
#cache_alignment	: 64
#address sizes	: 39 bits physical, 48 bits virtual
#power management:
#

cat /proc/cpuinfo |grep GenuineIntel &>/dev/null  &&echo intel || echo AMD


