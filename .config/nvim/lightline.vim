
function! Devicons_Filetype()"{{{
  " return winwidth(0) > 70 ? (strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() . ' ' . &filetype : 'no ft') : ''
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction"}}}

set laststatus=2  " Basic
set noshowmode  " Disable show mode info
let g:lightline = {
      \ 'colorscheme': 'icebergDark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified'  ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'devicons_filetype', 'charvaluehex' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ ['close'] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ }
      \ }

let g:lightline.separator  = { 'left': "\ue0b8\ue0be\ue0b8", 'right': "\ue0ba\ue0bc\ue0ba" }
let g:lightline.subseparator         = { 'left': "\ue0b9", 'right': "\ue0bb" }
let g:lightline.component_function = {
      \ 'devicons_filetype': 'Devicons_Filetype',
      \ }
"let g:lightline.subseparator         = { 'left': "\ue0b9", 'right': "\ue0b9" }
"let g:lightline.active = {
            "\ 'left': [ [ 'mode', 'paste' ],
            "\           [ 'readonly', 'filename', 'modified'] ],
            "\ 'right': [ [ 'filetype', 'lineinfo' ] ]
            "\ }
"let g:lightline.inactive = {
            "\ 'left': [ [ 'filename', 'modified' ]],
            "\ 'right': [ [ 'filetype', 'lineinfo' ] ]
            "\ }
"let g:lightline.tabline = {
            "\ 'left': [ [ 'tabs' ] ],
            "\ 'right': [ [ 'gitbranch' ],
            "\ [ 'gitstatus' ] ]
            "\ }

