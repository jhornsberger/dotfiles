lua << END
-- Plugins via Packer
require('packer').startup(function(use)
   -- Packer can manage itself
   use 'wbthomason/packer.nvim'
   use 'majutsushi/tagbar'
   use 'haya14busa/vim-asterisk'
   use 'overcache/NeoSolarized'
   use 'tpope/vim-fugitive'
   use 'tpope/vim-surround'
   use 'kana/vim-textobj-user'
   use 'bps/vim-textobj-python'
   use 'kana/vim-textobj-diff'
   use 'tpope/vim-eunuch'
   -- Improved fzf.vim written in lua
   use 'ibhagwan/fzf-lua'
   use 'git@gitlab.aristanetworks.com:jeff/vim-alog.git'
   use 'git@gitlab.aristanetworks.com:the_third_man/arvim.git'
   use 'itchyny/lightline.vim'
   use 'google/vim-maktaba'
   use 'google/vim-codefmt'
   use 'google/vim-glaive'
   use 'rbong/vim-flog'
   -- Tame the quickfix window
   use 'romainl/vim-qf'
   use 'wfxr/minimap.vim'
   use 'ggandor/leap.nvim'
   use 'tpope/vim-repeat'
   -- easily search for, substitute, and abbreviate multiple variants of a word
   use 'tpope/vim-abolish'
   -- Git integration for buffers
   use 'lewis6991/gitsigns.nvim'
end)

-- Options
vim.o.shiftwidth = 3
vim.o.tabstop = 3
vim.o.linebreak = true
vim.o.cindent = true
vim.o.expandtab = true
vim.o.virtualedit = 'all'
vim.o.mouse='a'
vim.o.directory = '/tmp'
vim.o.foldmethod = 'syntax'
vim.o.foldenable = false
vim.o.termguicolors = true
vim.o.background = 'light'
vim.o.visualbell = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrapscan = false
vim.o.lazyredraw = true
vim.o.path = '**'
vim.o.numberwidth = 1
vim.o.previewheight = 20
vim.o.splitbelow = true
vim.cmd.colorscheme 'NeoSolarized'

-- Highlight cursor line only in current window
vim.api.nvim_create_augroup("CursorLine", {})
vim.api.nvim_create_autocmd({"VimEnter", "WinEnter", "BufWinEnter"},
   { group = "CursorLine",
     pattern = '*',
     callback = function() vim.opt_local.cursorline = true end, })
vim.api.nvim_create_autocmd({"WinLeave"},
   { group = "CursorLine",
     pattern = '*',
     callback = function() vim.opt_local.cursorline = false end, })
END

" define a group `vimrc` and initialize.
augroup vimrc
   autocmd!
augroup END

" Always equalize windows on resize
autocmd vimrc VimResized * wincmd =

" Options for vimdiff
set diffopt+=vertical,algorithm:histogram

" Automatically diffupdate on write
autocmd vimrc BufWritePost * if &diff == 1 | diffupdate | endif

" Always move some windows to the bottom
autocmd vimrc FileType qf wincmd J
"autocmd vimrc FileType gitcommit wincmd J

" Set textwidth for programming
autocmd vimrc FileType tac,cpp,python ++nested setlocal textwidth=85

autocmd vimrc FileType tac set nocindent | set smartindent

" Treat *.md files as markdown instead of Modula-2
autocmd vimrc BufNewFile,BufReadPost *.md set filetype=markdown
autocmd vimrc BufNewFile,BufReadPost *.md ++nested setlocal textwidth=0

" Special textwidth gitcommit
autocmd vimrc FileType gitcommit ++nested setlocal textwidth=72

" Treat *.*tin files as C++
autocmd vimrc BufNewFile,BufReadPost *.*tin set filetype=cpp

" Longer lines in go files
autocmd vimrc FileType go ++nested setlocal textwidth=100

" Set colorcolumn to match textwidth
autocmd vimrc OptionSet textwidth let &l:colorcolumn=&l:textwidth

