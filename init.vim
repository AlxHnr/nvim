" general settings. {{{
" fundamentals. {{{
set nobackup
set nowritebackup
set nomodeline
set modelines=0
set number
set numberwidth=1
set scrolloff=3
set history=10000
set nowrap
set mouse=a
set shada=!,'10000,<50,s10,h
syntax on

set cursorline
set guicursor=
set termguicolors
set laststatus=2
set completeopt=menuone
set sessionoptions+=resize

let mapleader = ','
let g:tex_flavor = 'latex'
let g:is_chicken = 1
let g:c_syntax_for_h = 1
let g:markdown_fenced_languages =
  \ [
  \   'c', 'cpp', 'lisp', 'clojure', 'sh', 'bash=sh', 'css',
  \   'javascript', 'js=javascript', 'json=javascript', 'perl', 'php',
  \   'python', 'ruby', 'html', 'vim', 'desktop', 'diff',
  \ ]
" fundamentals. }}}

" general autocommands. {{{
augroup initvim
  autocmd!

  autocmd TermOpen * setlocal nonumber | normal $A
  autocmd BufWinEnter,WinEnter term://* startinsert
  autocmd BufWinLeave,WinLeave term://* stopinsert
  autocmd CmdwinEnter * setlocal wrap
  autocmd FileType cs,git,qf,python setlocal wrap
  autocmd FileType * setlocal iskeyword-=$
  autocmd BufNewFile,BufRead *.lco setfiletype tex
  autocmd BufNewFile,BufRead ~/.config/i3/config setfiletype conf

  autocmd BufWritePost ~/.config/nvim/init.vim source %
  autocmd BufWritePost ~/.Xresources silent !xrdb -merge %
  autocmd BufWritePost ~/.config/i3/config
    \ silent !i3-msg reload >/dev/null 2>&1
augroup END
" general autocommands. }}}

" general mappings. {{{
cnoremap <c-k> <Up>
cnoremap <c-j> <Down>
noremap j gj
noremap k gk

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

" Use enter to select completion suggestions.
inoremap <expr><cr> pumvisible() ? '<c-n>' : '<cr>'

" other mappings.
nnoremap Y y$
nnoremap S :w<cr>
nnoremap <a-s> :Gw<cr><Esc>
nnoremap <a-n> @='n.'<cr>
nnoremap <silent> <leader>ce :let @/='\<' . expand('<cword>') . '\>'<cr>ciw
" general mappings. }}}

" searching. {{{
set magic
set ignorecase
set smartcase
set incsearch
set hlsearch
set inccommand=nosplit

noremap / /\v
noremap ? ?\v
noremap # :let @/='\<' . expand('<cword>') . '\>'<cr>N
noremap <c-n> nzzzO
nnoremap <silent> <Esc><Esc> :nohlsearch<cr>
nnoremap <silent> <leader>gg
  \ :silent grep! -riIE --exclude-dir=build/ '/' .<cr>:copen<cr>
" searching. }}}

" folding. {{{
" Preserve foldmethod when sourcing this file.
if expand('%:t') != 'init.vim'
  set foldmethod=syntax
endif

" Pre-folds the current buffer.
function! s:refold() " {{{
  if expand('%:t') == 'init.vim'
    normal! zMzr
  elseif &filetype == 'snippets'
    normal! zM
  else
    normal! zR
  endif
endfunction " }}}

let sh_fold_enabled = 1
autocmd initvim FileType git setlocal foldmethod=manual
autocmd initvim FileType vim,tex setlocal foldmethod=marker
autocmd initvim FileType scheme setlocal foldnestmax=2
autocmd initvim BufWinEnter * call s:refold()
nnoremap zV zMzv

" Prevent vim from (un)folding text while typing.
autocmd initvim InsertEnter * let w:last_foldmethod=&foldmethod
  \ | setlocal foldmethod=manual
autocmd initvim InsertLeave * let &l:foldmethod=w:last_foldmethod

" re-apply fold settings after sourcing this file.
execute 'set filetype=' . &filetype
" folding. }}}

" formatting. {{{
set textwidth=100
set nojoinspaces
nnoremap Q mqgqip`q
nnoremap <a-q> mqgqi{`q

