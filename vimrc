"------------------------
" General Vim Settings
" --------------------

set nocompatible

" Need to set the leader before defining any leader mappings
let mapleader = "\<Space>"

filetype plugin indent on

set backspace=2      " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile
set history=50
set ruler            " show the cursor position all the time
set showcmd          " display incomplete commands
set incsearch        " do incremental searching
set laststatus=2     " Always display the status line
set autowrite        " Automatically :write before running commands
set formatoptions-=t " Don't auto-break long lines (re-enable this for prose)

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Display relative line numbers, with absolute line number for current line
set number
""set numberwidth=5
""set relativenumber
"":set number relativenumber

":augroup numbertoggle
"":  autocmd!
"":  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"":  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
"":augroup END

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" Copy file path
nnoremap <mapleader>u :let @+=expand('%')<CR>

" Unhighlight
nnoremap <mapleader>q :nohlsearch<CR>o

" vim:ft=vim

let g:instant_markdown_autostart = 0

inoremap jk <ESC>


"------------------------
" Completion related settings
"------------------------
" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" vim:ft=vim

"------------------------
" Convience - configs & mappings to smooth out rough edges and make vim feel like home
"------------------------

" Move between wrapped lines, rather than jumping over wrapped segments
nmap j gj
nmap k gk

" Quick sourcing of the current file, allowing for quick vimrc testing
nnoremap <leader>sop :source %<cr>

nmap <leader>bi :PlugInstall<cr>

" Swap 0 and ^. I tend to want to jump to the first non-whitesapce character
" so make that the easier one to do.
nnoremap 0 ^
nnoremap ^ 0

augroup vimrcEx
  autocmd!
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

" Copy file path
nnoremap <leader>u :let @+=expand('%')<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" vim:ft=vim
"

"------------------------
" Folding configurations
"------------------------

"Enable indent folding
set foldenable
set foldmethod=indent
set foldlevel=999

" So I never use s, and I want a single key map to toggle folds, thus
" lower s = toggle <=> upper S = toggle recursive
nnoremap <leader>ff za
nnoremap <leader>FF zA

"Maps for folding, unfolding all
nnoremap <LEADER>fu zM<CR>
nnoremap <LEADER>uf zR<CR>

" vim:ft=vim

"------------------------
" Vim Search Settings
" -----------------------
"
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" vim:ft=vim

"-------------------------------------------
" Search / Substitute related configurations
"-------------------------------------------
"
"set hlsearch
"set incsearch
"set ignorecase
"set smartcase
"nnoremap <leader>sub :%s///g<left><left>
"vnoremap <leader>sub :s///g<left><left>
"
"colorscheme jellybeans
"
" vim:ft=vim

set statusline=\ %f           " Path to the file
set statusline+=\ %m          " Modified flag
set statusline+=\ %y          " Filetype
set statusline+=%=          " Switch to the right side
set statusline+=%l          " current line
set statusline+=/%L       " Total lines

" vim:ft=vim

"----------------
" Visual settings
"----------------

" Make it obvious where 80 characters is
set textwidth=100
set colorcolumn=+1

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" Open new split panes to right and bottom
set splitbelow
set splitright

" vim:ft=vim
j

" Set up vim to copy from vim to osx using yank following this
" https://evertpot.com/osx-tmux-vim-copy-paste-clipboard/

set clipboard=unnamed
"----------------
"----------------
" Intall Vim Plugins
"----------------
"------------

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

"----------------
" Ale - Asynchronous Lint Engine
"----------------

Plug 'w0rp/ale'

" Put this in vimrc or a plugin file of your own.
" After this is configured, :ALEFix will try and fix your JS code with ESLint.
let g:ale_fixers = {
\   'javascript': ['prettier','eslint'],
\}
let g:ale_javascript_prettier_options = '--single-quote --jsx-single-quote --print-width=100 --trailing-comma es5'

" Set this setting in vimrc if you want to fix files automatically on save.
" This is off by default.
let g:ale_fix_on_save = 1

" vim:ft=vim

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

"----------------
" Easy Align - operators for aligning characters across lines
"----------------

Plug 'junegunn/vim-easy-align'

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"----------------
" Auto pairs
"----------------
" Insert or delete brackets, parens, quotes in pair.
" https://github.com/jiangmiao/auto-pairs

Plug 'jiangmiao/auto-pairs'

" vim:ft=vim

"----------------
" Better Whitespace - Highlight trailing whitespace and provide command to kill
"----------------

Plug 'ntpeters/vim-better-whitespace'

nnoremap <leader>wht :StripWhitespace<cr>:w<cr>

"-------------------------------------------------------------------
" Commentary - Comment / uncomment via text operator w/ text objects
"-------------------------------------------------------------------

" vim:ft=vim

