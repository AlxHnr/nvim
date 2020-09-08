" general settings. {{{
" fundamentals. {{{
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
set spellfile=~/.config/nvim/custom/spell/custom.utf-8.add
set spelllang=en,de
set termguicolors
set textwidth=100

let mapleader = ','
" fundamentals. }}}

" autocommands. {{{
augroup initvim
  autocmd!

  autocmd BufWritePost ~/.config/nvim/init.vim source %

  autocmd BufEnter * setlocal formatoptions+=t
  autocmd CmdwinEnter * setlocal wrap
augroup END
" autocommands. }}}

" Mappings. {{{
noremap j gj
noremap k gk
nnoremap Y y$
nnoremap p ]p
nnoremap P ]P
nnoremap S :w<cr>
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

autocmd initvim BufWinEnter * call s:refold()
nnoremap zV zMzv

" Prevent vim from (un)folding text while typing.
autocmd initvim InsertEnter * let w:last_foldmethod=&foldmethod
  \ | setlocal foldmethod=manual
autocmd initvim InsertLeave * let &l:foldmethod=w:last_foldmethod

" re-apply fold settings after sourcing this file.
execute 'set filetype=' . &filetype
" folding. }}}

" Setup $PATH. {{{
if index(split($PATH, ':'), expand('~/.config/nvim/bin')) < 0
  let $PATH .= ':' . expand('~/.config/nvim/bin')
endif
" Setup $PATH. }}}
" general settings. }}}

" Language specific settings. {{{
" Bash and sh. {{{
let sh_fold_enabled = 1
" Bash and sh. }}}

" C and C++. {{{
let g:c_syntax_for_h = 1
set cinoptions=(0,E-s,N-s,U0,c0,g0,h0,i0,js,w1
autocmd initvim BufNewFile,BufRead *.[ch] setlocal spell
autocmd initvim BufNewFile,BufRead *.[ch]pp setlocal spell
" C and C++. }}}

" Config. {{{
autocmd initvim FileType config setlocal textwidth=0
" Config. }}}

" Git. {{{
autocmd initvim FileType git setlocal nospell wrap foldmethod=manual
autocmd initvim FileType gitcommit setlocal spell textwidth=72
" Git. }}}

" Help. {{{
autocmd initvim FileType help setlocal textwidth=78
" Help. }}}

" Html. {{{
autocmd initvim FileType html setlocal textwidth=0
" Html. }}}

" i3 config. {{{
autocmd initvim BufNewFile,BufRead ~/.config/i3/config setlocal textwidth=0 filetype=conf
autocmd initvim BufWritePost ~/.config/i3/config silent !i3-msg reload >/dev/null 2>&1
" i3 config. }}}

" Markdown. {{{
let g:markdown_fenced_languages = [
  \   'c', 'cpp', 'lisp', 'clojure', 'sh', 'bash=sh', 'css',
  \   'javascript', 'js=javascript', 'json=javascript', 'perl', 'php',
  \   'python', 'ruby', 'html', 'vim', 'desktop', 'diff',
  \ ]
autocmd initvim FileType markdown setlocal spell
" Markdown. }}}

" Python. {{{
autocmd initvim FileType python setlocal wrap textwidth=0
" Python. }}}

" Qf. {{{
autocmd FileType qf setlocal wrap nospell
" Qf. }}}

" Scheme. {{{
let g:is_chicken = 1
autocmd initvim FileType scheme setlocal foldnestmax=2
" Scheme. }}}

" Tex. {{{
let g:tex_flavor = 'latex'
autocmd initvim BufNewFile,BufRead *.lco setfiletype tex
autocmd initvim FileType tex setlocal spell foldmethod=marker
" Tex. }}}

" Vim. {{{
let g:vim_indent_cont = &shiftwidth
autocmd initvim FileType vim setlocal foldmethod=marker
" Vim. }}}
" Language specific settings. }}}

" plugins. {{{

" Build the given plugin if required. This function can be passed to
" vim-plug.
function! BuildPlugin(info) " {{{
  if a:info.name == 'YouCompleteMe'
    let l:cmd = 'python3 ' . expand('~/.config/nvim/plugged/YouCompleteMe/install.py')
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

nnoremap <a-s> :Gw<cr><Esc>
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

let g:polyglot_disabled = [ 'markdown' ]
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

" fzf. {{{
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

let $FZF_DEFAULT_COMMAND =
  \ 'find . -name .git -a -type d -prune -o -type f -print 2>/dev/null'
let g:fzf_command_prefix = 'FZF'

nnoremap <c-p> :FZFFiles<cr>
nnoremap <c-f> :FZFHistory<cr>
" fzf. }}}

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
autocmd initvim BufWritePost *.snippets call UltiSnips#RefreshSnippets()
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
let g:ycm_filetype_blacklist =
  \ { 'netrw': 1, 'unite': 1, 'tagbar': 1, 'infolog': 1 }
let g:ycm_language_server = [
  \   {
  \     'name': 'clangd',
  \     'cmdline': [ 'clangd', '-cross-file-rename', '--header-insertion=never' ],
  \     'project_root_files': [ 'compile_commands.json' ],
  \     'filetypes': [ 'c', 'cpp' ],
  \   }
  \ ]

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
autocmd initvim User YcmQuickFixOpened q | botright copen

command! RebuildYCM call BuildPlugin({'name': 'YouCompleteMe'})
" YouCompleteMe. }}}

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

" Preserve insert mode in terminals. {{{
function! s:restoreInsertMode() " {{{
  if exists('b:restore_insert_mode')
    startinsert
  endif
endfunction " }}}
function! s:setupTerminal() " {{{
  setlocal nonumber

  autocmd BufWinEnter,WinEnter <buffer> call s:restoreInsertMode()
  nnoremap <buffer><silent> i :let b:restore_insert_mode=1<cr>i
  tnoremap <buffer><silent> <c-\><c-n> <c-\><c-n>:unlet b:restore_insert_mode<cr>

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
        \ '<c-\><c-n>:unlet b:restore_insert_mode<cr>' . l:mapping
    endfor
  endfor

  let b:restore_insert_mode = 1
  normal $A
endfunction " }}}

autocmd initvim TermOpen * call s:setupTerminal()
" Preserve insert mode in terminals. }}}
" misc. }}}
