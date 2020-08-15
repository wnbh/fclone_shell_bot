#!/bin/bash
source /root/fclone_shell_bot/myfc_config.ini

stty erase '^H'
mkdir -p $safolder/invalid
sa1_sum=$(ls -l $safolder|grep "^-"| wc -l)
echo -e "待检测sa账号 $sa1_sum 个，开始检测\n"
find $safolder -maxdepth 1 -type f -name "*.json" | xargs -I {} -n 1 -P 10 bash -c 'fclone lsd '$fclone_name':{'$fsa_id'} --drive-service-account-file={} --drive-service-account-file-path=""  &> /dev/null || mv {} '$safolder'/invalid '
xsa_sum=$(ls -l $safolder/invalid|grep "^-"| wc -l)
sa_sum=$(ls -l $safolder|grep "^-"| wc -l)
if [ x$xsa_sum = x0 ];then
  echo -e "未检测到无效sa账号"
elif [ x$sa_sum = x0 ];then
  echo -e "所有sa账号均无效"
else
  echo -e "检测到无效sa账号 $xsa_sum 个,已移至：$safolder/invalid"
fi
echo -e "检查完成！！！"
