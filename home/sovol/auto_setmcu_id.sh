#!/bin/bash

# 定义 Klipper 配置文件的路径
KLIPPER_CONFIG="/home/sovol/printer_data/config/printer.cfg"
KLIPPER_CONFIG_BAK="/home/sovol/patch/config/printer.cfg"

# 获取 /dev/serial/by-id/ 下的设备列表
DEVICES=($(ls /dev/serial/by-id/))

# 检查是否有足够的设备
if [ ${#DEVICES[@]} -lt 2 ]; then
    echo "找不到足够的串行设备。"
    exit 1
fi

# 获取第一个和第二个设备的完整路径
FIRST_DEVICE_PATH=""
SECOND_DEVICE_PATH=""

# 确定ttyACM1和ttyACM0的路径  
for DEVICE in "${DEVICES[@]}"; do  
    TARGET=$(readlink "/dev/serial/by-id/$DEVICE")  
    if [[ $TARGET == *ttyACM1 ]]; then  
        FIRST_DEVICE_PATH="/dev/serial/by-id/$DEVICE"  
    elif [[ $TARGET == *ttyACM0 ]]; then  
        SECOND_DEVICE_PATH="/dev/serial/by-id/$DEVICE"  
    fi  
done 

# 更新 printer.cfg 文件
# 为 [mcu] 部分
sed -i "/^\[mcu\]/,/^\[/s#serial:.*#serial: $FIRST_DEVICE_PATH#" $KLIPPER_CONFIG

sed -i "/^\[mcu\]/,/^\[/s#serial:.*#serial: $FIRST_DEVICE_PATH#" $KLIPPER_CONFIG_BAK

# 为 [mcu extra_mcu] 部分
sed -i "/^\[mcu extra_mcu\]/,/^\[/s#serial:.*#serial: $SECOND_DEVICE_PATH#" $KLIPPER_CONFIG

sed -i "/^\[mcu extra_mcu\]/,/^\[/s#serial:.*#serial: $SECOND_DEVICE_PATH#" $KLIPPER_CONFIG_BAK

echo "配置文件已更新。"