" Mappings
let g:mapleader = "\<Space>"
map Y y$
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <silent><Leader>tc :tabclose<return>
nnoremap <Leader>tC :tabclose<space>
nnoremap <silent><Leader>tn :tabnew<return>
nnoremap <silent><Leader>to :tabonly<return>
nnoremap <Leader>te :tabedit<space>
nnoremap <Leader>tm :tabmove<space>
nnoremap <Leader>L :let &colorcolumn = &colorcolumn == '' ? '85' : ''<CR>
nnoremap <Leader>co :copen<return>
nnoremap <Leader>cc :cclose<return>
nnoremap j gj
nnoremap k gk
noremap <silent><Leader>// :nohlsearch<CR>:call minimap#vim#ClearColorSearch()<CR>
nnoremap <Leader>ms :mksession! ~/.vim_session<CR>
nnoremap <Leader>ls :source ~/.vim_session<CR>
nnoremap <Leader>\| :vsp<cr>
nnoremap <Leader>- :sp<cr>
nnoremap <Leader>= <C-w>=
nnoremap <Leader>mh :vertical resize<cr>
nnoremap <Leader>mv :resize<cr>
nnoremap <Leader>ma :resize \| vertical resize<cr>
nnoremap <Leader>O :only<cr>
nnoremap <Leader>c :close<cr>
nnoremap <Leader>D :bp\|bd #<cr>
nnoremap <Leader>DC :bp\|bd #\|close<cr>
nnoremap <Leader>DD :bp!\|bd! #<cr>
nnoremap <Leader>DDC :bp!\|bd! #\|close<cr>
nnoremap <Leader>sp :set paste!<cr>
nnoremap <Leader>C :call SetColours()<cr> " Fix colors when they get messed
nnoremap <Leader>R :redraw!<cr>
"nnoremap <Leader>n :set relativenumber!<cr>
nnoremap <Leader>sn :set number!<cr>
nnoremap <Leader>w :set wrap!<cr>
nnoremap <C-W><C-F> <C-W>vgf " Open file under cursor in vertical split
nnoremap <Leader>j :pedit +$ `job -g <cword>`<cr>
nnoremap <Leader>J :edit +$ `job -g <cword>`<cr>
nnoremap <Leader>jf :split \| terminal less +F `job -g <cword>`<cr>
nnoremap <Leader>JF :terminal less +F `job -g <cword>`<cr>

" Generate opengrok/src links
noremap <silent><Leader>og :<C-u>echo 'https://opengrok.infra.corp.arista.io/source/xref/eos-trunk' . expand( '%:p' )<cr>
nnoremap <silent><Leader>ogl :echo 'https://opengrok.infra.corp.arista.io/source/xref/eos-trunk' . expand( '%:p' ) . '#' . line( '.' )<cr>
vnoremap <silent><Leader>ogl :<C-u>echo 'https://opengrok.infra.corp.arista.io/source/xref/eos-trunk' . expand( '%:p' ) . '#' . line( "'<" ) . '-' . line( "'>" )<cr>
noremap <silent><Leader>s :<C-u>echo 'https://src.infra.corp.arista.io/' . split( expand( '%:p' ), '\/' )[ 1 ] . '/eos-trunk/' . join( split( expand( '%:p' ), '\/' )[ 2:-1 ], '/' )<cr>
noremap <silent><Leader>sl :<C-u>echo 'https://src.infra.corp.arista.io/' . split( expand( '%:p' ), '\/' )[ 1 ] . '/eos-trunk/' . join( split( expand( '%:p' ), '\/' )[ 2:-1 ], '/' ) . '#' . line( '.' )<cr>

" Terminal
if has( "nvim" )
   tnoremap <Esc><Esc> <C-\><C-n>
   tnoremap <silent><C-J> <Cmd>wincmd j<cr>
   tnoremap <silent><C-K> <Cmd>wincmd k<cr>
   tnoremap <silent><C-L> <Cmd>wincmd l<cr>
   tnoremap <silent><C-H> <Cmd>wincmd h<cr>
	tnoremap <expr> <C-r><C-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
   autocmd vimrc TermOpen * setlocal scrollback=100000
   autocmd vimrc TermOpen * nnoremap <buffer> <silent><cr> gi

   nnoremap <silent><Leader>tth :terminal<cr>
   nnoremap <silent><Leader>tts :split \| terminal<cr>
   nnoremap <silent><Leader>ttv :vsplit \| terminal<cr>
   nnoremap <silent><Leader>ttt :tabnew \| terminal<cr>
   nnoremap <Leader>TTH :terminal<space>
   nnoremap <Leader>TTS :split \| terminal<space>
   nnoremap <Leader>TTV :vsplit \| terminal<space>
   nnoremap <Leader>TTT :tabnew \| terminal<space>
