#############################################################
#   File Name: fio.sh
#     Autohor: Hui Chen (c) 2019
#        Mail: chenhui13@baidu.com
# Create Time: 2019/07/05-12:33:28
#############################################################
#!/bin/sh 
disk=sfd0n1
time=3600
set -x

#先做SSD的Precondition准备，先1M顺序写1h
nohup fio --name=global --ioengine=libaio  --bs=1024k --rw=write --filename=/dev/$disk --runtime=$time --time_based --direct=1 -numjobs=1  -iodepth=32 --name=job --group_reporting &
iostat -xm $disk 5 > preconditon.log &
sleep $((time+60))
pkill iostat

# 顺序写测试1个小时：
nohup fio --name=global --ioengine=libaio  --bs=1024k --rw=write --filename=/dev/$disk --runtime=$time --time_based --direct=1 -numjobs=1  -iodepth=32 --name=job --group_reporting &
iostat -xm $disk 5 > write.log &
sleep $((time+60))
pkill iostat

# 顺序读测试1个小时：
nohup fio --name=global --ioengine=libaio  --bs=1024k --rw=read --filename=/dev/$disk --runtime=$time --time_based --direct=1 -numjobs=1  -iodepth=32 --name=job --group_reporting &

iostat -xm $disk 5 > read.log &
sleep $((time+60))
pkill iostat

# 随机写测试1个小时：
nohup fio --name=global --ioengine=libaio  --bs=4k --rw=randwrite --filename=/dev/$disk --runtime=$time --time_based --direct=1 -numjobs=4  -iodepth=32 --name=job --group_reporting &

iostat -xm $disk 5 > randwrite.log &
sleep $((time+60))
pkill iostat

# 随机读测试1个小时：
nohup fio --name=global --ioengine=libaio  --bs=4k --rw=randread --filename=/dev/$disk --runtime=$time --time_based --direct=1 -numjobs=4  -iodepth=32 --name=job --group_reporting &

iostat -xm $disk 5 > randread.log &
sleep $((time+60))
pkill iostat

# 随机写测试1个小时：
nohup fio --name=global --ioengine=libaio  --bs=16k --rw=randwrite --filename=/dev/$disk --runtime=$time --time_based --direct=1 -numjobs=4  -iodepth=32 --name=job --group_reporting &

iostat -xm $disk 5 > randwrite.log &
sleep $((time+60))
pkill iostat



#随机写：
fio -filename=/dev/sdb1 -direct=1 -iodepth 1 -thread -rw=randwrite -ioengine=psync -bs=16k -size=200G -numjobs=30 -runtime=1000 -group_reporting -name=mytest
nohup fio --name=global --ioengine=libaio  --bs=4k --rw=randwrite --filename=/dev/$disk --runtime=$time --time_based --direct=1 -numjobs=4  -iodepth=32 --name=job --group_reporting




nohup fio --name=global --ioengine=sync  --bs=4k --rw=randwrite --filename=/ssd1/chenhui/fiotest --runtime=600 -size=200G --time_based --direct=1 -numjobs=4  -iodepth=32 --name=job --group_reporting &

nohup fio --name=global --ioengine=sync  --bs=4k --rw=randwrite --filename=/home/pmem1/chenhui/fiotest --runtime=600 -size=200G --time_based --direct=1 -numjobs=4  -iodepth=32 --name=job --group_reporting &
iostat -xm pmem1 5 > randwrite.log &


#随机读：
nohup fio --name=global --ioengine=sync  --bs=4k --rw=randread --filename=/ssd1/chenhui/fiotest --runtime=600 -size=200G --time_based --direct=1 -numjobs=4  -iodepth=32 --name=job --group_reporting &

nohup fio --name=global --ioengine=sync  --bs=4k --rw=randread --filename=/home/pmem1/chenhui/fiotest --runtime=600 -size=200G --time_based --direct=1 -numjobs=4  -iodepth=32 --name=job --group_reporting &
