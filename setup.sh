#!/bin/bash
echo "开始安装和配置vim......"

if [ -f "~/.vimrc" ]; then
	mv -f ~/.vimrc ~/.vimrc.back
fi
cp -f .vimrc ~/.vimrc

vimDir="/home/wenba/.vim/"
if [ ! -d "$vimDir" ]; then
	mkdir "$vimDir"
fi
