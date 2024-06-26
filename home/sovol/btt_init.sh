#!/bin/bash

sudo chown sovol:sovol /home/sovol/ -R
# sudo ntpdate stdtime.gov.hk

cd /boot/gcode
if ls *.gcode > /dev/null 2>&1;then
    sudo cp ./*.gcode /home/sovol/printer_data/gcodes -fr
    sudo rm ./*.gcode -fr
fi
sync

cd /boot/scripts

#./extend_fs.sh &

./system_cfg.sh &

./connect_wifi.sh &

./auto_setmcu_id.sh &

#./file_change_save.sh &

# regular sync to prevent data loss when direct power outage
#./sync.sh &
