
set number        " add line numbers
""""""""""""""""""""""""""""
" => Open a terminal inside Vim
""""""""""""""""""""""""""""""
map <Leader>tt :vnew term://bash<CR>


"""""""""""""""""""""""""""""
" => splits and tabbed files
"""""""""""""""""""""""""""""
set splitbelow splitright
" Remap splits navigation to just CTRL + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"make adjusting split sizes more friendly
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

" change two split windows from vert to horizontal or vice versa
map <Leader>th <C-w>t<C-w>H
map <Leader>tk <C-w>t<C-w>K

"removes the pipes on window split
set fillchars+=vert:\
""""""""""""""""""" ideas
":tnoremap <Esc> <C-\><C-n>