elseif has( "terminal" )
   tnoremap <Esc><Esc> <C-W>N
   tnoremap <silent><C-J> <C-W>j
   tnoremap <silent><C-K> <C-W>k
   tnoremap <silent><C-L> <C-W>l
   tnoremap <silent><C-H> <C-W>h
   autocmd vimrc TerminalOpen * if &buftype == 'terminal' | nnoremap <buffer> <silent><cr> gi | endif
   set termwinscroll=100000

   nnoremap <silent><Leader>tts :terminal<cr>
   nnoremap <silent><Leader>ttv :vertical terminal<cr>
   nnoremap <silent><Leader>tth :terminal ++curwin<cr>
   nnoremap <silent><Leader>ttt :tab terminal<cr>
   nnoremap <Leader>TTS :terminal<space>
   nnoremap <Leader>TTV :vertical terminal<space>
   nnoremap <Leader>TTH :terminal ++curwin<space>
   nnoremap <Leader>TTT :tab terminal<space>
endif

" Show hidden characters
nnoremap <silent><Leader>H :set list!<cr>

" Copy selected lines or complete file to Arista pb (http://pb/)
command! -range=% Pb :<line1>,<line2>w !curl -F c=@- pb

" netrw settings
let g:netrw_localrmdir='rm -r'
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_browse_split = 2
let g:netrw_http_cmd="wget --compression=auto -O"

" Tagbar plugin
map <Leader>tb :TagbarToggle<CR>
let g:tagbar_compact = 1
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
let g:tagbar_position = 'leftabove vertical'
let g:tagbar_sort = 0
let g:tagbar_type_tac = {
   \ 'ctagstype' : 'tacc',
   \ 'kinds'     : [
       \ 'd:definition'
   \ ],
   \ 'sort'    : 0
\ }

" vim-asterisk plugin
map <silent> *  <Plug>(asterisk-z*)
map <silent> #  <Plug>(asterisk-z#)
map <silent> g* <Plug>(asterisk-gz*)
map <silent> g# <Plug>(asterisk-gz#)

" Fugitive plugin
command -nargs=1 GitDir silent cd <args> | topleft vertical Git | cd- | lcd <args>
map <Leader>gs :topleft vertical Git<cr>
map <Leader>gsd :GitDir<space>
map <Leader>ge :Gedit<space>
map <Leader>gd :Gdiffsplit<space>
map <Leader>ged :Gedit \| windo difft<cr>
map <Leader>gc :Git commit<space>
map <Leader>gb :Git blame<cr>
map <Leader>G :Git<space>

"" DirDiff plugin
"" ignore white space in diff
"let g:DirDiffAddArgs = "-w"

"" Fzf
"let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.4, 'yoffset': 1 } }
"command! -bang -nargs=* -complete=file Rg
"\ call fzf#vim#grep(
"\   'rg --vimgrep '.<q-args>, 1,
"\   <bang>0 ? fzf#vim#with_preview('up:60%')
"\           : fzf#vim#with_preview('right:50%:hidden', '?'),
"\   <bang>0)
"map <Leader>f :Files<cr>
"map <Leader>F :Files<space>
"map <Leader>b :Buffers<cr>
"map <Leader>bt :BTags<cr>
"map <Leader>BT :BTags<space>
"map <Leader>t :Tags<cr>
"map <Leader>T :Tags<space>
"map <Leader>W :Windows<cr>
"map <Leader>g :Rg<space>
"map <Leader>bl :BLines<cr>
"map <Leader>h :Helptags<cr>
"map <Leader>: :History:<cr>
"map <Leader>/ :History/<cr>

lua << END
-- fzf-lua plugin
require('fzf-lua').setup{
  winopts = {
    width = 1,
    height = 0.4,
    row = 1,
    col = 0,
  },
  fzf_opts = {
     [ '--layout' ] = false,
  },
}

vim.api.nvim_create_user_command(
   'FzfRg',
   function(opts)
      require('fzf-lua').grep({
         search = '',
         cmd = 'rg --vimgrep ' .. opts.args,
         no_esc = 2,
      })
   end,
   { nargs = '+', complete = 'file' })

vim.api.nvim_create_user_command(
   'FzfFiles',
   function(opts)
      fzfLuaOpts = {}
      if opts.fargs[1] ~= nil then
         fzfLuaOpts.cwd = opts.fargs[1]
      end
      require('fzf-lua').files(fzfLuaOpts)
   end,
   { nargs = '?', complete = 'file' })