autocmd initvim FileType help setlocal textwidth=78
autocmd initvim FileType gitcommit setlocal textwidth=72
autocmd initvim FileType html,conkyrc,config,python setlocal textwidth=0
autocmd initvim BufNewFile,BufRead ~/.config/i3/config setlocal textwidth=0
autocmd initvim BufEnter * setlocal formatoptions+=t
" formatting. }}}

" indenting. {{{
set shiftwidth=2
set softtabstop=-1
set expandtab

set smartindent
set cinoptions=(0,E-s,N-s,U0,c0,g0,h0,i0,js,w1
let g:vim_indent_cont = &shiftwidth

" indent after pasting.
nnoremap p ]p
nnoremap P ]P
" indenting. }}}

" spell checking. {{{
set spelllang=en,de
set spellfile=~/.config/nvim/custom/spell/custom.utf-8.add
autocmd initvim BufNewFile,BufRead *.[ch] setlocal spell
autocmd initvim BufNewFile,BufRead *.[ch]pp setlocal spell
autocmd initvim FileType markdown,tex,gitcommit setlocal spell
autocmd initvim FileType git,qf setlocal nospell
nnoremap <leader>s 1z=
" spell checking. }}}

" Setup $PATH. {{{
if index(split($PATH, ':'), expand('~/.config/nvim/bin')) < 0
  let $PATH .= ':' . expand('~/.config/nvim/bin')
endif
" Setup $PATH. }}}
" general settings. }}}

" plugins. {{{

" Build the given plugin if required. This function can be passed to
" vim-plug.
function! BuildPlugin(info) " {{{
  if a:info.name == 'YouCompleteMe'
    let l:cmd = 'python3 ' . expand('~/.config/nvim/plugged/YouCompleteMe/install.py')
  elseif a:info.name == 'ccls'
    let l:cmd = expand('~/.config/nvim/rebuild-ccls.sh')
  else
    return
  endif

  " Run build command in split terminal window if this function was not
  " called by vim-plug.
  if !has_key(a:info, 'status')
    botright new
    call termopen(l:cmd)
    startinsert
  elseif a:info.status != 'unchanged'
    execute '!' . l:cmd
  endif
endfunction " }}}

call plug#begin()

" netrw. {{{
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_localrmdir = 'rm -rf'
" netrw. }}}

" vim-fugitive. {{{
Plug 'tpope/vim-fugitive'

nnoremap <silent> <F10> :Gstatus<cr>
nnoremap <silent> <F11> :Gcommit<cr>
nnoremap <silent> <F12> :Git push<cr>
autocmd initvim FileType fugitive setlocal wrap
autocmd initvim FileType fugitiveblame setlocal nospell
" vim-fugitive. }}}

" vim-commentary. {{{
Plug 'tpope/vim-commentary'
" vim-commentary. }}}

" vim-eunuch. {{{
Plug 'tpope/vim-eunuch'
" vim-eunuch. }}}

" vim-polyglot. {{{
Plug 'sheerun/vim-polyglot'

let g:polyglot_disabled = [ 'latex', 'markdown', 'sh' ]
" vim-polyglot. }}}

" vim-autoformat. {{{
Plug 'Chiel92/vim-autoformat'

" Wraps :Autoformat into a formatexpr.
function! CustomFormatExpression() " {{{
  execute v:lnum . ',' . (v:lnum + v:count - 1) . 'Autoformat'
endfunction " }}}

autocmd initvim FileType c,cpp
  \ setlocal textwidth=0 formatexpr=CustomFormatExpression()
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

" gv.vim. {{{
Plug 'junegunn/gv.vim'

nnoremap <F9> :GV --all<cr>
" gv.vim. }}}

" goyo.vim. {{{
Plug 'junegunn/goyo.vim'

autocmd! User GoyoEnter nested setlocal nocursorline
" goyo.vim. }}}

" fuzzy search. {{{
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

let $FZF_DEFAULT_COMMAND =
  \ 'find . -name .git -a -type d -prune -o -type f -print 2>/dev/null'
let g:fzf_command_prefix = 'FZF'

