set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
Plugin 'tomasr/molokai'
Plugin 'preservim/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'prabirshrestha/asyncomplete.vim'
"Plugin 'prabirshrestha/asyncomplete-lsp.vim'
"Plugin 'mattn/vim-lsp-settings'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" global
syntax enable
au FileType c,cpp setlocal number

" color
colorscheme molokai

" file explorer 
" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
let g:NERDTreeMinimalUI=1

" status line 
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail'
let g:airline#extensions#tabline#buffer_nr_show=1
let g:airline#extensions#nerdtree_statusline=0
let g:airline_theme='molokai'

" index of the source code 
set tags=.vim/tags;
if filereadable(".vim/cscope.out")
  cs add .vim/cscope.out
endif

function CreateIndex()
  let l:cwd=getcwd()
  let l:home=environ()->get('HOME')
  if l:cwd ==# l:home
    echom "HOME will no be a project directory"
    return
  endif
  silent !mkdir -p .vim
  silent !rm -f .vim/files.list .vim/tags .vim/cscope.out
  redraw!

  if ! executable("ctags")
    echom "ctags needs to be installed"
    return
  endif
  if ! executable("cscope")
    echom "cscope needs to be installed"
    return
  endif

  silent !find . -type f -regex '.*\.\(c\|h\|cpp\)$' > .vim/files.list
  silent !ctags -L .vim/files.list --tag-relative=never -o .vim/tags
  silent !cscope -b -i .vim/files.list
  silent !mv cscope.out .vim/
  cs add .vim/cscope.out
  redraw!

  echom "index created!"
endfunction

nnoremap <C-@> :call CreateIndex()<CR>
