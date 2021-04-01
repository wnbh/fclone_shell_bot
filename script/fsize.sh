#!/bin/bash
#=============================================================
# https://github.com/cgkings/fclone_shell_bot
# File Name: fsize.sh
# Author: cgking
# Created Time : 2020.7.8
# Description:size查询
# System Required: Debian/Ubuntu
# Version: final
#=============================================================

source /root/fclone_shell_bot/myfc_config.ini

#三种模式，在myfc_config.ini中选择size_mode
#其中：1#，ls基础模式，2#，ls列表模式，3#，size基础模式, 4 #size列表模式
read -p "请输入查询链接==>" link
link=${link#*id=};link=${link#*folders/};link=${link#*d/};link=${link%?usp*}
rootname=$(fclone lsd "$fclone_name":{$link} --disable listR --dump bodies -vv 2>&1 | awk 'BEGIN{FS="\""}/^{"id/{print $8}')
if [ -z "$link" ] ; then
echo "不允许输入为空" && exit ;
fi
#1号，ls基础模式
size_mode_num_simple() {
    file_num=$(fclone ls "$fclone_name":{$link} --disable listr --stats=1s --stats-one-line -vP --checkers="$fs_chercker" --transfers="$fs_transfer" --drive-pacer-min-sleep="$fs_min_sleep" --drive-pacer-burst="$fs_BURST" --check-first | wc -l)
    folder_num=$(fclone lsd "$fclone_name":{$link} --disable listr --stats=1s --stats-one-line -vP --checkers="$fs_chercker" --transfers="$fs_transfer" --drive-pacer-min-sleep="$fs_min_sleep" --drive-pacer-burst="$fs_BURST" --check-first | wc -l)
    echo -e "▣▣▣▣▣▣▣▣查询信息▣▣▣▣▣▣▣▣\n"
    echo -e "┋ 资源名称 ┋:$rootname \n"
    echo -e "┋ 文件数量 ┋:$file_num \n"
    echo -e "┋ 文件夹数 ┋:$folder_num \n"
    echo -e "┋   总计   ┋:$[file_num+folder_num] \n"
}
#2号，ls列表模式
size_mode_num() {
    file_num0=$(fclone ls "$fclone_name":{$link} --disable listr --stats=1s --stats-one-line -vP --checkers="$fs_chercker" --transfers="$fs_transfer" --drive-pacer-min-sleep="$fs_min_sleep" --drive-pacer-burst="$fs_BURST" --check-first | wc -l)
    file_num1=$(fclone ls "$fclone_name":{$link} --include "*.{avi,mpeg,wmv,mp4,mkv,rm,rmvb,3gp,mov,flv,vob}" --ignore-case --disable listr --stats=1s --stats-one-line -vP --checkers="$fs_chercker" --transfers="$fs_transfer" --drive-pacer-min-sleep="$fs_min_sleep" --drive-pacer-burst="$fs_BURST" --check-first | wc -l)
    file_num2=$(fclone ls "$fclone_name":{$link} --include "*.{png,jpg,jpeg,gif,webp,tif}" --ignore-case --disable listr --stats=1s --stats-one-line -vP --checkers="$fs_chercker" --transfers="$fs_transfer" --drive-pacer-min-sleep="$fs_min_sleep" --drive-pacer-burst="$fs_BURST" --check-first | wc -l)
    file_num3=$(fclone ls "$fclone_name":{$link} --include "*.{html,htm,txt,pdf,nfo}" --ignore-case --disable listr --stats=1s --stats-one-line -vP --checkers="$fs_chercker" --transfers="$fs_transfer" --drive-pacer-min-sleep="$fs_min_sleep" --drive-pacer-burst="$fs_BURST" --check-first | wc -l)
    echo -e "资源名称："$rootname""
    echo -e "--------------"
    printf "|%-5s|%-8s|\n" 类型 文件数量
    echo -e "--------------"
    printf "|%-5s|%-8s|\n" 视频 "$file_num1"
    echo -e "--------------"
    printf "|%-5s|%-8s|\n" 图片 "$file_num2"
    echo -e "--------------"
    printf "|%-5s|%-8s|\n" 文本 "$file_num3"
    echo -e "--------------"
    printf "|%-5s|%-8s|\n" 合计 "$file_num0"
    echo -e "--------------"
}
#3号，size基础模式
size_mode_simple() {
    size_info=`fclone size "$fclone_name":{$link} --disable listr --stats=1s --stats-one-line --checkers="$fs_chercker" --transfers="$fs_transfer" --drive-pacer-min-sleep="$fs_min_sleep" --drive-pacer-burst="$fs_BURST" --check-first`
    file_num=$(echo "$size_info" | awk 'BEGIN{FS=" "}/^Total objects/{print $3}')
    file_size=$(echo "$size_info" | awk 'BEGIN{FS=" "}/^Total size/{print $3,$4}')
    echo -e "▣▣▣▣▣▣▣▣查询信息▣▣▣▣▣▣▣▣\n"
    echo -e "┋资源名称┋:$rootname \n"
    echo -e "┋资源数量┋:$file_num \n"
    echo -e "┋资源大小┋:$file_size \n"
}
#4号，size列表模式
size_mode_fully() {
    size_info0=`fclone size "$fclone_name":{$link} --disable listr --stats=1s --stats-one-line --checkers="$fs_chercker" --transfers="$fs_transfer" --drive-pacer-min-sleep="$fs_min_sleep" --drive-pacer-burst="$fs_BURST" --check-first`
    file_num0=$(echo "$size_info0" | awk 'BEGIN{FS=" "}/^Total objects/{print $3}')
    file_size0=$(echo "$size_info0" | awk 'BEGIN{FS=" "}/^Total size/{print $3,$4}')
    size_info1=`fclone size "$fclone_name":{$link} --include "*.{avi,mpeg,wmv,mp4,mkv,rm,rmvb,3gp,mov,flv,vob}" --ignore-case --disable listr --stats=1s --stats-one-line --checkers="$fs_chercker" --transfers="$fs_transfer" --drive-pacer-min-sleep="$fs_min_sleep" --drive-pacer-burst="$fs_BURST" --check-first`
    file_num1=$(echo "$size_info1" | awk 'BEGIN{FS=" "}/^Total objects/{print $3}')
    file_size1=$(echo "$size_info1" | awk 'BEGIN{FS=" "}/^Total size/{print $3,$4}')
    size_info2=`fclone size "$fclone_name":{$link} --include "*.{png,jpg,jpeg,gif,webp,tif}" --ignore-case --disable listr --stats=1s --stats-one-line --checkers="$fs_chercker" --transfers="$fs_transfer" --drive-pacer-min-sleep="$fs_min_sleep" --drive-pacer-burst="$fs_BURST" --check-first`
    file_num2=$(echo "$size_info2" | awk 'BEGIN{FS=" "}/^Total objects/{print $3}')
    file_size2=$(echo "$size_info2" | awk 'BEGIN{FS=" "}/^Total size/{print $3,$4}')
    size_info3=`fclone size "$fclone_name":{$link} --include "*.{html,htm,txt,pdf,nfo}" --ignore-case --disable listr --stats=1s --stats-one-line --checkers="$fs_chercker" --transfers="$fs_transfer" --drive-pacer-min-sleep="$fs_min_sleep" --drive-pacer-burst="$fs_BURST" --check-first`
    file_num3=$(echo "$size_info3" | awk 'BEGIN{FS=" "}/^Total objects/{print $3}')
    file_size3=$(echo "$size_info3" | awk 'BEGIN{FS=" "}/^Total size/{print $3,$4}')
    echo -e "资源名称："$rootname""
    echo -e "----------------------------------"
    printf "|%-5s|%-8s|%-18s|\n" 类型 文件数量 文件大小
    echo -e "----------------------------------"
    printf "|%-5s|%-8s|%-18s|\n" 视频 "$file_num1" "$file_size1"
    echo -e "----------------------------------"
    printf "|%-5s|%-8s|%-18s|\n" 图片 "$file_num2" "$file_size2"
    echo -e "----------------------------------"
    printf "|%-5s|%-8s|%-18s|\n" 文本 "$file_num3" "$file_size3"
    echo -e "----------------------------------"
    printf "|%-5s|%-8s|%-18s|\n" 合计 "$file_num0" "$file_size0"
    echo -e "----------------------------------"
}
echo -e " 选择模式
[1]. 统计文件以及文件夹数
[2]. 统计各种类型文件数量
[3]. 统计文件数及其总大小
[4]. 统计各类型文件数量和大小"
read -p "请输入数字 [1-4]:" num
case "$num" in
1)
    echo -e "列出文件数，文件夹数以及总数"
    size_mode_num_simple
    exit
    ;;
2)
    echo -e "列出各类型文件数量以及总数"
    size_mode_num
    exit
    ;;
3)
    echo -e "列出文件数以及所有文件总大小"
    size_mode_simple
    exit
    ;;
4)
    echo -e "列出各类型文件的数量、大小以及文件总数、总大小"
    size_mode_fully
    exit
    ;;
*)
    echo -e "请输入正确的数字"
    exit
    ;;
esac