" Commentary - Comment / uncomment via text operator w/ text objects
" https://github.com/tpope/vim-commentary
" gc is the command
" Use gcc to comment out a line (takes a count), gc
"-------------------------------------------------------------------

Plug 'tpope/vim-commentary'

" vim:ft=vim

"-------------------------------------------------------------------
" Easy Clip - operators for improving copy and paste
" https://github.com/svermeulen/vim-easyclip
""
"-------------------------------------------------------------------

Plug 'svermeulen/vim-easyclip'

" NOTE As a result of the above, by default easyclip will shadow an important vim function: The Add Mark key (m)
" Therefore either you will want to use a different key for the 'cut' operator 
" (see options section below for this) or remap something else to 'add mark'. For example, 
" to use gm for 'add mark' instead of m, include the following in your vimrc

nnoremap gm m

"-------------------------------------------------------------------
" Endwise - Automatic insertion of closings like do..end
" https://github.com/tpope/vim-endwise
"-------------------------------------------------------------------

Plug 'tpope/vim-endwise'

" vim:ft=vim

"-------------------------------------------------------------------
" Eunuch - Add handful of UNIXy commands to Vim
"-------------------------------------------------------------------

Plug 'tpope/vim-eunuch'

" vim:ft=vim

"-------------------------------------------------------------------
" fzf - the fuzzy finder of all the things
" https://github.com/junegunn/fzf
"-------------------------------------------------------------------

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
let g:fzf_files_options =
  \ '--reverse ' .
  \ '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'
nnoremap <C-p> :Files<cr>
let $FZF_DEFAULT_COMMAND = 'ag -g "" --hidden'

let g:fzf_history_options =
  \ '--reverse ' .
  \ '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'
nnoremap <C-b> :History<cr>
let $FZF_DEFAULT_COMMAND = 'ag -g "" --hidden'


let branch_files_options = { 'source': '( git status --porcelain | awk ''{print $2}''; git diff --name-only HEAD $(git merge-base HEAD master) ) | sort | uniq'}
let branch_files_options_develop = { 'source': '( git status --porcelain | awk ''{print $2}''; git diff --name-only HEAD $(git merge-base HEAD develop) ) | sort | uniq'}
command! BranchFiles call fzf#run(fzf#wrap('BranchFiles',
      \ extend(branch_files_options, { 'options': g:fzf_files_options }), 0))
command! BranchFilesDevelop call fzf#run(fzf#wrap('BranchFilesDevelop',
      \ extend(branch_files_options_develop, { 'options': g:fzf_files_options }), 0))
nnoremap <silent> <leader>gp :BranchFiles<cr>


nnoremap <leader>gm :Files app/models/<cr>
nnoremap <leader>gv :Files app/views/<cr>
nnoremap <leader>gc :Files app/controllers/<cr>
nnoremap <leader>gy :Files app/assets/stylesheets/<cr>
nnoremap <leader>gj :Files app/assets/javascripts/<cr>
nnoremap <leader>gr :Files client/app/<cr>
nnoremap <leader>grs :Files client/spec/<cr>
nnoremap <leader>gs :Files spec/<cr>

function! s:all_help_files()
  return join(map(split(&runtimepath, ','), 'v:val ."\/doc\/tags"'), ' ')
endfunction
let full_help_cmd = "cat ". s:all_help_files() ." 2> /dev/null \| grep -i '^[a-z]' \| awk '{print $1}' \| sort"

nnoremap <silent> <leader>he :Helptags<cr>

" vim:ft=vim

"-------------------------------------------------------------------
" JavaScript - JS syntax and indent settings, along with JSX support
"-------------------------------------------------------------------

Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
let g:jsx_ext_required = 0

" vim:ft=vim

"-------------------------------------------------------------------
" Jellybeans colorscheme
"-------------------------------------------------------------------

Plug 'nanotech/jellybeans.vim'

" vim:ft=vim


"-------------------------------------------------------------------
" Vim mkdir - automatically make intermediate directories if needed
"-------------------------------------------------------------------

Plug 'pbrisbin/vim-mkdir'

" vim:ft=vim

"-------------------------------------------------------------------
" Rails - Add Rails navigation and related commands
"-------------------------------------------------------------------

Plug 'tpope/vim-rails'

" vim:ft=vim

"-------------------------------------------------------------------
" Rake - Additional Ruby smarts in Vim
"-------------------------------------------------------------------

Plug 'tpope/vim-rake'

" vim:ft=vim

" Repeat - Repeat custom mappings with `.`

"-------------------------------------------------------------------
Plug 'tpope/vim-repeat'
"-------------------------------------------------------------------

" vim:ft=vim

" If you've ever tried using the . command after a plugin map, you were likely disappointed to discover
" it only repeated the last native command inside that map, rather than the map as a whole. 
" That disappointment ends today. Repeat.vim remaps . in a way that plugins can tap into it.

