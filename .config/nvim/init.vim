lua << END
-- Plugins via Packer
require('packer').startup(function(use)
   -- Packer can manage itself
   use 'wbthomason/packer.nvim'
   -- Vim plugin that displays tags in a window, ordered by scope
   use 'preservim/tagbar'
   -- *-Improved
   use 'haya14busa/vim-asterisk'
   -- A fixed solarized colorscheme for better truecolor support
   use 'overcache/NeoSolarized'
   -- A Git wrapper so awesome, it should be illegal
   use 'tpope/vim-fugitive'
   -- Add/change/delete surrounding delimiter pairs with ease
   use( { 'kylechui/nvim-surround',
          config = function() require('nvim-surround').setup({}) end } )
   -- Create your own text objects
   use 'kana/vim-textobj-user'
   -- Text objects for Python
   use 'bps/vim-textobj-python'
   -- Text objects for ouputs of diff
   use 'kana/vim-textobj-diff'
   -- Helpers for UNIX
   use 'tpope/vim-eunuch'
   -- Improved fzf.vim written in lua
   use 'ibhagwan/fzf-lua'
   -- Vim syntax plugin for AutoTest logs
   use 'git@gitlab.aristanetworks.com:jeff/vim-alog.git'
   -- Refactored Arista vim plugin
   use 'git@gitlab.aristanetworks.com:the_third_man/arvim.git'
   -- A light and configurable statusline/tabline plugin for Vim
   use 'itchyny/lightline.vim'
   -- Consistent Vimscript
   use 'google/vim-maktaba'
   -- Vim plugin for syntax-aware code formatting
   use 'google/vim-codefmt'
   -- Glaive is a utility for configuring maktaba plugins
   use 'google/vim-glaive'
   -- A lightweight and powerful git branch viewer for vim
   use 'rbong/vim-flog'
   -- Tame the quickfix window
   use 'romainl/vim-qf'
   -- Extensible Neovim Scrollbar
   use( { 'petertriho/nvim-scrollbar',
          config = function()
             require("scrollbar").setup({show_in_active_only = true})
          end } )
   -- Neovim's answer to the mouse
   use 'ggandor/leap.nvim'
   -- enable repeating supported plugin maps with "."
   use 'tpope/vim-repeat'
   -- easily search for, substitute, and abbreviate multiple variants of a word
   use 'tpope/vim-abolish'
   -- Git integration for buffers
   use 'lewis6991/gitsigns.nvim'
   -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more
   use( { 'jose-elias-alvarez/null-ls.nvim',
          requires = 'nvim-lua/plenary.nvim', } )
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
vim.o.updatetime = 500
vim.opt.diffopt:append( { 'vertical', 'algorithm:histogram', } )
vim.g.mapleader = ' '
vim.cmd.colorscheme 'NeoSolarized'
-- NeoSolarized unreadable colours for the diagnostics float
vim.api.nvim_set_hl( 0, 'NormalFloat', { link = 'LineNr' } )
vim.api.nvim_set_hl( 0, 'DiagnosticInfo', { link = 'Directory' } )
vim.api.nvim_set_hl( 0, 'DiagnosticHint', { link = 'cleared' } )

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
-- Show hidden characters
vim.keymap.set('n', '<Leader>H', function() vim.wo.list = not vim.wo.list end,
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
      local visual = tonumber( vim.fn.line( 'v' ) )
      local cursor = tonumber( vim.fn.line( '.' ) )
      local first = tostring( math.min( visual, cursor ) )
      local last = tostring( math.max( visual, cursor ) )
      print( 'https://opengrok.infra.corp.arista.io/source/xref/eos-trunk' ..
             vim.fn.expand( '%:p' ) .. '#' .. first .. '-' .. last )
   end,
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

-- Commands
-- Copy selected lines or complete file to Arista pb (http://pb/)
vim.api.nvim_create_user_command(
   'Pb', ':<line1>,<line2>w !curl -F c=@- pb', { range = '%' })

-- netrw settings
vim.g.netrw_localrmdir='rm -r'
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 2
vim.g.netrw_http_cmd="wget --compression=auto -O"

-- Tagbar plugin
vim.keymap.set('n', '<Leader>tb', '<cmd>TagbarToggle<cr>', { noremap = true })
vim.g.tagbar_compact = 1
vim.g.tagbar_autofocus = 1
vim.g.tagbar_sort = 0
vim.g.tagbar_position = 'leftabove vertical'
vim.g.tagbar_sort = 0
vim.g.tagbar_type_tac = {
   ctagstype = 'tacc',
   kinds = { 'd:definition' },
   sort = 0 }

-- vim-asterisk plugin
vim.keymap.set( 'n', '*', '<Plug>(asterisk-z*)' )
vim.keymap.set( 'n', '#', '<Plug>(asterisk-z#)' )
vim.keymap.set( 'n', 'g*', '<Plug>(asterisk-gz*)' )
vim.keymap.set( 'n', 'g#', '<Plug>(asterisk-gz#)' )

-- vim-fugitive plugin
vim.api.nvim_create_user_command(
   'GitDir', 'silent cd <args> | topleft vertical Git | cd- | lcd <args>',
   { nargs = 1 } )
vim.keymap.set( 'n', '<Leader>gs', '<cmd>topleft vertical Git<cr>' )
vim.keymap.set( 'n', '<Leader>gsd', ':GitDir<space>' )
vim.keymap.set( 'n', '<Leader>ge', ':Gedit<space>' )
vim.keymap.set( 'n', '<Leader>gd', ':Gdiffsplit<space>' )
vim.keymap.set( 'n', '<Leader>ged', '<cmd>Gedit | windo difft<cr>' )
vim.keymap.set( 'n', '<Leader>gc', ':Git commit<space>' )
vim.keymap.set( 'n', '<Leader>gb', '<cmd>Git blame<cr>' )
vim.keymap.set( 'n', '<Leader>G', ':Git<space>' )

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

-- vim-textobj-diff plugin
vim.g.textobj_diff_no_default_key_mappings = 1
vim.keymap.set( 'n', ']df', '<Plug>(textobj-diff-file-n)', { silent = true } )
vim.keymap.set( 'n', '[df', '<Plug>(textobj-diff-file-p)', { silent = true } )
vim.keymap.set( 'n', ']dh', '<Plug>(textobj-diff-hunk-n)', { silent = true } )
vim.keymap.set( 'n', '[dh', '<Plug>(textobj-diff-hunk-p)', { silent = true } )

-- arvim plugin
vim.g.a4_auto_edit = 0

-- lightline.vim plugin
vim.o.showmode = false
vim.g.lightline = {
   active = {
      right = {
         { 'lineinfo' },
         { 'percent' },
         { 'gitbranch', 'fileformat', 'fileencoding', 'filetype' }
      }
   },
   colorscheme = 'solarized',
   component_function = {
      gitbranch = 'FugitiveHead'
   }
}

-- vim-alog plugin
vim.api.nvim_create_autocmd( { 'BufNewFile', 'BufReadPost' }, {
   group = 'config',
   pattern = '*.log',
   callback = function ( args )
      vim.keymap.set('n', '<leader>al', '<cmd>set filetype=alog<cr>',
      { noremap = true, buffer = true } )
   end } )

-- vim-flog plugin
vim.keymap.set( 'n', '<Leader>gl', '<cmd>Flog -date=local<cr>', { noremap = true } )
vim.api.nvim_create_user_command(
   'FlogDir', 'silent cd <args> | execute "Flog -date=local" | cd- | lcd <args>',
   { nargs = 1 } )
vim.keymap.set( 'n', '<Leader>gld', ':FlogDir<space>', { noremap = true } )
vim.api.nvim_create_autocmd("FileType", {
   group = "config",
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
-- gitsigns.nvim
require('gitsigns').setup({
   worktrees = {
      {
         toplevel = vim.env.HOME,
         gitdir = vim.env.HOME .. '/.cfg',
      },
   }})
require('scrollbar.handlers.gitsigns').setup()
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
vim.keymap.set("n", "f", "<Plug>(leap-forward-to)")
-- <Plug>(leap-forward-to) is incorrectly defined to be { offset = 1 } in
-- Visual and Select mode
vim.keymap.set("x", "f", function()
   require('leap').leap( { offset = 0 } ) end)
-- <Plug>(leap-forward-to) is incorrectly defined to be { offset = -1 } in
-- Operator-pending mode
vim.keymap.set("o", "f", function()
   require('leap').leap( { offset = 1 } ) end)
vim.keymap.set({"n", "x", "o"}, "F", "<Plug>(leap-backward-to)")
vim.keymap.set({"n", "x", "o"}, "t", "<Plug>(leap-forward-till)")
-- <Plug>(leap-backward-till) is incorrectly defined to be { backward = true, offset = 2 }
vim.keymap.set({"n", "x", "o"}, "T", function()
   require('leap').leap( { backward = true, offset = 1 } ) end)

-- null-ls.nvim
-- Use internal formatting for bindings like gq.
-- See https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131
 vim.api.nvim_create_autocmd('LspAttach', { 
   callback = function(args) 
     vim.bo[args.buf].formatexpr = nil 
   end, 
 })

vim.diagnostic.config( {
   underline = false,
   virtual_text = false,
   float = {
       focusable = false,
       close_events = { 'BufLeave', 'CursorMoved', 'CursorMovedI', 'InsertEnter',
                        'InsertLeave', 'FocusLost' },
       border = 'rounded',
       source = 'if_many',
       scope = 'cursor',
       header = { '', 'Normal' },
       --prefix = { '', 'Normal' },
    }
} )

local onAttach = function( client, bufnr )
   -- Show line diagnostics automatically in hover window
   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
     buffer = bufnr,
     callback = function()
       vim.diagnostic.open_float( nil, nil )
     end
   })
end

local nullLs = require( 'null-ls' )
local nullLsHelpers = require( 'null-ls.helpers' )
nullLs.setup( {
   sources = { {
      name = 'pylint',
      method = { nullLs.methods.DIAGNOSTICS,
                 nullLs.methods.DIAGNOSTICS_ON_SAVE },
      filetypes = { 'python' },
      generator = nullLsHelpers.generator_factory( {
         command = 'a',
         args = { 'ws', 'pylint', '--py3Partial', '$FILENAME' },
         check_exit_code = { 0, 1 },
         format = 'line',
         on_output = nullLsHelpers.diagnostics.from_pattern(
            [[:(%d+)%s+((%u)(%d+).+)]],
            { 'row', 'message', 'severity', 'code' },
            { severities = { 
               [ 'F' ] = 1,
               [ 'E' ] = 1,
               [ 'W' ] = 2,
               [ 'C' ] = 3,
               [ 'R' ] = 4,
            } }
         ),
         runtime_condition = function( params )
            return vim.fn.filereadable( params.bufname ) == 1
         end,
      } ),
   }, {
      name = 'formatdiff',
      method = { nullLs.methods.DIAGNOSTICS,
                 nullLs.methods.DIAGNOSTICS_ON_SAVE },
      filetypes = { '_all' },
      generator = nullLsHelpers.generator_factory( {
         command = 'bash',
         args = { '-c', 'a git diff --unified 0 --type p4 $FILENAME | a ws formatdiff -' },
         ignore_stderr = true,
         format = nil,
         on_output = function( params, done )
            local diagnostics = {}
            local currDiagnostic = nil
            local currOrigLine = nil
            if params.output == nil then
               done()
               return
            end
            for line in params.output:gmatch( '[^\r\n]+' ) do
               local file = line:match( '^%-%-%-' ) ~= nil or
                            line:match( '^%+%+%+' ) ~= nil
               local hunk = line:match( '^@@ %-(%d+)' )
               if hunk ~= nil then
                  -- hunk start indicates the line of the next context line
                  currOrigLine = tonumber( hunk )
               end
               local remove = line:match( '^%-' ) ~= nil and not file
               local add = line:match( '^%+' ) ~= nil and not file
               if remove and currDiagnostic == nil then
                  assert( currOrigLine ~= nil )
                  currDiagnostic = {
                     row = currOrigLine,
                     message = '',
                     severity = 4,
                  }
               end
               if remove or add then
                  assert( currDiagnostic ~= nil )
                  currDiagnostic.message = currDiagnostic.message .. line .. '\n'
               end
               if add then
                  assert( currDiagnostic ~= nil )
                  currDiagnostic.end_row = currOrigLine
               end
               if not remove and not add then
                  -- Add current diagnostic if any
                  if currDiagnostic ~= nil then
                     table.insert( diagnostics, currDiagnostic )
                     currDiagnostic = nil
                  end
               end
               if hunk == nil and not add then
                  if currOrigLine ~= nil then
                     currOrigLine = currOrigLine + 1
                  end
               end
            end
            done( diagnostics )
         end,
         runtime_condition = function( params )
            return vim.fn.filereadable( params.bufname ) == 1
         end,
         timeout = 10000,
      } ),
   } },
   on_attach = onAttach,
} )
END
