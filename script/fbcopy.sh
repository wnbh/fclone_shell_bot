#!/bin/bash
#=============================================================
# https://github.com/cgkings/fclone_shell_bot
# File Name: fbtask.sh
# Author: cgking
# Created Time : 2020.7.8
# Description:全盘备份-task
# System Required: Debian/Ubuntu
# Version: final
#=============================================================

source /root/fclone_shell_bot/myfc_config.ini

clear
echo -e " 选择你需要备份的盘
[1]. "$pan1_name"
[2]. "$pan2_name"
[3]. "$pan3_name"
[4]. 退出"
read -p "请输入数字 [1-4]:" num
case "$num" in
1)
    echo -e "★★★ 1#"$pan1_name" ★★★"
    myid="$pan1_id"
    ;;
2)
    echo -e "★★★ 2#"$pan2_name" ★★★"
    myid="$pan2_id"
    ;;
3)
    echo -e "★★★ 3#"$pan3_name" ★★★"
    myid="$pan3_id"
    ;;
4)
    exit
    ;;
*)
    echo -e "请输入正确的数字"
    exit
    ;;
esac
read -p "请输入备份到盘ID==>" link
if [ -z "$link" ] ; then
echo "不允许输入为空" && exit
else
link=${link#*id=};link=${link#*folders/};link=${link#*d/};link=${link%?usp*}
fi
echo -e "▣▣▣▣▣▣执行备份▣▣▣▣▣▣"
fclone copy "$fclone_name":{$myid} "$fclone_name":{$link} --drive-server-side-across-configs --stats=1s --stats-one-line -P --checkers="$fb_chercker" --transfers="$fb_transfer" --drive-pacer-min-sleep="$fb_min_sleep"ms --drive-pacer-burst="$fb_BURST" --min-size "$fb_min_size"M --check-first --ignore-existing --log-level=ERROR --log-file=/root/fclone_shell_bot/log/fbcopy.log
echo -e "|▉▉▉▉▉▉▉▉▉▉▉▉|100%  备份完毕"
echo -e "▣▣▣▣▣▣执行同步▣▣▣▣▣▣"
fclone sync "$fclone_name":{$myid} "$fclone_name":{$link} --drive-server-side-across-configs --drive-use-trash=false --stats=1s --stats-one-line -P --checkers="$fb_chercker" --transfers="$fb_transfer" --drive-pacer-min-sleep="$fb_min_sleep"ms --drive-pacer-burst="$fb_BURST" --min-size "$fb_min_size"M --check-first --log-level=ERROR --log-file=/root/fclone_shell_bot/log/fbsync.log
echo -e "|▉▉▉▉▉▉▉▉▉▉▉▉|100%  同步完毕"
exit
