#!/bin/bash
[ -r /etc/passwd  ] && echo 当前用户对/etc/passwd 有读权限 || echo 当前用户对/etc/passwd 没有读权限

[ -w /etc/passwd  ] && echo 当前用户对/etc/passwd 有写权限 || echo 当前用户对/etc/passwd 没有写权限
[ -x /etc/passwd  ] && echo 当前用户对/etc/passwd 有执行权限 || echo 当前用户对/etc/passwd 没有执行权限
