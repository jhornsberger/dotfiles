lua << END
-- Plugins via Packer
require('packer').startup(function(use)
   -- Packer can manage itself
   use 'wbthomason/packer.nvim'
   use 'preservim/tagbar'
   use 'haya14busa/vim-asterisk'
   use 'overcache/NeoSolarized'
   use 'tpope/vim-fugitive'
   -- Add/change/delete surrounding delimiter pairs with ease
   use({
      'kylechui/nvim-surround',
      config = function()
          require('nvim-surround').setup({})
      end
   })
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
   -- Extensible Neovim Scrollbar
   use 'petertriho/nvim-scrollbar'
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
vim.opt.diffopt:append( { 'vertical', 'algorithm:histogram', } )
vim.g.mapleader = ' '
vim.cmd.colorscheme 'NeoSolarized'

-- Autocommands
vim.api.nvim_create_augroup('config', {})

-- Highlight cursor line only in current window
vim.api.nvim_create_autocmd({'VimEnter', 'WinEnter', 'BufWinEnter'},
   { group = 'config',
     pattern = '*',
     callback = function() vim.opt_local.cursorline = true end, })
vim.api.nvim_create_autocmd({'WinLeave'},
   { group = 'config',
     pattern = '*',
     callback = function() vim.opt_local.cursorline = false end, })

-- Always equalize windows on resize
vim.api.nvim_create_autocmd({'VimResized'},
   { group = 'config',
     pattern = '*',
     command = 'wincmd =', })

-- Treat *.*tin files as C++
vim.api.nvim_create_autocmd({'BufNewFile', 'BufReadPost'},
   { group = 'config',
     pattern = '*.*tin',
     callback = function() vim.opt_local.filetype = 'cpp' end, })

-- Set textwidth for programming
vim.api.nvim_create_autocmd({'FileType'},
   { group = 'config',
     pattern = { 'tac', 'cpp', 'python', },
     callback = function() vim.opt_local.textwidth = 85 end,
     nested = true, })

-- Better indenting for tac files
vim.api.nvim_create_autocmd({'FileType'},
   { group = 'config',
     pattern = 'tac',
     callback = function()
         vim.opt_local.cindent = false
         vim.opt_local.smartindent = true
      end, })

-- Treat *.md files as markdown instead of Modula-2
vim.api.nvim_create_autocmd({'BufNewFile', 'BufReadPost'},
   { group = 'config',
     pattern = '*.md',
     callback = function()
         vim.opt_local.filetype = 'markdown'
         vim.opt_local.textwidth = 0
      end,
     nested = true, })

-- Special textwidth gitcommit
vim.api.nvim_create_autocmd({'FileType'},
   { group = 'config',
     pattern = 'gitcommit',
     callback = function() vim.opt_local.textwidth = 72 end,
     nested = true, })

-- Set colorcolumn to match textwidth
vim.api.nvim_create_autocmd({'OptionSet'},
   { group = 'config',
     pattern = 'textwidth',
     callback = function()
        vim.api.nvim_set_option_value( 'colorcolumn',
           tostring( vim.o.textwidth ), {} )
        end, })

-- Maximum number of lines kept beyond the visible terminal screen
vim.api.nvim_create_autocmd({'TermOpen'},
   { group = 'config',
     pattern = '*',
     callback = function()
        vim.opt_local.scrollback = 100000
        end, })
-- Insert text in the same position as where Insert mode was stopped last time
-- in the current buffer
vim.api.nvim_create_autocmd({'TermOpen'},
   { group = 'config',
     pattern = '*',
     callback = function()
        vim.keymap.set('n', '<cr>', 'gi',
           { noremap = true, silent = true, buffer = 0 })
        end, })

-- Mappings
vim.keymap.set({'n', 'v', 'o'}, 'Y', 'y$', { noremap = true })
vim.keymap.set('n', '<C-J>', '<C-W><C-J>', { noremap = true })
vim.keymap.set('n', '<C-K>', '<C-W><C-K>', { noremap = true })
vim.keymap.set('n', '<C-L>', '<C-W><C-L>', { noremap = true })
vim.keymap.set('n', '<C-H>', '<C-W><C-H>', { noremap = true })
vim.keymap.set('n', '<Leader>tc', '<cmd>tabclose<cr>',
   { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>tC', ':tabclose<space>', { noremap = true })
vim.keymap.set('n', '<Leader>tn', '<cmd>tabnew<cr>',
   { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>to', '<cmd>tabonly<cr>',
   { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>te', ':tabedit<space>', { noremap = true })
vim.keymap.set('n', '<Leader>tm', ':tabmove<space>', { noremap = true })
vim.keymap.set('n', '<Leader>L', function()
   current = vim.api.nvim_get_option_value( 'colorcolumn', {} )
   if current == "" then
      vim.api.nvim_set_option_value( 'colorcolumn',
         tostring( vim.o.textwidth ), {} )
   else
      vim.api.nvim_set_option_value( 'colorcolumn', "", {} )
   end
   end, { noremap = true })
vim.keymap.set('n', '<Leader>co', '<cmd>copen<cr>',
   { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>cc', '<cmd>cclose<cr>',
   { noremap = true, silent = true })
vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })
vim.keymap.set('n', '<Leader>//', '<cmd>nohlsearch<cr>',
   { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>ms', '<cmd>mksession! ~/.vim_session<cr>',
   { noremap = true })
vim.keymap.set('n', '<Leader>ls', '<cmd>source ~/.vim_session<cr>',
   { noremap = true })
vim.keymap.set('n', '<Leader>|', '<cmd>vsplit<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>-', '<cmd>split<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>=', '<C-w>=', { noremap = true })
vim.keymap.set('n', '<Leader>mh', '<cmd>vertical resize<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>mv', '<cmd>resize<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>ma', '<cmd>resize | vertical resize<cr>',
   { noremap = true })
vim.keymap.set('n', '<Leader>O', '<cmd>only<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>c', '<cmd>close<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>D', '<cmd>bp|bd #<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>DC', '<cmd>bp|bd #|close<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>DD', '<cmd>bp!|bd! #<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>DDC', '<cmd>bp!|bd! #|close<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>sp', '<cmd>set paste!<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>R', '<cmd>redraw!<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>sn', '<cmd>set number!<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>w', '<cmd>set wrap!<cr>', { noremap = true })
-- Yank register to another register
vim.keymap.set('n', 'yr', function()
      sourceReg = vim.fn.nr2char( vim.fn.getchar() )
      targetReg = vim.v.register
      sourceRegInfo = vim.fn.getreginfo( sourceReg )
      vim.fn.setreg( targetReg, sourceRegInfo )
   end, { noremap = true })
-- Open file under cursor in vertical split
vim.keymap.set('n', '<C-W><C-F>', '<C-W>vgf', { noremap = true })
vim.keymap.set('n', '<Leader>j', '<cmd>pedit +$ `job -g <cword>`<cr>',
   { noremap = true })
vim.keymap.set('n', '<Leader>J', '<cmd>edit +$ `job -g <cword>`<cr>',
   { noremap = true })
vim.keymap.set('n', '<Leader>jf',
   '<cmd>split | terminal less +F `job -g <cword>`<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>JF', '<cmd>terminal less +F `job -g <cword>`<cr>',
   { noremap = true })

-- Generate opengrok/src links
vim.keymap.set('n', '<Leader>og', function()
   print( 'https://opengrok.infra.corp.arista.io/source/xref/eos-trunk'
          .. vim.fn.expand( '%:p' ) ) end, { noremap = true, silent = true } )
vim.keymap.set('n', '<Leader>ogl', function()
   print( 'https://opengrok.infra.corp.arista.io/source/xref/eos-trunk'
          .. vim.fn.expand( '%:p' ) .. '#' .. vim.fn.line( '.' ) ) end,
   { noremap = true, silent = true } )
vim.keymap.set('v', '<Leader>ogl', function()
   print( 'https://opengrok.infra.corp.arista.io/source/xref/eos-trunk' ..
          vim.fn.expand( '%:p' ) ..
          '#' ..
          vim.fn.line( "'<" ) ..
          '-' ..
          vim.fn.line( "'>" ) ) end,
   { noremap = true, silent = true } )
vim.keymap.set('n', '<Leader>s', function()
   local pathList = vim.fn.split( vim.fn.expand( '%:p' ), '/' )
   local package = pathList[ 2 ]
   local restOfPathList = { unpack( pathList, 3, #pathList ) }
   local restOfPath = vim.fn.join( restOfPathList, '/' )
   print( 'https://src.infra.corp.arista.io/' ..
          package ..
          '/eos-trunk/' ..
          restOfPath ) end, { noremap = true, silent = true } )
vim.keymap.set('n', '<Leader>sl', function()
   local pathList = vim.fn.split( vim.fn.expand( '%:p' ), '/' )
   local package = pathList[ 2 ]
   local restOfPathList = { unpack( pathList, 3, #pathList ) }
   local restOfPath = vim.fn.join( restOfPathList, '/' )
   print( 'https://src.infra.corp.arista.io/' ..
          package ..
          '/eos-trunk/' ..
          restOfPath ..
          '#line-' ..
          vim.fn.line( '.' ) ) end, { noremap = true, silent = true } )

-- Terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('t', '<C-J>', '<Cmd>wincmd j<cr>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-K>', '<Cmd>wincmd k<cr>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-L>', '<Cmd>wincmd l<cr>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-H>', '<Cmd>wincmd h<cr>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-r><C-r>', function()
      return '<C-\\><C-N>"' .. vim.fn.nr2char( vim.fn.getchar() ) .. 'pi'
   end, { noremap = true, expr = true })
vim.keymap.set('n', '<Leader>tth', '<Cmd>terminal<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>tts', '<Cmd>split | terminal<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>ttv', '<Cmd>vsplit | terminal<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>ttt', '<Cmd>tabnew | terminal<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>TTH', ':terminal<space>', { noremap = true })
vim.keymap.set('n', '<Leader>TTS', ':split | terminal<space>', { noremap = true })
vim.keymap.set('n', '<Leader>TTV', ':vsplit | terminal<space>', { noremap = true })
vim.keymap.set('n', '<Leader>TTT', ':tabnew | terminal<space>', { noremap = true })
END

" define a group `vimrc` and initialize.
augroup vimrc
   autocmd!
augroup END

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
      targets = {
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

lua << END
-- nvim-scrollbar
require("scrollbar").setup({show_in_active_only = true})

require('gitsigns').setup({
   worktrees = {
      {
         toplevel = vim.env.HOME,
         gitdir = vim.env.HOME .. '/.cfg',
      },
   }})
require("scrollbar.handlers.gitsigns").setup()
vim.keymap.set('n', '<Leader>gst',
   function() require('gitsigns').toggle_signs() end, { noremap = true })
vim.keymap.set('n', '<Leader>gsp',
   function() require('gitsigns').preview_hunk_inline() end,
   { noremap = true })
vim.keymap.set('n', '<Leader>gsd', ':Gitsigns diffthis<space>',
   { noremap = true })
vim.keymap.set({'n', 'x'}, '<Leader>gss',
   function() require('gitsigns').stage_hunk() end, { noremap = true })
vim.keymap.set({'n', 'x'}, '<Leader>gsr',
   function() require('gitsigns').reset_hunk() end, { noremap = true })
vim.keymap.set('n', '<Leader>gsb', ':Gitsigns change_base<space>',
   { noremap = true })
vim.keymap.set({'n', 'x'}, ']c', function()
   if vim.wo.diff then return ']c' end
   vim.schedule(function() require('gitsigns').next_hunk() end)
   return '<Ignore>'
 end, {expr=true})
vim.keymap.set({'n', 'x'}, '[c', function()
   if vim.wo.diff then return '[c' end
   vim.schedule(function() require('gitsigns').prev_hunk() end)
   return '<Ignore>'
 end, {expr=true})

-- leap.nvim
-- <Plug>(leap-forward-to) is incorrectly defined to be { offset = 1 } outside of Normal mode
vim.keymap.set({"n", "x", "o"}, "f", function()
   require('leap').leap( { offset = 0 } ) end)
vim.keymap.set({"n", "x", "o"}, "F", "<Plug>(leap-backward-to)")
vim.keymap.set({"n", "x", "o"}, "t", "<Plug>(leap-forward-till)")
-- <Plug>(leap-backward-till) is incorrectly defined to be { backward = true, offset = 2 }
vim.keymap.set({"n", "x", "o"}, "T", function()
   require('leap').leap( { backward = true, offset = 1 } ) end)
END
