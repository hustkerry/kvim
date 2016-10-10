""""vim�����ļ�""""

"����Ϊ��vi������ģʽ
set nocompatible

"����������ڵ��к��У�au��vim���Զ�����
"au WinLeave * set nocursorline nocursorcolumn     "�뿪����ǰ
"au WinEnter * set cursorline cursorcolumn         "�����������ں�
"set cursorline cursorcolumn

let mapleader = ","    "����ǰ׺��

if has("syntax")
  syntax on            " �﷨����
endif

set number
set numberwidth=5

"������ɫ����
"colorscheme ron
"highlight NonText guibg=#060606
"highlight Folded  guibg=#0A0A0A guifg=#9090D0


set backspace=2        "���û��˼�
set nobackup           "������   
"set nowritebackup     "���ͬʱ������nobackup��nowritebackup���ڴ������������ļ�ʱ��������ݵĶ�ʧ 
set noswapfile         "��ʹ����ʱ�ļ�

set history=100
set ruler         "��ʾ���
set mouse=a       "ʹ�����

set showcmd      
set showmode 

set incsearch     "�����ַ���ͬʱ����λ��ƥ��ĵ���
set hlsearch
set laststatus=2  "������ʾ���һ�����ڵ�״̬��
"set autowrite     "����ļ��޸Ĺ����Զ�������д���ļ�
set confirm       "����δ�������ֻ���ļ�ʱ�򣬵���ȷ��
set fileencodings=utf-8,gb18030,gbk,big5       "vim��������ı����ʽ̽���ļ��ĸ�ʽ

set tabstop=4        " �����Ʊ��(tab��)�Ŀ��
set softtabstop=4     " �������Ʊ���Ŀ��    
set shiftwidth=4    " (�Զ�) ����ʹ�õ�4���ո�
set autoindent        " �����Զ�����(����)����ÿ�е�����ֵ����һ����ȣ�ʹ�� noautoindent ȡ������

filetype plugin indent on     "�ļ����ͼ��

"��һ���ַ�����100��,��ʾ
"set textwidth=100
"set colorcolumn=+1



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""���ļ�����
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"�½�.c,.h,.sh,.java�ļ����Զ������ļ�ͷ 
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.rb,*.java,*.py exec ":call SetTitle()" 
""���庯��SetTitle���Զ������ļ�ͷ 
func SetTitle() 
	"����ļ�����Ϊ.sh�ļ� 
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
	"�½��ļ����Զ���λ���ļ�ĩβ
endfunc 
autocmd BufNewFile * normal G
