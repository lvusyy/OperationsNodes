#!/bin/bash
#检查登录用户,如果大于2人的时候就发送邮件给管理员
users=`who |wc -l`

[ $users -gt 3  ] && echo -e "alert login user too mutch \nwe have $users user to logined"|mail -s " check user Alert" root