nnoremap <c-p> :FZFFiles<cr>
nnoremap <c-f> :FZFHistory<cr>
" fuzzy search. }}}

" ale. {{{
Plug 'dense-analysis/ale'

let g:ale_linters = {}
let g:ale_linters['c'] = []
let g:ale_linters['cpp'] = []

let g:ale_sign_error = '❌️'
let g:ale_sign_warning = '⚠️ '
let g:ale_sign_info = '❕️'
" ale. }}}

" ultisnips. {{{
Plug 'SirVer/ultisnips'

let g:UltiSnipsEditSplit = 'horizontal'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
nnoremap <leader>u :UltiSnipsEdit<cr>

autocmd initvim FileType snippets setlocal noexpandtab tabstop=2 textwidth=0
" ultisnips. }}}

" YouCompleteMe. {{{
Plug 'ycm-core/YouCompleteMe', { 'do': function('BuildPlugin') }

let g:ycm_key_list_select_completion = []
let g:ycm_key_list_previous_completion = []
let g:ycm_always_populate_location_list = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_complete_in_comments = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_error_symbol = g:ale_sign_error
let g:ycm_warning_symbol = g:ale_sign_warning
let g:ycm_extra_conf_globlist = [ '!*' ]
let g:ycm_language_server = []
let g:ycm_filetype_blacklist =
  \ { 'netrw': 1, 'unite': 1, 'tagbar': 1, 'infolog': 1 }

function! s:getFiletypesWithAssociatedLSPServers() " {{{
  let l:result = []
  for l:server in g:ycm_language_server
    if has_key(l:server, 'filetypes')
      let l:result += l:server.filetypes
    endif
  endfor

  return l:result
endfunction " }}}

function! s:mapYCMCommands() " {{{
  let l:lsp_langs = s:getFiletypesWithAssociatedLSPServers()
  let l:ycm_native_langs = [ 'python' ]

  if index(l:lsp_langs, &filetype) >= 0
    nnoremap <buffer><silent> K :YcmCompleter GetHover<cr>
    nnoremap <buffer><silent> gd :YcmCompleter GoToDefinition<cr>
  elseif index(l:ycm_native_langs, &filetype) >= 0
    nnoremap <buffer><silent> K :YcmCompleter GetDoc<cr>
    nnoremap <buffer><silent> gd :YcmCompleter GoToDefinition<cr>
  endif
endfunction " }}}

autocmd initvim WinEnter *
  \ if &previewwindow
  \| setlocal syntax=cpp wrap
  \| endif
autocmd initvim FileType * call s:mapYCMCommands()
nnoremap <silent> <leader>gr :YcmCompleter GoToReferences<cr>
autocmd initvim User YcmQuickFixOpened q | copen

command! RebuildYCM call BuildPlugin({'name': 'YouCompleteMe'})
" YouCompleteMe. }}}

" ccls. {{{
Plug 'MaskRay/ccls', { 'do': function('BuildPlugin'), 'frozen': 1 }

let g:ycm_language_server +=
  \ [
  \   {
  \     'name': 'ccls',
  \     'cmdline': [ 'ccls', '-init={"cache":{"directory":"/tmp/ccls-cache"}}' ],
  \     'project_root_files': [ 'compile_commands.json' ],
  \     'filetypes': [ 'c', 'cpp' ],
  \   }
  \ ]

command! RebuildCCLS call BuildPlugin({'name': 'ccls'})
" ccls. }}}

" texlab. {{{
let g:ycm_language_server +=
  \ [
  \   {
  \     'name': 'texlab',
  \     'cmdline': [ 'texlab' ],
  \     'filetypes': [ 'tex' ],
  \   }
  \ ]
" texlab. }}}

" vimtex. {{{
Plug 'lervag/vimtex'

let g:vimtex_quickfix_mode = 0
" vimtex. }}}

" palenight.vim. {{{
Plug 'drewtempelmeyer/palenight.vim'
" palenight.vim. }}}

" Wrapper around :Plug, which prefers local plugins in '~/projects'.
function! s:localPlug(name) " {{{
  let l:path = expand('~/projects/') . a:name
  if isdirectory(l:path)
    Plug l:path
  else
    Plug 'AlxHnr/' . a:name
  endif
