#!/bin/bash
echo "start install and configure for vim ......"

echo "backup and mkdirs for vim"
vimDir=${HOME}"/.vim/"
if [ ! -d $vimDir ]; then
	mkdir $vimDir
fi

vimColorDir=${HOME}"/.vim/colors/"
if [ ! -d $vimColorDir ]; then
    mkdir $vimColorDir
fi

echo "copy colorscheme resourses for vim"
for colorFile in ./vimColors/*
do
    if test -f $colorFile
    then
        cp -f $colorFile $vimColorDir
    fi
done

vimVundleDir=${HOME}"/.vim/bundle/vundle"
echo "clone vundle from github to "$vimVundleDir
if [ ! -d $vimVundleDir ]; then
    git clone https://github.com/gmarik/vundle.git $vimVundleDir
fi

echo "copy .vimrc and .vimrc.bundles"
if [ -f "~/.vimrc" ]; then
	mv -f ~/.vimrc ~/.vimrc.back
fi
cp -f .vimrc ~/.vimrc

if [ -f "~/.vimrc.bundles" ]; then
	mv -f ~/.vimrc.bundles ~/.vimrc.bundles.back
fi
cp -f .vimrc.bundles ~/.vimrc.bundles

echo "installing vim-nox...."
sudo apt-get install vim-nox

echo "installing bundles for vim, which will take times, please wait..."
vim +BundleInstall +qall
echo "done !!!!!!"
