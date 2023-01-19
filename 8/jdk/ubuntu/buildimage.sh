#!/bin/bash

root=`dirname $0`
root=`cd "$root" ; pwd`

cd "$root"

function buildone()
{
[ ! -f "$1" ] && return
target_dockerfile=$1
target_dir=`dirname $target_dockerfile`

target_name=chaochuang/dragonwell8

t_version=`grep "VERSION" $target_dockerfile | tr -d '\r' | awk '{print $3}'`
t_os_name=`basename $target_dir`
t_arch=`arch`

tags=" -t ${target_name}:latest -t ${target_name}:jdk "
[ -n "$t_os_name" ] && tags="$tags -t ${target_name}:jdk-${t_os_name}"
[ -n "$t_version" ] && tags="$tags -t ${target_name}:${t_version}" && [ -n "$t_arch" ] && tags="$tags -t ${target_name}:${t_version}-${t_arch}"

docker build -f $target_dockerfile ${tags} $target_dir

}

find . -type f | grep "Dockerfile" | while read aline
do
  buildone $aline
done