endfunction " }}}

" build.vim. {{{
call s:localPlug('build.vim')

" Passes the current build systems default target to :Build.
function! s:buildDefaultTarget() " {{{
  let l:build_system = build#get_current_build_system()
  let l:systems_without_default_target =
    \ { 'Autotools': 1, 'Make': 1, 'CMake': 1 }

  if !empty(l:build_system) &&
    \ has_key(l:systems_without_default_target, l:build_system.name)
    Build
  else
    Build build
  endif
endfunction " }}}

nnoremap <silent> <F1> :wall<cr>:Build clean<cr>
nnoremap <silent> <F2> :wall<cr>:call <sid>buildDefaultTarget()<cr>
nnoremap <silent> <F3> :wall<cr>:Build test<cr>
nnoremap <silent> <F4> :wall<cr>:Build run<cr>

let s:build_c_flags = '-Wall -Wextra -pedantic -O0 -coverage -ggdb -fsanitize=address'
command! -nargs=* CMakeInit call build#init(
  \ '-DCMAKE_C_FLAGS='   . s:build_c_flags,
  \ '-DCMAKE_CXX_FLAGS=' . s:build_c_flags,
  \ <f-args>)

let s:build_clang_flags = s:build_c_flags . ' -Wdocumentation'
command! -nargs=* CMakeInitClang call build#init(
  \ '-DCMAKE_C_COMPILER=clang', '-DCMAKE_CXX_COMPILER=clang++',
  \ '-DCMAKE_C_FLAGS='   . s:build_clang_flags,
  \ '-DCMAKE_CXX_FLAGS=' . s:build_clang_flags . ' -stdlib=libstdc++',
  \ <f-args>)
" build.vim. }}}

call s:localPlug('clear_colors')
call s:localPlug('project-chdir.vim')
call s:localPlug('ultisnips-snippets')
call s:localPlug('vim-spell-files')

let s:vim_custom_config = expand('~/.config/nvim/custom/init.vim')
if filereadable(s:vim_custom_config)
  execute 'source ' . s:vim_custom_config
endif
autocmd initvim BufWritePost ~/.config/nvim/custom/init.vim
  \ source ~/.config/nvim/init.vim

call plug#end()
" plugins. }}}

" misc. {{{
" Colorscheme related settings. {{{
if !exists('g:colors_name')
  colorscheme palenight
endif

function! s:toggleColorscheme() " {{{
  if !exists('g:colors_name')
    return
  elseif g:colors_name == 'palenight'
    colorscheme clear_colors_light
  elseif g:colors_name == 'clear_colors_light'
    colorscheme palenight
  elseif &background == 'dark'
    set background=light
  else
    set background=dark
  endif
endfunction " }}}

nnoremap <silent> <leader>cs :call <sid>toggleColorscheme()<cr>
" Colorscheme related settings. }}}

" Statusline. {{{
function! GetGitHead() " {{{
  if !exists('*fugitive#head()')
    return ''
  endif

  let l:string = fugitive#head()
  if !empty(l:string)
    return '[' . l:string . ']'
  else
    return ''
  endif
endfunction " }}}

set statusline=%<%f\ %h%m%r%{GetGitHead()}
set statusline+=%=%-8.(%l,%c%)\ %P
" Statusline. }}}

" Discard undo history. {{{
function! s:discardUndoHistory() " {{{
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
endfunction " }}}
nnoremap <silent> <leader>du :call <sid>discardUndoHistory()<cr>
" Discard undo history. }}}

function! s:UpdateIncludeGuards() " {{{
  python3 from snippet_module_c import get_current_header_string
  let l:header_string = py3eval('get_current_header_string()')
  let l:current_cursor = getpos('.')
  silent execute '%s/\v^(#(ifndef|define)\s+)([^_]+_\w+_h(pp)?\s*$)/\1'
    \ . l:header_string . '/e'
  call setpos('.', l:current_cursor)
endfunction " }}}
command! UpdateIncludeGuards call s:UpdateIncludeGuards()
" misc. }}}
