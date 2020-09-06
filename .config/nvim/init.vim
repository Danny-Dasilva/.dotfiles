" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" init pluggins

call plug#begin('~/.config/nvim/autoload/plugged')

    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    Plug 'itchyny/lightline.vim'                       " Lightline statusbar
    Plug 'arcticicestudio/nord-vim'
call plug#end()


"theme


colorscheme nord

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status Line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The lightline.vim theme
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ }

" Always show statusline
set laststatus=2


if (&term =~ '^xterm' && &t_Co == 256)
  set t_ut= | set ttyscroll=1
endif

set number        " add line numbers

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

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" esc in insert mode
inoremap kj <Esc>
" esc in command mode
cnoremap kj <C-C>
