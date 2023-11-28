" TODO(ym): Learn Vimscript
" TODO(ym): Make a Sessions/Projects plugin. oooor not? I don't feel like I need it surprisingly

" Auto install vim-plug if not found
if empty(glob('~/.config/nvim/plugins/'))
	silent !curl -fLo ~/.config//nvim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC

endif
let g:enable_italic_font = 1
" TODO switch to tomorrow dark or something
" Vim Plugins {{{
" NOTE: Indented for easier management with vim-textobj-indent
call plug#begin('~/.config/nvim/plugins/')

  " Plug 'github/copilot.vim', {'branch': 'release'}
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'editorconfig/editorconfig-vim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'branch': 'main', 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

	Plug 'lewis6991/gitsigns.nvim', {'branch': 'main'}

	Plug 'ActivityWatch/aw-watcher-vim'
	Plug  'Vigemus/iron.nvim'
	Plug  'qpkorr/vim-renamer'

	Plug  'rust-lang/rust.vim'
    Plug 'kristijanhusak/vim-hybrid-material'

    Plug 'wlangstroth/vim-racket'

	" Idk if i really need it
    Plug 'tpope/vim-fugitive'
    Plug 'troydm/zoomwintab.vim'
	Plug 'bogado/file-line'

    Plug 'airblade/vim-rooter'
    " Plug 'chrisbra/Colorizer'
    Plug 'powerman/vim-plugin-AnsiEsc'

    Plug 'itchyny/lightline.vim'
	" Plug $HOME . '/Projects/vim-hour'
    Plug $HOME . '/Projects/fzf'
    Plug $HOME . '/Projects/vim-search'

    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/vim-easy-align'

    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-surround'

    Plug 'tpope/vim-repeat'
    Plug 'kana/vim-textobj-user'
	" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

    Plug 'kana/vim-textobj-indent'
    Plug 'kana/vim-textobj-function'

    Plug 'sgur/vim-textobj-parameter'
    Plug 'Julian/vim-textobj-variable-segment'

	" TODO(ym): I don't really use this, either? I mostly just use gc provided by commentary
    Plug 'glts/vim-textobj-comment'
    Plug 'tpope/vim-endwise'

    " Plug 'ym1234/vim-fswitch', { 'for': [ 'c', 'cpp' ] }
    " Plug 'junegunn/vim-slash'

    Plug 'tpope/vim-eunuch'
    Plug 'machakann/vim-highlightedyank'

    Plug 'tommcdo/vim-exchange'
    Plug 'vim-scripts/ProportionalResize'

	" Plug '~/Drive/Projects/lldb.nvim', { 'for': [ 'c', 'cpp', 'go', 'rust' ], 'do': ':UpdateRemotePlugins' }
	" TODO(ym): KEYBINDS
	" TODO(ym): and port from lldb to gdb
    Plug 'dbgx/lldb.nvim', { 'for': [ 'c', 'cpp', 'go', 'rust' ], 'do': ':UpdateRemotePlugins' }

    Plug 'vim-scripts/ReplaceWithRegister'
    Plug 'drmingdrmer/vim-indent-lua'

    Plug 'lambdalisue/suda.vim'
    Plug 'mbbill/undotree'
	" Plug 'w0rp/ale'
	Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }

    " Plug 'sheerun/vim-polyglot'
    " Plug 'autozimu/LanguageClient-neovim', {  'branch': 'next',  'do': './install.sh' }
	" Plug 'solderneer/lightline-languageclient'
call plug#end()

" }}}
" Vim Options {{{

colorscheme hybrid_reverse

" lua << EOF
"   require('telescope').setup {
"       defaults = {
"           vimgrep_arguments = {
"               'rg',
"               '--no-heading',
"               '--with-filename',
"               '--line-number',
"               '--column',
"               '--smart-case'
"               },
"           prompt_prefix = "> ",
"           selection_caret = "> ",
"           entry_prefix = "  ",
"           initial_mode = "insert",
"           selection_strategy = "reset",
"           sorting_strategy = "descending",
"           layout_strategy = "horizontal",
"           layout_config = {
"               horizontal = {mirror = false},
"               vertical = {mirror = false}
"               },
"           file_sorter = require'telescope.sorters'.get_fuzzy_file,
"           file_ignore_patterns = {
"               '.git',
"               '__pycache__'
"               },
"           generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
"           path_display = {},
"           winblend = 0,
"           border = {},
"           borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
"           color_devicons = true,
"           use_less = true,
"           set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
"           file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
"           grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
"           qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

