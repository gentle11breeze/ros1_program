#!/bin/bash

echo  'KERNEL=="ttyACM*", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5802", MODE:="0666", GROUP:="dialout",  SYMLINK+="move_base"' >/etc/udev/rules.d/move_base.rules

systemctl daemon-reload
service udev reload
sleep 1
service udev restart
