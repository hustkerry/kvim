""""vim配置文件""""

"设置为和vi不兼容模式
set nocompatible

"高亮光标所在的行和列，au是vim的自动命令
"au WinLeave * set nocursorline nocursorcolumn     "离开窗口前
"au WinEnter * set cursorline cursorcolumn         "进入其他窗口后
"set cursorline cursorcolumn

let mapleader = ","    "设置前缀键

if has("syntax")
  syntax on            " 语法高亮
endif

set number
set numberwidth=5

"设置配色方案
"colorscheme ron
"highlight NonText guibg=#060606
"highlight Folded  guibg=#0A0A0A guifg=#9090D0


set backspace=2        "设置回退键
set nobackup           "不备份   
"set nowritebackup     "如果同时设置了nobackup和nowritebackup，在磁盘满而更新文件时会造成数据的丢失 
set noswapfile         "不使用临时文件

set history=100
set ruler         "显示标尺
set mouse=a       "使用鼠标

set showcmd      
set showmode 

set incsearch     "输入字符的同时，定位到匹配的单词
set hlsearch
set laststatus=2  "总是显示最后一个窗口的状态行
"set autowrite     "如果文件修改过，自动把内容写回文件
set confirm       "处理未保存或者只读文件时候，弹出确认
set fileencodings=utf-8,gb18030,gbk,big5       "vim会用这里的编码格式探测文件的格式

set tabstop=4        " 设置制表符(tab键)的宽度
set softtabstop=4     " 设置软制表符的宽度    
set shiftwidth=4    " (自动) 缩进使用的4个空格
set autoindent        " 设置自动对齐(缩进)：即每行的缩进值与上一行相等；使用 noautoindent 取消设置

filetype plugin indent on     "文件类型检测

"当一行字符超过100的,提示
"set textwidth=100
"set colorcolumn=+1



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""新文件标题
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头 
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.rb,*.java,*.py exec ":call SetTitle()" 
""定义函数SetTitle，自动插入文件头 
func SetTitle() 
	"如果文件类型为.sh文件 
	if &filetype == 'sh' 
		call setline(1,"\#!/bin/bash") 
		call append(line("."), "") 
    elseif &filetype == 'python'
        call setline(1,"#!/usr/bin/env python")
		call append(line("."), "# -*- coding: utf-8 -*-")
		call append(line(".")+1, "\"\"\"")
		call append(line(".")+2, " File Name: ".expand("%")) 
		call append(line(".")+3, " Author: Kerry") 
		call append(line(".")+4, " Mail: yuyao90@gmail.com") 
		call append(line(".")+5, " Created Time: ".strftime("%c")) 
		call append(line(".")+6, " Description: ")
		call append(line(".")+7, "\"\"\"") 
		call append(line(".")+8, "")

    elseif &filetype == 'ruby'
        call setline(1,"#!/usr/bin/env ruby")
        call append(line("."),"# encoding: utf-8")
	    call append(line(".")+1, "")
	
	else 
		call setline(1, "/*************************************************************************") 
		call append(line("."), "	> File Name: ".expand("%")) 
		call append(line(".")+1, "	> Author: Kerry") 
		call append(line(".")+2, "	> Mail: yuyao90@gmail.com") 
		call append(line(".")+3, "	> Created Time: ".strftime("%c")) 
		call append(line(".")+4, " ************************************************************************/") 
		call append(line(".")+5, "")
	endif
	if expand("%:e") == 'cpp'
		call append(line(".")+6, "#include<iostream>")
		call append(line(".")+7, "using namespace std;")
		call append(line(".")+8, "")
	endif
	if &filetype == 'c'
		call append(line(".")+6, "#include<stdio.h>")
		call append(line(".")+7, "")
	endif
	if expand("%:e") == 'h'
		call append(line(".")+6, "#ifndef _".toupper(expand("%:r"))."_H")
		call append(line(".")+7, "#define _".toupper(expand("%:r"))."_H")
		call append(line(".")+8, "#endif")
	endif
	if &filetype == 'java'
		call append(line(".")+6,"public class ".expand("%:r"))
		call append(line(".")+7,"")
	endif
	"新建文件后，自动定位到文件末尾
endfunc 
autocmd BufNewFile * normal G
