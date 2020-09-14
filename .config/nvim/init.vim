"     ____    
"    / __ \   __
"   / / / /__/ / Danny Dasilva
"  / /_/ / _  /  dannydasilva.solutions@gmail.com
" /____,'\_,_/  https://github.com/Danny-Dasilva
" 
" A customized init.vim for neovim (https://neovim.io/)
"
" TABLE OF CONTENTS:
" 1. GENERIC SETTINGS
" 2. VIM-PLUG PLUGINS
" 3. USER INTERFACE AND NAVIGATION
" 4. COLORS AND STATUS LINE
" 5. TERMINAL
" 6. PLUGIN NAVIGATION
" 7. EDITING


" ==============================================================================
" 1. GENERIC SETTINGS
" ==============================================================================

"enable buffers (tabbed windows)
set hidden

"show line numbers 
set number 

"enable true color support (color themes will overlap otherwise)
set termguicolors
set t_Co=256
set encoding=UTF-8

" save all files on focus lost, ignoring warnings about untitled buffers
autocmd FocusLost * silent! wa

"save current file when buffer is or new file is opened 
set autowriteall

" ==============================================================================
" 2. VIM-PLUG PLUGINS
" ==============================================================================

" auto-install vim-plug (not entirely sure if functional)
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif



" Plug-ins
call plug#begin('~/.config/nvim/autoload/plugged')
 
    " Navigation
    Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': ':UpdateRemotePlugins'}  " Nerdtree with the addons 
    
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }                       " File search
    Plug 'junegunn/fzf.vim'  
    "Theme
    Plug 'gkeep/iceberg-dark'
    Plug 'cocopon/iceberg.vim'                                               
    Plug 'itchyny/lightline.vim'                                              " Lightline statusbar
    "Ide plugins
    Plug 'neoclide/coc.nvim',{'branch': 'release'}                            " Vs code like intellisense
    Plug 'ryanoasis/vim-devicons'                                             " Icons 
    Plug 'scrooloose/nerdcommenter'                                           " auto comment 
call plug#end()


" ==============================================================================
" 3. USER INTERFACE AND NAVIGATION
"
" ==============================================================================


" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Don't wrap long lines
set nowrap

"removes the pipes on window split
set fillchars+=vert:\▏ 

"make new splits behave normally 
set splitbelow splitright

" Remap splits navigation to just SHIFT+ hjkl
nnoremap <S-h> <C-w>h
nnoremap <S-j> <C-w>j
nnoremap <S-k> <C-w>k
nnoremap <S-l> <C-w>l

"Remap swap window to CTRL + hjkl
nnoremap <C-h> <C-w>H
nnoremap <C-j> <C-w>J
nnoremap <C-k> <C-w>K
nnoremap <C-l> <C-w>L

"Adjust split sizes with CTRL + arrow keys
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

" change two split windows from vert to horizontal or vice versa
map <Leader>th <C-w>t<C-w>H
map <Leader>tk <C-w>t<C-w>K

"tab to cycle through buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>


" ==============================================================================
" 4. COLORS AND STATUS LINE
" ==============================================================================
let g:lightline = {
      \ 'colorscheme': 'icebergDark',
      \ }
set bg=dark
colorscheme iceberg 

"adds / characters to lightline
source ~/.config/nvim/lightline.vim

" Always show statusline
set laststatus=2

"keep filename on top
set showtabline=2

" ==============================================================================
" 5. TERMINAL
" ==============================================================================
"open a terminal leader tt
map <Leader>tt :vnew term://bash<CR>
"Leader R to reset vim 
noremap <Leader>r :so $MYVIMRC<CR>


" ==============================================================================
" 6. PLUGIN NAVIGATION
" ==============================================================================

"Chadtree/nerdtree toggle
nmap <C-b> :CHADopen<CR>

"szf fuzzy finder 
nmap <C-p> :Files<CR>           "search files in current dir 
nnoremap <leader>g :Rg<CR>      "ripgrep
map <C-f> :BLines<CR>           "search current files

"Comment text lines
nmap <C-_>   <Plug>NERDCommenterToggle
nmap <C-c>   <Plug>NERDCommenterToggle

" coc languageextensions
let g:coc_global_extensions = [
  \'coc-snippets',
  \'coc-pairs',
  \'coc-python',
  \'coc-json',
  \'coc-prettier'
  \ ]
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" prettier command for coc
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" ==============================================================================
" 7. EDITING
" ==============================================================================

"This unsets the "last search pattern" register by hitting enter
nnoremap <CR> :noh<CR><CR>

" esc in insert mode
inoremap kj <Esc>
" esc in command mode
cnoremap kj <C-C>

"use system keyboard
set clipboard+=unnamedplus

"Leader R to reset vim 
noremap <Leader>r :so $MYVIMRC<CR>