"           -- Developer configurations: Not meant for general override
"           buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,
"       },
"       extensions = {
"           fzf = {
"               fuzzy = true,                    -- false will only do exact matching
"               override_generic_sorter = true,  -- override the generic sorter
"               override_file_sorter = true,     -- override the file sorter
"               case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
"               -- the default case_mode is "smart_case"
"               }
"           }
"   }

"   require'telescope'.load_extension('fzf')
" -- require('telescope').load_extension('fzf')
" EOF

set cursorline nojoinspaces nostartofline breakindent notimeout nottimeout hidden autowrite autoread nowritebackup nobackup noswapfile undofile noshowmode noequalalways shiftwidth=2 expandtab tabstop=2 autoindent hlsearch incsearch smartcase completeopt-=preview ignorecase splitbelow splitright lazyredraw termguicolors
set pumheight=10 background=dark spelllang=en_us cino=l1 inccommand=nosplit updatetime=50 undolevels=10000 cmdheight=1 diffopt+=vertical tabpagemax=10 history=1000 undodir=~/.config/nvim/tmp/undo listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_ grepprg=rg\ --vimgrep\ --color=never mouse=a

let mapleader = "\<Space>"

let g:terminal_color_0 = '#282A2E'
let g:terminal_color_1 = '#A54242'
let g:terminal_color_2 = '#8C9440'
let g:terminal_color_3 = '#DE935F'
let g:terminal_color_4 = '#373B41'
let g:terminal_color_5 = '#85678F'
let g:terminal_color_6 = '#5E8D87'
let g:terminal_color_7 = '#707880'
let g:terminal_color_8 = '#373B41'
let g:terminal_color_9 = '#CC6666'
let g:terminal_color_10 = '#B5BD68'
let g:terminal_color_11 = '#F0C674'
let g:terminal_color_12 = '#81A2BE'
let g:terminal_color_13 = '#B294BB'
let g:terminal_color_14 = '#8ABEB7'
let g:terminal_color_15 = '#C5C8C6'

let g:python_host_skip_check = 1
let g:python3_host_skip_check = 1
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

set wildignore+=.git,.hg,.svn
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
set wildignore+=*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
set wildignore+=*.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
set wildignore+=*.swp,.lock,.DS_Store,._*

let g:netrw_liststyle = 3
let g:netrw_special_syntax = 1
let g:netrw_winsize = 20
let g:netrw_menu = 0
let g:netrw_banner = 0

hi QuickFixLine gui=reverse

hi Pmenu guifg=#c5c8c6 guibg=#282a2e
hi PmenuSel guifg=#456887 guibg=#ffffff
hi PmenuSbar guifg=#456887 guibg=#282a2e
hi PmenuThumb guifg=#282a2e guibg=#456887

hi ALEVirtualTextError guifg=#cc6666
hi ALEVirtualTextWarning guifg=#F0C674

hi SignColumn guibg=bg
hi SignColumn guifg=fg

if !isdirectory(expand(&undodir))
	call mkdir(expand(&undodir), 'p')
endif

" }}}
" Plugin Options {{{

let g:ghcid_keep_open = 1
let g:zoomwintab_remap = 0
let g:ghcid_command = "ghcid -c 'cabal new-repl'"

let g:iron_map_defaults = 0
let g:iron_map_extended = 0

let g:LanguageClient_useVirtualText=1

let g:ale_set_quickfix = 1
let g:ale_sign_error = '×'
let g:ale_sign_warning = '!'
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_fixers = { 'go': [ 'goimports' ],   }
let g:ale_linters = { 'go': [ 'gopls' ], 'rust': [ 'rls' ]}
let g:ale_virtualtext_cursor = 1

nnoremap gd :ALEGoToDefinition<CR>
nnoremap K :ALEHover<CR>

let g:LanguageClient_diagnosticsDisplay =  {
			\        1: {
			\            "name": "Error",
			\            "texthl": "Error",
			\            "signText": "×",
			\            "signTexthl": "ALEErrorSign",
			\        },
			\        2: {
			\            "name": "Warning",
			\            "texthl": "Warning",
			\            "signText": ">>",
			\            "signTexthl": "ALEWarningSign",
			\        },
			\        3: {
			\            "name": "Information",
			\            "texthl": "Info",
			\            "signText": "ℹ",
			\            "signTexthl": "ALEInfoSign",
			\        },
			\        4: {
			\            "name": "Hint",
			\            "texthl": "Hint",
			\            "signText": "h",
			\            "signTexthl": "ALEInfoSign",
			\        },
			\    }

