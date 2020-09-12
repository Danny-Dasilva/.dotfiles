"     ____    
"    / __ \   __
"   / / / /__/ / Danny Dasilva
"  / /_/ / _  /  dannydasilva.solutions@gmail.com
" /____,'\_,_/  https://github.com/Danny-Dasilva
" A customized init.vim for neovim (https://neovim.io/)
"
"
" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" init pluggins

call plug#begin('~/.config/nvim/autoload/plugged')

    " File Explorer
    Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': ':UpdateRemotePlugins'}  
    Plug 'itchyny/lightline.vim'                       " Lightline statusbar
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    "iceberg theme
    Plug 'gkeep/iceberg-dark'
    Plug 'cocopon/iceberg.vim'
    "code stuff
    Plug 'neoclide/coc.nvim',{'branch': 'release'}
    Plug 'itchyny/lightline.vim'
    Plug 'ryanoasis/vim-devicons'
    Plug 'scrooloose/nerdcommenter'
call plug#end()


" Automatically install missing plugins on startup
set t_Co=256
set encoding=UTF-8

" prettier command for coc
command! -nargs=0 Prettier :CocCommand prettier.formatFile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status Line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The lightline.vim theme
let g:lightline = {
      \ 'colorscheme': 'icebergDark',
      \ }
set bg=dark
colorscheme iceberg 
" Always show statusline
set laststatus=2
source ~/.config/nvim/lightline.vim
"cmment
set termguicolors

set clipboard+=unnamedplus
set showtabline=2

""""""""""""""""""""""""""""
" => Open a terminal inside Vim
""""""""""""""""""""""""""""""
map <Leader>tt :vnew term://bash<CR>

"""""""""""""""""""""""""""""
" => splits and tabbed files
"""""""""""""""""""""""""""""
set splitbelow splitright

" Remap splits navigation to just SHIFT+ hjkl
nnoremap <S-h> <C-w>h
nnoremap <S-j> <C-w>j
nnoremap <S-k> <C-w>k
nnoremap <S-l> <C-w>l

" Remap swap window to CTRL + hjkl
nnoremap <C-h> <C-w>H
nnoremap <C-j> <C-w>J
nnoremap <C-k> <C-w>K
nnoremap <C-l> <C-w>L


"make adjusting split sizes more friendly
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

" change two split windows from vert to horizontal or vice versa
map <Leader>th <C-w>t<C-w>H
map <Leader>tk <C-w>t<C-w>K

"removes the pipes on window split
set fillchars+=vert:\▏ 

""""""""""""""""""" change esc to exit terminal
""""""""""""" random
tnoremap <Esc> <C-\><C-n>

noremap <Leader>r :so $MYVIMRC<CR>

"This unsets the "last search pattern" register by hitting enter
nnoremap <CR> :noh<CR><CR>

" esc in insert mode
inoremap kj <Esc>
" esc in command mode
cnoremap kj <C-C>
" nerdtree toggle
nmap <C-b> :CHADopen<CR>

"szf fuzzy finder 
nmap <C-p> :Files<CR>   
nnoremap <leader>g :Rg<CR>
map <C-f> :BLines<CR>
"Lines for all of the buffers
nmap <C-_>   <Plug>NERDCommenterToggle
nmap <C-c>   <Plug>NERDCommenterToggle
" coc extensions
let g:coc_global_extensions = [
  \'coc-snippets',
  \'coc-pairs',
  \'coc-prettier',
  \'coc-python',
  \'coc-json',
  \'coc-prettier'
  \ ]
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
set hidden
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
set number 
