" --- Settings ---
set belloff=all                 " Silence all audible and visual bells
set termguicolors               " Enable 24-bit RGB true color in terminal
set splitbelow splitright       " Open new splits below and to the right
set tabstop=2                   " Number of visual spaces per tab character
set shiftwidth=2                " Indentation width in spaces for > and <
set expandtab                   " Convert tabs to spaces automatically
set textwidth=78                " Auto-wrap text at 78 characters
set colorcolumn=+1              " Draw vertical guide column at textwidth + 1
set cursorline                  " Highlight the screen line of the cursor
set wildmode=longest,full       " Autocomplete only matching regex

" Terminal cursor shape sequences (bar in insert, underline in replace)
let &t_SI = "\e[6 q"            " Insert mode: thin vertical bar
let &t_SR = "\e[4 q"            " Replace mode: underline
let &t_EI = "\e[2 q"            " Normal mode: solid block
let &t_te .= "\e[0 q"           " Exit: restore terminal default bar


" --- Autocommands ---
" Strip trailing whitespace on save (preserves cursor, ignores markdown/diffs)
function! StripTrailingWhitespace()
  if &filetype !~# 'markdown\|diff'
    let l:view = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:view)
  endif
endfunction
autocmd BufWritePre * call StripTrailingWhitespace()

" Enable US English spellcheck automatically in LaTeX buffers
autocmd FileType tex setlocal spell spelllang=en_us

" Disable automatic line-wrapping in MATLAB and text files
autocmd FileType matlab,text setlocal textwidth=0 colorcolumn=79

" --- Remappings ---
let mapleader = " "           " Set Spacebar as the custom shortcut prefix

" Remap <Esc> to jk in Insert mode
inoremap jk <ESC>

" Dismiss search highlights and redraw screen
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

" Yank/paste directly to system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p

" Navigate open window splits with Shift + H/J/K/L
nnoremap H <C-w>h
nnoremap L <C-w>l
nnoremap J <C-w>j
nnoremap K <C-w>k

" Prevent accidental line joins (J) or man-page lookups (K) in Visual mode
vnoremap J j
vnoremap K k

" Treat Shift + Arrow keys as regular arrow keys in Insert mode
inoremap <S-Right> <Right>
inoremap <S-Up> <Up>
inoremap <S-Down> <Down>
inoremap <S-Left> <Left>


" --- Plugins ---
call plug#begin('~/.vim/plugged')
Plug 'lervag/vimtex'            " LaTeX engine and compilation support
Plug 'joshdick/onedark.vim'     " Atom One Dark color theme
Plug 'itchyny/lightline.vim'    " Lightweight statusline
Plug 'ward/vimcompletesme'      " Context-aware tab completion
call plug#end()

" --- Colorscheme ---
silent! colorscheme onedark     " Load One Dark color theme

" lightline settings
set noshowmode                  " Don't show insert mode indicator below
set laststatus=2                " Always show the statusline
let g:lightline = { 'colorscheme': 'onedark' }

" VimTeX settings
if empty(v:servername) && exists('*remote_startserver')
  call remote_startserver('VIM')
endif
let g:vimtex_view_method = 'general'
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_view_general_options = '--synctex-forward @line:@col:@tex -x "gvim -v --servername ' . v:servername . ' --remote-silent +%{line} ''%{input}''" @pdf'
let g:vimtex_view_automatic = 0 " Don't open pdf viewer on \ll
let g:vimtex_indent_enabled = 0 " Disable indentation

"VimCompletesMe + VimTex e.g. \cite{ + Tab
augroup VimCompletesMeTex
  autocmd!
  autocmd FileType tex
      \ let b:vcm_omni_pattern = g:vimtex#re#neocomplete
augroup END

" Automatically close the quickfix window if it is the only window left open
augroup CloseQuickfix
  autocmd!
  autocmd WinClosed * nested if winnr('$') == 2 && win_gettype() ==# 'quickfix' | cclose | endif
augroup END

" Subdued background tint for inactive windows
highlight InactiveWindow guibg=#1e2127 ctermbg=234
augroup FocusDimmer
  autocmd!
  autocmd WinEnter,BufEnter * setlocal wincolor=NONE
  autocmd WinLeave          * setlocal wincolor=InactiveWindow
augroup END
