" Make this file reloadable at runtime. {{{
augroup initvim | autocmd! | augroup END

" Reload this file every time it gets saved.
autocmd initvim BufWritePost ~/.config/nvim/init.vim source %

" Prevent this file from being refolded after reload.
if expand('%:t') != 'init.vim'
  set foldmethod=syntax
endif
" Make this file reloadable at runtime. }}}

" General settings. {{{
set cursorline
set expandtab
set guicursor=
set ignorecase
set inccommand=nosplit
set mouse=a
set nojoinspaces
set nomodeline
set nowrap
set nowritebackup
set number
set numberwidth=1
set scrolloff=3
set shada=!,'10000,<50,s10,h
set shiftwidth=2
set smartcase
set smartindent
set softtabstop=-1
set spelllang=en,de
set startofline
set switchbuf=uselast
set termguicolors
set textwidth=100
let mapleader = ','

" Force auto wrapping long lines while typing.
autocmd initvim BufEnter * setlocal formatoptions+=t

" Setup folds when opening files.
autocmd initvim BufWinEnter * normal! zR
autocmd initvim BufWinEnter init.vim normal! zM

" Prevent text from being (un)folded while typing.
autocmd initvim InsertEnter * let w:last_foldmethod=&foldmethod | setlocal foldmethod=manual
autocmd initvim InsertLeave * let &l:foldmethod=w:last_foldmethod

" Force QuickFix window to the far bottom.
autocmd initvim FileType qf if &buftype == 'quickfix' | wincmd J | endif
" General settings. }}}

" Mappings. {{{
noremap j gj
noremap k gk
nnoremap Y y$
nnoremap p ]p
nnoremap P ]P
nnoremap S :w<cr>
nnoremap zV zMzv
nnoremap Q mqgqip`q
nnoremap <a-q> mqgqi{`q
nnoremap <leader>s 1z=
nnoremap <a-n> @='n.'<cr>
nnoremap <silent> <leader>ce :let @/='\<' . expand('<cword>') . '\>'<cr>ciw
cnoremap <c-k> <Up>
cnoremap <c-j> <Down>

" Use enter to select completion suggestions.
inoremap <expr><cr> pumvisible() ? '<c-n>' : '<cr>'

" Window navigation.
nnoremap <a-h> <c-w><c-h>
nnoremap <a-j> <c-w><c-j>
nnoremap <a-k> <c-w><c-k>
nnoremap <a-l> <c-w><c-l>
tnoremap <a-h> <c-\><c-n><c-w><c-h>
tnoremap <a-j> <c-\><c-n><c-w><c-j>
tnoremap <a-k> <c-\><c-n><c-w><c-k>
tnoremap <a-l> <c-\><c-n><c-w><c-l>
tnoremap <c-w>H <c-\><c-n><c-w>H
tnoremap <c-w>J <c-\><c-n><c-w>J
tnoremap <c-w>K <c-\><c-n><c-w>K
tnoremap <c-w>L <c-\><c-n><c-w>L
tnoremap <c-w>= <c-\><c-n><c-w>=i
tnoremap <c-w>_ <c-\><c-n><c-w>_i
tnoremap <c-w>v <c-\><c-n><c-w>v
tnoremap <c-w>s <c-\><c-n><c-w>s

" Searching.
noremap / /\v
noremap ? ?\v
noremap # :let @/='\<' . expand('<cword>') . '\>'<cr>N
noremap <c-n> nzzzO
nnoremap <silent> <Esc><Esc> :nohlsearch<cr>
nnoremap <silent> <leader>gg :silent grep! -riIE --exclude-dir=build/ '/' .<cr>:copen<cr>
" Mappings. }}}

" Language specific settings. {{{
" Bash and sh.
let sh_fold_enabled = 1

