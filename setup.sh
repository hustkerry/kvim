#!/bin/bash
echo "��ʼ��װ������vim......"

if [ -f "~/.vimrc" ]; then
	mv -f ~/.vimrc ~/.vimrc.back
fi
cp -f .vimrc ~/.vimrc

vimDir="/home/wenba/.vim/"
if [ ! -d "$vimDir" ]; then
	mkdir "$vimDir"
fi
