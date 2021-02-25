"imap <C-h> <C-w>h
"imap <C-j> <C-w>j
"imap <C-k> <C-w>k
"imap <C-l> <C-w>l
" g Leader key
let mapleader=" "
" let localleader=" "
nnoremap <Space> <Nop>

" Better indenting
vnoremap < <gv
vnoremap > >gv

if exists('g:vscode')

" Simulate same TAB behavior in VSCode
nmap <Tab> :Tabnext<CR>
nmap <S-Tab> :Tabprev<CR>

else
  " Better nav for omnicomplete
  inoremap <expr> <c-j> ("\<C-n>")
  inoremap <expr> <c-k> ("\<C-p>")

  " Easy CAPS
  " inoremap <c-u> <ESC>viwUi
  " nnoremap <c-u> viwU<Esc>

  " TAB in general mode will move to text buffer
  nnoremap <silent> <TAB> :bnext<CR>
  " SHIFT-TAB will go back
  nnoremap <silent> <S-TAB> :bprevious<CR>

  " <TAB>: completion.
  inoremap <silent> <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

  " Disable Arrow Keys
  noremap <Up> <NOP>
  noremap <Down> <NOP>
  noremap <Left> <NOP>
  noremap <Right> <NOP>

  " Better j, k
  nnoremap j gj
  nnoremap k gk

  " " Better window navigation
  " nnoremap <C-h> <C-w>h
  " nnoremap <C-j> <C-w>j
  " nnoremap <C-k> <C-w>k
  " nnoremap <C-l> <C-w>l

  " " Terminal window navigation
  " tnoremap <C-h> <C-\><C-N><C-w>h
  " tnoremap <C-j> <C-\><C-N><C-w>j
  " tnoremap <C-k> <C-\><C-N><C-w>k
  " tnoremap <C-l> <C-\><C-N><C-w>l
  " inoremap <C-h> <C-\><C-N><C-w>h
  " inoremap <C-j> <C-\><C-N><C-w>j
  " inoremap <C-k> <C-\><C-N><C-w>k
  " inoremap <C-l> <C-\><C-N><C-w>l
  " tnoremap <Esc> <C-\><C-n>

  " " Use alt + hjkl to resize windows
  " nnoremap <silent> <M-j>    :resize -2<CR>
  " nnoremap <silent> <M-k>    :resize +2<CR>
  " nnoremap <silent> <M-h>    :vertical resize -2<CR>
  " nnoremap <silent> <M-l>    :vertical resize +2<CR>
endif

nnoremap <silent> <F5> :call LoadVirtualEnv()<CR>