" C and C++.
let g:c_syntax_for_h = 1
set cinoptions=(0,E-s,N-s,U0,c0,g0,h0,i0,js,w1
autocmd initvim BufNewFile,BufRead *.[ch],*.[ch]pp setlocal spell

" Config.
autocmd initvim FileType config setlocal textwidth=0

" Git.
autocmd initvim FileType git setlocal nospell wrap
autocmd initvim FileType gitcommit setlocal spell textwidth=72

" Help.
autocmd initvim FileType help setlocal textwidth=78

" Html.
autocmd initvim FileType html setlocal textwidth=0

" i3 config.
autocmd initvim BufNewFile,BufRead ~/.config/i3/config setlocal textwidth=0 filetype=conf
autocmd initvim BufWritePost ~/.config/i3/config silent !i3-msg reload >/dev/null 2>&1

" Markdown.
let g:markdown_fenced_languages = [
  \   'c', 'cpp', 'lisp', 'clojure', 'sh', 'bash=sh', 'css',
  \   'javascript', 'js=javascript', 'json=javascript', 'perl', 'php',
  \   'python', 'ruby', 'html', 'vim', 'desktop', 'diff',
  \ ]
autocmd initvim FileType markdown setlocal spell

" Python.
autocmd initvim FileType python setlocal wrap textwidth=0

" Qf (QuickFix).
autocmd initvim FileType qf setlocal nospell

" Scheme.
let g:is_chicken = 1
autocmd initvim FileType scheme setlocal foldnestmax=2

" Tex.
let g:tex_flavor = 'latex'
autocmd initvim BufNewFile,BufRead *.lco setfiletype tex
autocmd initvim FileType tex setlocal spell foldmethod=marker

" Typescript.
autocmd initvim BufNewFile,BufRead *.tsx setfiletype typescript

" Vim.
let g:vim_indent_cont = &shiftwidth
autocmd initvim FileType vim setlocal foldmethod=marker
" Language specific settings. }}}

" Command to discard undo history. {{{
function! s:discardUndoHistory()
  if &modifiable == 0
    return
  endif

  let l:prev_undolevels = &undolevels
  let l:prev_modified = &modified

  setlocal undolevels=-1
  execute "noautocmd normal! i \<esc>\"_x"
  let &l:undolevels = l:prev_undolevels

  if l:prev_modified == 0
    setlocal nomodified
  endif
endfunction

nnoremap <silent> <leader>du :call <sid>discardUndoHistory()<cr>
" Command to discard undo history. }}}

" Preserve terminal mode when switching windows. {{{
function! s:restoreTerminalMode()
  if exists('b:restore_terminal_mode')
    startinsert
  endif
endfunction

function! s:setupTerminal()
  setlocal nonumber

  autocmd BufWinEnter,WinEnter <buffer> call s:restoreTerminalMode()
  tnoremap <buffer><silent> <c-\><c-n> <c-\><c-n>:unlet b:restore_terminal_mode<cr>

  for l:key in [ 'A', 'a', 'I', 'i' ]
    execute 'nnoremap <buffer><silent> ' . l:key . ' :let b:restore_terminal_mode=1<cr>' . l:key
  endfor

  let l:events = [
    \ 'LeftMouse', 'LeftDrag', 'LeftRelease', 'MiddleMouse', 'MiddleDrag',
    \ 'MiddleRelease', 'RightMouse', 'RightDrag', 'RightRelease',
    \ 'X1Mouse', 'X1Drag', 'X1Release', 'X2Mouse', 'X2Drag', 'X2Release',
    \ 'ScrollWheelUp', 'ScrollWheelDown',
    \ ]
  for l:event in l:events
    for l:modifier in [ "", "A-", "C-", "S-" ]
      let l:mapping = '<' . l:modifier . l:event . '>'
      execute 'tnoremap <buffer><silent>' l:mapping
        \ '<c-\><c-n>:unlet b:restore_terminal_mode<cr>' . l:mapping
    endfor
  endfor

  let b:restore_terminal_mode = 1
  normal $A
endfunction

autocmd initvim TermOpen * call s:setupTerminal()
" Preserve terminal mode when switching windows. }}}

" netrw. {{{
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_localrmdir = 'rm -rf'
" netrw. }}}

" termdebug. {{{
packadd termdebug

let g:termdebug_wide = 1

function! s:startDebugSession(arguments)
  nnoremap <silent> <F5> :Step<cr>
  nnoremap <silent> <F6> :Over<cr>
  nnoremap <silent> <F7> :Finish<cr>
  nnoremap <silent> <F8> :Evaluate<cr>
  vnoremap <silent> <F8> :Evaluate<cr>
  execute 'Termdebug' a:arguments
endfunction
command! -nargs=? -complete=file Debug call s:startDebugSession(<q-args>)
" termdebug. }}}

call plug#begin('~/.config/nvim/plugged')

" YouCompleteMe. {{{
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --clangd-completer' }

let g:ycm_key_list_select_completion = []
let g:ycm_key_list_previous_completion = []
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_always_populate_location_list = 1
let g:ycm_error_symbol = '❌️'
let g:ycm_warning_symbol = '⚠️ '
let g:ycm_extra_conf_globlist = [ '!*' ]
let g:ycm_filetype_blacklist = {}
let g:ycm_clangd_args = [
  \ '-cross-file-rename', '--header-insertion=never', '--completion-style=detailed'
  \ ]

nnoremap <silent> <leader>gr :YcmCompleter GoToReferences<cr>
autocmd initvim FileType tex nnoremap <buffer><silent> K :YcmCompleter GetHover<cr>
autocmd initvim FileType c,cpp,python,typescript
  \ nnoremap <buffer><silent> K :YcmCompleter GetDoc<cr>
autocmd initvim FileType c,cpp,tex,python,typescript
  \ nnoremap <buffer><silent> gd :YcmCompleter GoToDefinition<cr>
autocmd initvim WinEnter * if &previewwindow | setlocal syntax=cpp wrap | endif
autocmd initvim User YcmQuickFixOpened q | botright copen
" YouCompleteMe. }}}

" fzf. {{{
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

let $FZF_DEFAULT_COMMAND = 'find . -name .git -a -type d -prune -o -type f -print 2>/dev/null'
nnoremap <c-p> :Files<cr>
nnoremap <c-f> :History<cr>
" fzf. }}}

" ultisnips. {{{
Plug 'SirVer/ultisnips'

let g:UltiSnipsEditSplit = 'horizontal'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
nnoremap <leader>u :UltiSnipsEdit<cr>

autocmd initvim FileType snippets setlocal noexpandtab tabstop=2 textwidth=0
autocmd initvim BufWritePost *.snippets call UltiSnips#RefreshSnippets()
autocmd initvim BufWinEnter *.snippets normal! zM
" ultisnips. }}}

" ultisnips-snippets. {{{
Plug 'AlxHnr/ultisnips-snippets'

function! s:UpdateIncludeGuards()
  python3 from snippet_module_c import get_current_header_string
  let l:header_string = py3eval('get_current_header_string()')
  let l:current_cursor = getpos('.')
  silent execute '%s/\v^(#(ifndef|define)\s+)([^_]+_\w+_h(pp)?\s*$)/\1'
    \ . l:header_string . '/e'
  call setpos('.', l:current_cursor)
endfunction
command! UpdateIncludeGuards call s:UpdateIncludeGuards()
" ultisnips-snippets. }}}

" vim-fugitive. {{{
Plug 'tpope/vim-fugitive'

nnoremap <a-s> :Gwrite<cr><Esc>
nnoremap <silent> <F10> :Git<cr>
nnoremap <silent> <F11> :Git commit<cr>
nnoremap <silent> <F12> :Git push<cr>
autocmd initvim FileType fugitive setlocal wrap
autocmd initvim FileType fugitiveblame setlocal nospell
" vim-fugitive. }}}

" gv.vim. {{{
Plug 'junegunn/gv.vim'

nnoremap <F9> :GV --all<cr>
" gv.vim. }}}

" vim-commentary. {{{
Plug 'tpope/vim-commentary'
" vim-commentary. }}}

" vim-eunuch. {{{
Plug 'tpope/vim-eunuch'
" vim-eunuch. }}}

" vim-autoformat. {{{
Plug 'Chiel92/vim-autoformat'

function! CustomFormatExpression()
  execute v:lnum . ',' . (v:lnum + v:count - 1) . 'Autoformat'
endfunction

autocmd initvim FileType c,cpp setlocal textwidth=0 formatexpr=CustomFormatExpression()
autocmd initvim FileType c,cpp noremap <buffer> = gq
" vim-autoformat. }}}

" vim-table-mode. {{{
Plug 'dhruvasagar/vim-table-mode'

let g:table_mode_corner = '|'
let g:table_mode_motion_up_map    = ''
let g:table_mode_motion_down_map  = ''
let g:table_mode_motion_left_map  = ''
let g:table_mode_motion_right_map = ''

autocmd initvim FileType markdown,text silent TableModeEnable
" vim-table-mode. }}}

" vim-better-whitespace. {{{
Plug 'ntpeters/vim-better-whitespace'

let g:better_whitespace_filetypes_blacklist =
  \ [ 'qf', 'diff', 'git', 'vim-plug' ]
autocmd initvim FileType fugitive DisableWhitespace

nnoremap <silent> <leader>tw :ToggleWhitespace<cr>
" vim-better-whitespace. }}}

" vim-easy-align. {{{
Plug 'junegunn/vim-easy-align'

vmap <cr> <Plug>(EasyAlign)*
" vim-easy-align. }}}

" ale. {{{
Plug 'dense-analysis/ale'

let g:ale_linters_explicit = 1
let g:ale_linters = { 'sh': [ 'shellcheck' ] }
let g:ale_sign_error = '❌️'
let g:ale_sign_warning = '⚠️ '
let g:ale_sign_info = '❕️'
" ale. }}}

" vimtex. {{{
Plug 'lervag/vimtex'

let g:vimtex_quickfix_mode = 0
" vimtex. }}}

" gruvbox. {{{
Plug 'gruvbox-community/gruvbox'

let g:gruvbox_invert_selection = 0

if !exists('$BAT_THEME')
  let $BAT_THEME = 'gruvbox-dark'
endif

function! s:toggleColorscheme()
  if &background == 'dark'
    set background=light
    let $BAT_THEME = 'gruvbox-light'
  else
    set background=dark
    let $BAT_THEME = 'gruvbox-dark'
  endif
endfunction
nnoremap <silent> <leader>cs :call <sid>toggleColorscheme()<cr>
" gruvbox. }}}

" build.vim. {{{
Plug 'AlxHnr/build.vim'

nnoremap <silent> <F1> :wall<cr>:Build clean<cr>
nnoremap <silent> <F2> :wall<cr>:Build<cr>
nnoremap <silent> <F3> :wall<cr>:Build test<cr>
nnoremap <silent> <F4> :wall<cr>:Build run<cr>

let s:build_c_flags = '-Wall -Wextra -pedantic -O0 -coverage -ggdb -fsanitize=address,undefined'
command! -nargs=? CMakeInit execute 'Build init -DCMAKE_BUILD_TYPE=Debug'
  \ '-DCMAKE_C_FLAGS="' . s:build_c_flags . '"'
  \ '-DCMAKE_CXX_FLAGS="' . s:build_c_flags . ' -Wno-missing-field-initializers"'
  \ <q-args>

let s:build_clang_flags = s:build_c_flags . ' -Wdocumentation'
command! -nargs=? CMakeInitClang execute 'Build init -DCMAKE_BUILD_TYPE=Debug'
  \ '-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++'
  \ '-DCMAKE_C_FLAGS="'   . s:build_clang_flags . '"'
  \ '-DCMAKE_CXX_FLAGS="' . s:build_clang_flags . ' -stdlib=libstdc++"'
  \ <q-args>
" build.vim. }}}

" project-chdir.vim. {{{
Plug 'AlxHnr/project-chdir.vim'
" project-chdir.vim. }}}

" vim-spell-files. {{{
Plug 'AlxHnr/vim-spell-files'
" vim-spell-files. }}}

" Setup and load ./custom/ directory. {{{
call mkdir(expand('~/.config/nvim/custom/spell'), 'p')
call mkdir(expand('~/.config/nvim/custom/UltiSnips'), 'p')
set spellfile=~/.config/nvim/custom/spell/custom.utf-8.add

if filereadable(expand('~/.config/nvim/custom/init.vim'))
  execute 'source ' . expand('~/.config/nvim/custom/init.vim')
endif
autocmd initvim BufWritePost ~/.config/nvim/custom/init.vim source ~/.config/nvim/init.vim
" Setup and load ./custom/ directory. }}}

call plug#end()

" Install plugins on first start.
if !isdirectory(g:plug_home)
  let g:plug_window = 'enew!'
  PlugInstall
  unlet g:plug_window
endif

if !exists('g:colors_name')
  colorscheme gruvbox
endif
set statusline=%<%f\ %h%m%r%{empty(FugitiveHead(7))?'':'['.FugitiveHead(7).']'}%=%-8.(%l,%c%)\ %P