let g:exchange_no_mappings = 0
let b:exchange_indent = 1

let g:windowswap_map_keys = 0
let g:ProportionalResize_UpdateTime = 5

" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Todo', 'border': 'sharp' } }
" let g:fzf_layout = { 'down': '40%' }
let g:fzf_layout = { 'up': '~20%' }
let g:fzf_action = {
			\ 'ctrl-t': 'tab split',
			\ 'ctrl-x': 'split',
			\ 'ctrl-v': 'vsplit',
			\ 'ctrl-r': 'pedit'
			\ }

let g:rooter_patterns = ['.gradle', '.git/', 'src/']
let g:rooter_resolve_links = 1
let g:rooter_manual_only = 1

autocmd QuitPre * if empty(&buftype) | lclose | endif

let g:lightline = {
			\ 'colorscheme': 'hybridmodified',
			\ 'component': {
			\   'lineinfo': ' %3l:%-2v',
			\   'gitbranch': ' %{FugitiveHead()}',
			\ },
			\ 'component_expand' : {
			\  'warning_count': 'lightline#languageclient#warnings',
			\  'error_count': 'lightline#languageclient#errors',
			\  'linter_ok': 'lightline#languageclient#ok',
			\ },
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ],
			\			  [ 'gitbranch' ],
			\             [ 'filename', 'readonly', 'modified' ] ],
			\	'right': [  [ 'percent', 'lineinfo' ],
			\ 				['error_count', 'warning_count', 'linter_ok' ],
			\               [ 'fileformat', 'fileencoding', 'filetype' ] ]
			\ },
			\ 'inactive' : {
			\ 	'right': [ [ 'lineinfo' ] ]
			\ }
			\ }

			" \ 'component_type' : {
			" \  'warning_count': 'warning',
			" \  'error_count': 'error',
			" \  'linter_ok': 'left',
			" \ },
let s:p = { 'normal': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {} , 'inactive': {} }
let s:p.normal = {
			\	'left': [ [ '#ffffff', '#5f875f'], [ '#c5c8c6', '#282a2e'] ],
			\	'right':  [ [ '#ffffff', '#5f875f'], [ '#c5c8c6', '#282a2e'] ],
			\	'middle':  [ ['#bcbcbc', '#373b41', '' ] ],
			\ }

let s:p.insert = {
			\   'left': [ [ '#ffffff', '#456887'], s:p.normal.left[1] ],
			\	'right':  [ [ '#ffffff', '#456887'], s:p.normal.left[1] ],
			\ }
let s:p.replace = {
			\	'left':  [ [ '#ffffff', '#5f5f87'], s:p.normal.left[1] ],
			\	'right':  [ [ '#ffffff', '#5f5f87'], s:p.normal.left[1] ],
			\ }

let s:p.visual = {
			\	'left': [ [ '#ffffff', '#cc6666'], s:p.normal.left[1] ],
			\	'right': [ [ '#ffffff', '#cc6666'], s:p.normal.left[1] ],
			\ }

let s:p.tabline = {
			\	'left': [ [ '#bcbcbc', '#282a2e'] ],
			\	'middle': s:p.normal.middle,
			\	'tabsel':  [ [ '#ffffff', '#5f875f'] ],
			\ }

let s:p.inactive = {
			\	'left': [ ['#707880', '#303030'] ],
			\	'right': [ ['#707880', '#303030'] ],
			\ }

let g:lightline#colorscheme#hybridmodified#palette = lightline#colorscheme#fill(s:p)

" }}}
" Autocommands {{{

autocmd BufWritePre * call TrimWhitespace()
autocmd BufRead *.h setlocal filetype=c
" autocmd WinEnter * if  bufname('%') == "__LanguageClient__"  | setlocal filetype=go | endif

autocmd Filetype racket setlocal expandtab
autocmd Filetype racket inoremap <buffer> /lm λ

autocmd BufRead .bashrc setlocal foldmethod=marker
autocmd FileType conf,vim setlocal foldmethod=marker