Plug 'tpope/vim-repeat'

" vim:ft=vim

"-------------------------------------------------------------------
" Ruby - More up to date Ruby filetype settings
"-------------------------------------------------------------------

Plug 'vim-ruby/vim-ruby'

" vim:ft=vim

"-------------------------------------------------------------------
" Vim Spec Runner - Smart spec (rspec) runner
"-------------------------------------------------------------------

Plug 'gabebw/vim-spec-runner'
map <leader>s <Plug>RunFocusedSpec
map <Leader>t <Plug>RunCurrentSpecFile
map <Leader>v <Plug>RunMostRecentSpec

" Using tslime.vim:
let g:spec_runner_dispatcher = "VtrSendCommand! bin/{command}"


" vim:ft=vim

"-------------------------------------------------------------------
" Surround - Mappings for adding, removing, and changing surrounding characters
"-------------------------------------------------------------------

Plug 'tpope/vim-surround'

"-------------------------------------------------------------------
" Split join - A vim plugin that simplifies the transition between multiline and single-line code
" https://github.com/AndrewRadev/splitjoin.vim
"-------------------------------------------------------------------

Plug 'andrewradev/splitjoin.vim'

" vim:ft=vim

"-------------------------------------------------------------------
" Vim Tmux Navigator - Seamlessly navigate between vim splits and tmux panes
"-------------------------------------------------------------------

" Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-navigator'
noremap <C-f> :VtrSendLinesToRunner<cr>

" vim:ft=vim
" vim:ft=vim

"-------------------------------------------------------------------
" This is a simple vim script to send portion of text from a vim buffer to a running tmux session.
" https://github.com/jgdavey/tslime.vim
"-------------------------------------------------------------------

Plug 'jgdavey/tslime.vim'

" vim:ft=vim

"-------------------------------------------------------------------
" Vinegar - Minimal useful additions to netrw
" https://github.com/tpope/vim-vinegar
"-------------------------------------------------------------------

" This actually adds fun stuff like - to get out of file into folder

Plug 'tpope/vim-vinegar'

" vim:ft=vim

"-------------------------------------------------------------------
" Visual-star-search 
"https://github.com/nelstrom/vim-visual-star-search"
"-------------------------------------------------------------------

Plug 'nelstrom/vim-visual-star-search'

nnoremap <leader>* :call ag#Ag('grep', '--literal ' . shellescape(expand("<cword>")))<CR>
vnoremap <leader>* :<C-u>call VisualStarSearchSet('/', 'raw')<CR>:call ag#Ag('grep', '--literal ' . shellescape(@/))<CR>

" vim:ft=vim

"-------------------------------------------------------------------
" Vim Tmux Runner
" https://github.com/christoomey/vim-tmux-runner
"-------------------------------------------------------------------

nnoremap <leader>va :VtrAttachToPane<cr>
nnoremap <leader>fr :VtrFocusRunner<cr>
Plug 'christoomey/vim-tmux-runner'

"-------------------------------------------------------------------
" Emmet - Generate HTML markup from css-like selector strings
"-------------------------------------------------------------------

Plug 'mattn/emmet-vim'
let g:user_emmet_leader_key = '<c-e>'

let g:user_emmet_settings = {
\  'javascript.jsx' : {
\      'extends' : 'jsx',
\  },
\}

inoremap <C-e>e <esc>:call emmet#expandAbbr(0,"")<cr>h:call emmet#splitJoinTag()<cr>wwi
nnoremap <C-e>e :call emmet#expandAbbr(0,"")<cr>h:call emmet#splitJoinTag()<cr>ww

autocmd FileType html,css,javascript.jsx EmmetInstall

" vim:ft=vim

"-------------------------------------------------------------------
" Matchit: The matchit.vim script allows you to configure % to match more than just
" single characters.  You can match words and even regular expressions.
" https://github.com/tmhedberg/matchit
"-------------------------------------------------------------------

Plug 'tmhedberg/matchit'

" vim:ft=vim

"-------------------------------------------------------------------
" Vim-fugitive: Git Wrapper for Vim
"-------------------------------------------------------------------

Plug 'tpope/vim-fugitive'

"-------------------------------------------------------------------
" UltiSnips - The ultimate snippet solution for Vim. Send pull requests to SirVer/ultisnips
" https://github.com/sirver/UltiSnips
"-------------------------------------------------------------------

Plug 'SirVer/ultisnips'

"-------------------------------------------------------------------
" Write JavaScript ES6 easily with vim.
" https://github.com/isRuslan/vim-es6
"-------------------------------------------------------------------

"
Plug 'isRuslan/vim-es6'

" vim:ft=vim
"----------------
"----------------
" End Install Vim Plugins
"----------------
"----------------

" Initialize plugin system
call plug#end()

"----------------
"----------------
