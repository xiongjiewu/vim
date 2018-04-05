call plug#begin() " {{{
Plug 'Valloric/YouCompleteMe'
Plug 'tomasr/molokai'
Plug 'vim-airline/vim-airline'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'jacoborus/tender.vim'
Plug 'lvht/fzf-mru'|Plug 'junegunn/fzf'
Plug 'mileszs/ack.vim'

Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'Townk/vim-autoclose'
Plug 'godlygeek/tabular'
Plug 'tomtom/tcomment_vim'
Plug 'vim-scripts/matchit.zip'

Plug '2072/PHP-Indenting-for-VIm', { 'for': 'php' }
Plug 'lvht/phpcd.vim', { 'do': 'composer update' }
Plug 'w0rp/ale'
" Plug 'lvht/phpfold.vim', { 'for': 'php' }
Plug 'xsbeats/vim-blade'

Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }

Plug 'justinmk/vim-syntax-extra'
Plug 'elzr/vim-json'

Plug 'ap/vim-css-color'
Plug 'cakebaker/scss-syntax.vim'
Plug 'groenewege/vim-less'
Plug 'hail2u/vim-css3-syntax'
Plug 'othree/html5-syntax.vim', { 'for': 'html' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'gavocanov/vim-js-indent', { 'for': 'javascript' }
Plug 'othree/yajs.vim', { 'for': 'javascript' }
Plug 'ternjs/tern_for_vim', { 'for': 'javascript' }
Plug 'wavded/vim-stylus'

Plug 'plasticboy/vim-markdown'
Plug 'lvht/tagbar-markdown'
Plug 'easymotion/vim-easymotion'
Plug 'ironhouzi/vim-stim'
call plug#end() " }}}

filetype plugin indent on
syntax on
color molokai
set cursorline
set linebreak
"set list
set fileformat=unix
set fileencodings=utf-8,gbk
set nospell
set noswapfile
set nobackup
set ignorecase
set smartcase
set smartindent
set pastetoggle=<leader>v
set mouse-=a
" clear search highlight by type enter
nnoremap <CR> :noh<CR><CR>
" 退格键删除
set backspace=indent,eol,start

func! ExpandTab(len)
	setlocal expandtab
	execute 'setlocal shiftwidth='.a:len
	execute 'setlocal softtabstop='.a:len
	execute 'setlocal tabstop='.a:len
endfunc
autocmd FileType html,scss call ExpandTab(2)
autocmd FileType go,php,python,json,nginx,css,javascript call ExpandTab(4)
" 花括号之后回车光标自动缩进
inoremap {<CR> {<CR>}<ESC>O
" 中括号之后回车光标自动缩进
inoremap [<CR> [<CR>]<ESC>O

" let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '|'
set laststatus=2

" scaledoc comments
let g:scala_scaladoc_indent = 1
"设置python
let g:ycm_server_python_interpreter = '/usr/local/Cellar/python3/3.6.3/bin/python3'

autocmd FileType vim setlocal foldmethod=marker
" 将光标跳转到上次打开当前文件的位置 {{{
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
			\ execute "normal! g`\"" |
			\ endif " }}}
" 清理行尾空白字符，md 文件除外 {{{
autocmd BufWritePre * if &filetype != 'markdown' |
			\ :%s/\s\+$//e |
			\ endif " }}}

" 语法检测
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_html_tidy_exec = 'tidy'
let g:syntastic_php_checkers = ['php']

" 注释相关
let g:doxygenToolkit_authorName="wuxiongjie@qutoutiao.net"
let g:doxygenToolkit_briefTag_funcName="yes"
map <leader>a :DoxAuthor<CR>
map <leader>c :Dox<CR>
map <leader>d :DoxBlock<CR>

" Tagbar
nnoremap <silent> <leader>t :TagbarToggle<CR>

" NERD Tree
nnoremap <silent> <leader>e :NERDTreeToggle<CR>
nnoremap <silent> <leader>f :NERDTreeFind<CR>
" 所有编辑窗口关闭后自动关闭 NERDTree
autocmd bufenter * if (winnr("$") == 1 && &filetype == 'nerdtree') | q | endif

" PHPCD
autocmd CompleteDone * pclose " 补全完成后自动关闭预览窗口
autocmd FileType php setlocal omnifunc=phpcd#CompletePHP
autocmd FileType php setlocal iskeyword-=$
" 补全窗口点击回车选择
inoremap <expr> <CR>       pumvisible()?"\<C-Y>":"\<CR>"

" vim-markdown
let g:vim_markdown_folding_disabled=1
let g:vim_markdown_frontmatter=1

let g:deoplete#enable_at_startup = 1

let g:ackprg = 'ag --vimgrep'

syntax enable
set background=dark
colorscheme solarized

" fzf {{{
if !exists('LV_MRU_LIST_JSON')
	let LV_MRU_LIST_JSON = '[]'
endif
let g:lv_mru_list = json_decode(LV_MRU_LIST_JSON)

nnoremap <silent> <C-p> :FZF<CR>
nnoremap <silent> <C-u> :call ListMruFile()<CR>


function! ListMruFile()
	let files = map(copy(g:lv_mru_list), 'fnamemodify(v:val, ":~:.")')
	let file_len = len(files)
	if file_len == 0
		return
	elseif file_len > 10
		let file_len = 10
	endif
	let file_len = file_len + 2
	call fzf#run({
			\ 'source': files,
			\ 'sink': 'edit',
			\ 'options': '-m -x +s',
			\ 'down': file_len})
endfunction

function! s:RecordMruFile()
	let cpath = expand('%:p')
	if !filereadable(cpath)
		return
	endif
	if cpath =~ 'fugitive'
		return
	endif
	let idx = index(g:lv_mru_list, cpath)
	if idx >= 0
		call filter(g:lv_mru_list, 'v:val !=# cpath')
	endif
	if cpath != ''
		call insert(g:lv_mru_list, cpath)
	endif
endfunction

function! s:ClearCurretnFile()
	let cpath = expand('%:p')
	let idx = index(g:lv_mru_list, cpath)
	if idx >= 0
		call remove(g:lv_mru_list, idx)
	end
endfunction

autocmd BufEnter * call s:ClearCurretnFile()
autocmd BufWinLeave,BufWritePost * call s:RecordMruFile()
autocmd VimLeavePre * let LV_MRU_LIST_JSON = json_encode(g:lv_mru_list)
" }}}

" bison {{{
function! GoToYaccRule()
	let name = expand('<cword>')
	let pattern = "^".name.":"
	call search(pattern, "swp")
endfunction
autocmd FileType yacc nnoremap <C-]> :call GoToYaccRule()<CR>
" }}}