autocmd FileType sxhkdrc setlocal commentstring=#\ %s
autocmd FileType man nnoremap <buffer> gd <C-]>

autocmd FileType fzf setlocal nonumber norelativenumber

autocmd FocusLost * silent! wa
" autocmd FileType * call LC_maps()

autocmd VimResized * redraw!
" autocmd BufNewFile,BufRead *.hs setlocal tabstop=8 expandtab softtabstop=2 shiftwidth=2 shiftround nosmartindent

func! Whatever()
	let path = expand('%:p:r')
	let test_path = path . "_test.go"
	execute "edit" test_path
endfunc

" }}}
" Functions/Commands {{{
function! ToggleQf()
  for buffer in tabpagebuflist()
    if bufname(buffer) == ''
      cclose
      return
    endif
  endfor
  botright copen
  wincmd p
endfunction

" function! LC_maps()
" 	if has_key(g:LanguageClient_serverCommands, &filetype)
" 		nnoremap <buffer><silent> K :call LanguageClient#textDocument_hover()<CR>
" 		nnoremap <buffer><silent> gd :call LanguageClient#textDocument_definition()<CR>
" 		" TODO(ym): Better keybind
" 		nnoremap <buffer><silent> <F2> :call LanguageClient#textDocument_rename()<CR>
" 		setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
" 		" autocmd InsertLeave <buffer> call LanguageClient#textDocument_formatting()
" 		nnoremap <buffer><silent> <Leader>u :call LanguageClient#textDocument_formatting()<CR>
" 		setlocal omnifunc=LanguageClient#complete
" 		setlocal completefunc=LanguageClient#complete
" 		" call deoplete#enable()
" 	endif
" endfunction

" helper function to toggle hex mode
" TODO(ym): keybinding
function! ToggleHex()
	" hex mode should be considered a read-only operation
	" save values for modified and read-only for restoration later,
	" and clear the read-only flag for now
	let l:modified=&mod
	let l:oldreadonly=&readonly
	let &readonly=0
	let l:oldmodifiable=&modifiable
	let &modifiable=1
	if !exists("b:editHex") || !b:editHex
		" save old options
		let b:oldft=&ft
		let b:oldbin=&bin
		" set new options
		setlocal binary " make sure it overrides any textwidth, etc.
		let &ft="xxd"
		" set status
		let b:editHex=1
		" switch to hex editor
		%!xxd
	else
		" restore old options
		let &ft=b:oldft
		if !b:oldbin
			setlocal nobinary
		endif
		" set status
		let b:editHex=0
		" return to normal editing
		%!xxd -r
	endif
	" restore values for modified and read only state
	let &mod=l:modified
	let &readonly=l:oldreadonly
	let &modifiable=l:oldmodifiable
endfunction

function! TrimWhitespace()
	let cursorpos = getcurpos()
	execute '%s/\s\+$//e'
	call setpos('.', cursorpos)
endfunction

command! -nargs=? -complete=dir Cd call Cd(<f-args>)
function! Cd(...)
	call fzf#run(fzf#wrap({'source': 'find -L '.(a:0 == 0 ? '.' : a:1).' -type d  | sed "s|^\./||"', 'sink': 'cd'}))
endfunction

" TODO(ym): Ignore plugin/special windows, maybe make it wrap to the other side if it is on one of them?
command! -nargs=1 -count=0 WinMove call WinMove(<args>, <count>)
function! WinMove(key, count)
	let t:curwin = winnr()
	exec a:count "wincmd ".a:key
	if (t:curwin == winnr())
		if match(a:key,'[jk]')
			wincmd v
		else
			wincmd s
		endif
		exec a:count "wincmd ".a:key
	endif
endfunction

command! -nargs=+ -complete=file Z call Z(<f-args>)
function! Z(...)
	let cmd = 'fasd -e printf'
	for arg in a:000
		let cmd = cmd . ' ' . arg
	endfor
	let path = system(cmd)
	if isdirectory(path)
		echo path
		exec 'cd ' . path
	elseif file_readable(path)
		exec 'e '. path
	else
		echo 'No results'
	endif
endfunction

" }}}
" Mappings/Abbreviations {{{

