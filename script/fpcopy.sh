#!/bin/bash
#=============================================================
# https://github.com/cgkings/fclone_shell_bot
# File Name: fpcopy.sh
# Author: cgking
# Created Time : 2020.7.8
# Description:点对点转存
# System Required: Debian/Ubuntu
# Version: final
#=============================================================

source /root/fclone_shell_bot/myfc_config.ini
clear
read -p "【点对点模式】请输入from ID==>" link1
link1=${link1#*id=};link1=${link1#*folders/};link1=${link1#*d/};link1=${link1%?usp*}
rootname=$(fclone lsd "$fclone_name":{$link1} --dump bodies -vv 2>&1 | awk 'BEGIN{FS="\""}/^{"id/{print $8}')
if [ -z "$link1" ] ; then
echo "不允许输入为空" && exit ;
elif [ -z "$rootname" ] ; then
echo -e "读取文件夹名称出错，请反馈问题给作者,如果是全盘请用fb,此模式读不了盘名!\n" && exit ;
fi
read -p "请输入copy to ID==>" link2
link2=${link2#*id=};link2=${link2#*folders/};link2=${link2#*d/};link2=${link2%?usp*}
if [ -z "$link2" ] ; then
echo "不允许输入为空" && exit ;
fi
while ([ $contiue_chose!=y ] && [ $contiue_chose!=n ]);do
read -p "是否在目的地创建头文件夹[y/n]" contiue_chose
if [ $contiue_chose = y ];then
echo -e "▣▣▣▣▣▣执行转存▣▣▣▣▣▣"
fclone copy "$fclone_name":{$link1} "$fclone_name":{$link2}/"$rootname" --drive-server-side-across-configs --stats=1s --stats-one-line -P --checkers="$fp_chercker" --transfers="$fp_transfer" --drive-pacer-min-sleep="$fp_min_sleep"ms --drive-pacer-burst="$fp_BURST" --min-size "$fp_min_size"M --check-first --ignore-existing --log-level=ERROR --log-file=/root/fclone_shell_bot/log/fpcopy1.log
echo -e "|▉▉▉▉▉▉▉▉▉▉▉▉|100%  拷贝完毕"
exit
elif [ $contiue_chose = n ];then
echo -e "▣▣▣▣▣▣执行转存▣▣▣▣▣▣"
fclone copy "$fclone_name":{$link1} "$fclone_name":{$link2} --drive-server-side-across-configs --stats=1s --stats-one-line -P --checkers="$fp_chercker" --transfers="$fp_transfer" --drive-pacer-min-sleep="$fp_min_sleep"ms --drive-pacer-burst="$fp_BURST" --min-size "$fp_min_size"M --check-first --ignore-existing --log-level=ERROR --log-file=/root/fclone_shell_bot/log/fpcopy1.log
echo -e "|▉▉▉▉▉▉▉▉▉▉▉▉|100%  拷贝完毕"
exit
else
echo -e "只能输入y/n,请重新输入"
fi
done