local otherFiles = function( mappings )
   local bufFile = vim.api.nvim_buf_get_name( 0 )
   local targetFiles = {}
   local numTargetFiles = 0
   for _, mapping in ipairs( mappings ) do
      local match = bufFile:match( mapping.pattern )
      if match ~= nil then
         for _, target in ipairs( mapping.targets ) do
            local glob = bufFile:gsub( mapping.pattern, target )
            local globFiles = vim.fn.glob( glob, true, true )
            for _, file in ipairs( globFiles ) do
               -- Maintain the order of matches by mapping to the index that should
               -- be used for each match. This way users can order targets by most
               -- prefered. Below this table is turned inside out into an array.
               if targetFiles[ file ] == nil then
                  targetFiles[ file ] = numTargetFiles + 1
                  numTargetFiles = numTargetFiles + 1
               end
            end
         end
      end
   end
   
   -- Normalize the "set" to a list
   targets = {}
   for file, i in pairs( targetFiles ) do
      targets[ i ] = file
   end
   return targets
end

local fzfFileListFunc = function(opts)
   local config = require( 'fzf-lua.config' )
   local core = require( "fzf-lua.core" )
   opts = config.normalize_opts( opts, config.globals.files )
   if not opts then return end
   local contents = opts.cmd()
   opts = core.set_header( opts, opts.headers )
   return core.fzf_exec( contents, opts )
end

local tacTarget = "%1/%2.tac"
local tinTarget = "%1/%2.tin"
local itinTarget = "%1/%2.itin"
local testTarget = "%1/test/%2Test*.py"
local otherMappings = {{
      pattern = "(.*)/(.*).tac",
      targets = {
         tinTarget,
         itinTarget,
         testTarget,
      }
   },{
      pattern = "(.*)/(.*).tin",
      targets = {
         tacTarget,
         itinTarget,
         testTarget,
      }
   },{
      pattern = "(.*)/(.*).itin",
      targets = {
         tacTarget,
         tinTarget,
         testTarget,
      }
   },{
      pattern = "(.*)/test/(.*)Tests?.py",
      targets = {
         tacTarget,
         tinTarget,
         itinTarget,
      }
   },{
      pattern = "(.*)/(.*).h",
      targets = {
         "%1/%2.cpp",
      }
   },{
      pattern = "(.*)/(.*).cpp",
      target = {
         "%1/%2.h",
      }
   },}