" Fuck <C-w>
" I don't like gh either tbh
" Maybe change it back to C-{h,j,k,l}?
nnoremap <silent>gh :WinMove 'h'<CR>
nnoremap <silent>gj :WinMove 'j'<CR>
nnoremap <silent>gk :WinMove 'k'<CR>
nnoremap <silent>gl :WinMove 'l'<CR>
nnoremap <silent><C-h> :WinMove 'h'<CR>
nnoremap <silent><C-j> :WinMove 'j'<CR>
nnoremap <silent><C-k> :WinMove 'k'<CR>
nnoremap <silent><C-l> :WinMove 'l'<CR>
nnoremap <Leader>c <C-w><C-q>
nnoremap <C-c> <C-w><C-q>

nmap s ys
nmap ss ySs

nnoremap <Leader>/  :Rg<CR>
nnoremap <Leader>.  :FZF<CR>
nnoremap <Leader>h  :FZF ~<CR>
nnoremap <Leader>b  :Buffers<CR>
nnoremap <Leader>H 	:Help<CR>
nnoremap <Leader>oh :FZF<Space>
nnoremap <Leader>oc :Commits<CR>
nnoremap <Leader>oC :BCommits<CR>
nnoremap <Leader>oH :History<CR>
" nnoremap <Leader>. :Telescope find_files<CR>
" nnoremap <Leader>b :Telescope buffers<CR>
" nnoremap <Leader>m :Telescope man_pages sections=ALL<CR>

nnoremap <silent><Leader>se :vsp $MYVIMRC<CR>
nnoremap <silent><Leader>sv :source $MYVIMRC<CR>:noh<CR>

" I never use tabs, maybe remove these.
nnoremap <silent><Leader>tn :tabnew<CR>
nnoremap <silent><Leader>tm :tabm<Space>
nnoremap <silent><Leader>td :tabclose<CR>

nnoremap <silent><Leader>tg :TagbarToggle<CR><C-w>=

vnoremap <TAB> >gv
vnoremap <S-TAB> <gv

nnoremap Y y$

nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

nnoremap gy "+y
nnoremap gY "+y$
nnoremap gp "+p
vnoremap gy "+y
vnoremap gY "+y$
vnoremap gp "+p

nnoremap 0 ^
nnoremap ^ 0

nnoremap - :
nnoremap : q:i
vnoremap - :
vnoremap : q:i

" " Placement is annoying on dvorak
nnoremap _ "
nnoremap Q @q

nnoremap <Leader>su :PlugUpdate<CR>
nnoremap <Leader>sc :PlugClean<CR>
nnoremap <Leader>sg :PlugUpgrade<CR>
nnoremap <Leader>si :PlugInstall<CR>

nnoremap <Leader><Leader> <C-^>
nnoremap <Leader>r :Rooter<CR>

nnoremap <silent><Leader>D :bdel!<CR>
nnoremap <silent><Leader>d :bdel<CR>

nnoremap <Leader>w :w<CR>
nnoremap <Leader>W :w suda://%<CR>

nmap go <Plug>(Exchange)
nmap goo <Plug>(ExchangeLine)
nmap gog <Plug>(ExchangeClear)

nnoremap <Leader>sn :set number! relativenumber!<CR>
nnoremap <silent> <ESC> :noh<CR>
inoremap jj <ESC>
inoremap jk <ESC>

nnoremap <M-n> :cnext<CR>zz
nnoremap <silent><M-c> :call ToggleQf()<CR>
nnoremap <M-p> :cprev<CR>zz

" nnoremap gd <C-]>
tnoremap <M-n> <C-\><C-n>
vnoremap <ESC> o<ESC>

" Emacs bindings for command mode, taken out of vim-rsi
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <expr> <C-D> getcmdpos() > strlen(getcmdline()) ? "\<Lt>C-D>" : "\<Lt>Del>"
cnoremap <A-b> <S-Left>
cnoremap <A-f> <S-Right>

vnoremap s :s//g<Left><Left>
nnoremap S :<C-r>=v:count == 0 ? "%" : ""<CR>s//g<Left><Left>

" Is ga good? its default behaviour was pretty nice tbh but i didn't use it
" often
" xmap ga <Plug>(EasyAlign)
" nmap ga <Plug>(EasyAlign)

nnoremap <Leader>ae mavap:EasyAlign = <CR>`a
nnoremap <Leader>at mavap:EasyAlign *\|<CR>`a
nnoremap <leader>n :ZoomWinTabToggle<CR>

nnoremap <leader>t :IronRepl
" }}}