vim.keymap.set('n', '<Leader>r', "<cmd>lua require('fzf-lua').resume()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>f', "<cmd>FzfFiles<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>F', ":FzfFiles<space>", { noremap = true })
vim.keymap.set('n', '<Leader>b', "<cmd>lua require('fzf-lua').buffers()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>bt', "<cmd>lua require('fzf-lua').btags({ ctags_autogen = true })<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>t', "<cmd>lua require('fzf-lua').tags_live_grep()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>g', ":FzfRg<space>", { noremap = true })
vim.keymap.set('n', '<Leader>bl', "<cmd>lua require('fzf-lua').blines()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>h', "<cmd>lua require('fzf-lua').help_tags()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>:', "<cmd>lua require('fzf-lua').command_history()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>/', "<cmd>lua require('fzf-lua').search_history()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>of',
   function()
      fzfFileListFunc( {
         prompt = 'OtherFiles❯ ',
         cmd = function()
            return otherFiles( otherMappings )
         end,
      } )
   end,
   { noremap = true, silent = true })
END

" vim-textobj-diff plugin
"let g:textobj_diff_no_default_key_mappings = 1
nmap <silent> ]df <Plug>(textobj-diff-file-n)
nmap <silent> [df <Plug>(textobj-diff-file-p)
nmap <silent> ]dh <Plug>(textobj-diff-hunk-n)
nmap <silent> [dh <Plug>(textobj-diff-hunk-p)

" vim-fswitch plugin
"let g:fsnonewfiles = 'on'
"autocmd vimrc BufEnter *.*tin let b:fswitchdst = 'tac' | let b:fswitchlocs = './'
"autocmd vimrc BufEnter *.tac let b:fswitchdst = 'tin,itin' | let b:fswitchlocs = './'
"nmap <silent> <Leader>of :FSHere<cr>

lua << END
---- other.nvim plugin
--tacTarget = { target = "%1/%2.tac", context = "tac", }
--tinTarget = { target = "%1/%2.tin", context = "tin", }
--itinTarget = { target = "%1/%2.itin", context = "itin", }
--testTarget = { target = "%1/test/%2Test?.py", context = "test", }
--
--require("other-nvim").setup({
--   mappings = {{
--            pattern = "(.*)/(.*).tac",
--            target = {
--               tinTarget,
--               itinTarget,
--               testTarget,
--            }
--         },{
--            pattern = "(.*)/(.*).tin",
--            target = {
--               tacTarget,
--               itinTarget,
--               testTarget,
--            }
--         },{
--            pattern = "(.*)/(.*).itin",
--            target = {
--               tacTarget,
--               tinTarget,
--               testTarget,
--            }
--         },{
--            pattern = "(.*)/test/(.*)Tests?.py",
--            target = {
--               tacTarget,
--               tinTarget,
--               itinTarget,
--            }
--         },{
--            pattern = "(.*)/(.*).h",
--            target = "%1/%2.cpp",
--            context = "cpp"
--         },{
--            pattern = "(.*)/(.*).cpp",
--            target = "%1/%2.h",
--            context = "header"
--         },
--      },
--   rememberBuffers = false,
--})
--
--vim.keymap.set("n", "<leader>o", "<cmd>:Other<CR>", { noremap = true, silent = true })
--vim.keymap.set("n", "<leader>os", "<cmd>:OtherSplit<CR>", { noremap = true, silent = true })
--vim.keymap.set("n", "<leader>ov", "<cmd>:OtherVSplit<CR>", { noremap = true, silent = true })
END

" arvim plugin
let a4_auto_edit = 0

" Lightline plugin
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
		\   'right': [ [ 'lineinfo' ],
		\              [ 'percent' ],
		\              [ 'gitbranch', 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" vim-alog plugin
autocmd vimrc BufNewFile,BufReadPost *.log nnoremap <buffer> <Leader>al :set filetype=alog<cr>

" jk-jumps plugin
let g:jk_jumps_minimum_lines = 2

" Flog plugin
nnoremap <Leader>gl :Flog -date=local<cr>
command -nargs=1 FlogDir silent cd <args> | execute 'Flog -date=local' | cd- | lcd <args>
nnoremap <Leader>gld :FlogDir<space>
lua << END
vim.api.nvim_create_autocmd("FileType", {
   group = "vimrc",
   pattern = "floggraph",
   callback = function ( args )
      vim.keymap.set("n", "<leader>aco", function()
            vim.api.nvim_call_function("flog#run_command", {"!agu checkout %b", 0, 1})
         end, { buffer = true } )
   end})
END

" vim-qf plugin
nmap <silent><c-p> <Plug>(qf_qf_previous)
nmap <silent><c-n> <Plug>(qf_qf_next)

" minimap
map <Leader>mm :MinimapToggle<cr>
let g:minimap_highlight_range = 1
let g:minimap_git_colors = 1

lua << END
require('gitsigns').setup()
vim.keymap.set('n', '<Leader>gS', function() require('gitsigns').toggle_signs() end, { noremap = true })
vim.keymap.set('n', '<Leader>gp', function() require('gitsigns').preview_hunk_inline() end, { noremap = true })
vim.keymap.set('n', ']c', function()
   if vim.wo.diff then return ']c' end
   vim.schedule(function() require('gitsigns').next_hunk() end)
   return '<Ignore>'
 end, {expr=true})
vim.keymap.set('n', '[c', function()
   if vim.wo.diff then return '[c' end
   vim.schedule(function() require('gitsigns').prev_hunk() end)
   return '<Ignore>'
 end, {expr=true})
END

"" vim-oscyank
"let g:oscyank_term = 'default'
"autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg +' | endif

" leap.nvim
lua << EOF
leap = require('leap')
-- leap.add_default_mappings()
vim.keymap.set({"n", "x", "o"}, "f", "<Plug>(leap-forward-to)")
vim.keymap.set({"n", "x", "o"}, "F", "<Plug>(leap-backward-to)")
vim.keymap.set({"n", "x", "o"}, "t", "<Plug>(leap-forward-till)")
vim.keymap.set({"n", "x", "o"}, "T", "<Plug>(leap-backward-till)")
-- vim.keymap.set({"n", "x", "o"}, "gf", "<Plug>(leap-cross-window)")
EOF
