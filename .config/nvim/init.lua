local lazypath = vim.fn.stdpath( 'data' ) .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat( lazypath ) then
  vim.fn.system( {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  } )
end
vim.opt.rtp:prepend( lazypath )

-- Options
vim.o.shiftwidth = 3
vim.o.tabstop = 3
vim.o.linebreak = true
vim.o.cindent = true
vim.o.expandtab = true
vim.o.virtualedit = 'all'
vim.o.mouse='a'
vim.o.directory = '/tmp'
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
vim.o.winblend = 15
vim.o.pumblend = 15
vim.o.splitbelow = true
vim.opt.diffopt:append( { 'vertical', 'algorithm:histogram', 'linematch:60' } )
vim.g.mapleader = ' '

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
     callback = function() vim.o.textwidth = 72 end,
     nested = true, })

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

-- Open files from tarballs by saving them to a temporary file with the same
-- extension and then opening that. This is what netrw does with remote files.
-- The tar.vim plugin doesn't do that. It tries to :read the files from the
-- output of the tar command. This fails miserably for binary files. That
-- strategy can be made to work, but the better strategy that works in all
-- cases is saving to a temporary file and then opening that. That allows all
-- normal file handling to proceed.
vim.api.nvim_create_autocmd( 'FileType',
   { group = 'config',
     pattern = 'tar',
     callback = function()
        -- Override the 'gf' mapping in tar files
        vim.keymap.set('n', 'gf', function()
           -- Get the inputs which are the name of the tar file and the file to
           -- extract
           local fname = vim.api.nvim_get_current_line()
           local tarfile = vim.b.tarfile
           local bufName = vim.fn.bufname()
           local tmpfile = vim.fn.tempname()

           local tarExt = tarfile:match( '.tar.gz$' )
           if tarExt == nil then
              print( 'Only extraction from .tar.gz files is supported' )
              return
           end

           -- Add any file extensions from fname to tmpfile so it will be
           -- treated correctly on opening
           local ext = fname:match( '[^/]+(%.[^/]+)$' )
           if ext ~= nil then
              tmpfile = tmpfile .. ext
           end

           -- Extract the file to the temporary file
           local cmdList = { 'tar', '-zxOf', tarfile, fname, '>', tmpfile }
           local cmdStr = vim.fn.join( cmdList )
           vim.fn.jobstart( cmdStr, {
              on_exit = function( _, exitCode, _ )
                 -- Edit the temporary file and set the buffer name
                 if exitCode ~= 0 then
                    print( 'File extraction failed with code ' .. exitCode )
                    return
                 end
                 vim.cmd.edit( tmpfile )
                 vim.api.nvim_buf_set_name( 0, bufName .. '/' .. fname )
              end,
              on_stderr = function( _, data, _ )
                 for _, line in ipairs( data ) do
                    print( line )
                 end
              end, } )
        end, { noremap = true, buffer = true })
	  end, } )

-- Mappings
vim.keymap.set({'n', 'v', 'o'}, 'Y', 'y$', { noremap = true })
vim.keymap.set('n', '<Leader>tc', '<cmd>tabclose<cr>',
   { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>tC', ':tabclose<space>', { noremap = true })
vim.keymap.set('n', '<Leader>tn', '<cmd>tabnew<cr>',
   { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>to', '<cmd>tabonly<cr>',
   { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>te', ':tabedit<space>', { noremap = true })
vim.keymap.set('n', '<Leader>tm', ':tabmove<space>', { noremap = true })
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
vim.keymap.set('n', '<Leader>ls', function()
   if vim.fn.confirm( 'Load session?', '&Yes\n&No', 2 ) == 1 then
      vim.cmd( 'source ~/.vim_session' )
      print( 'Session loaded' )
   end
   end,
   { noremap = true })
vim.keymap.set('n', '<Leader>|', '<cmd>vsplit<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>-', '<cmd>split<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>=', '<C-w>=', { noremap = true })
vim.keymap.set('n', '<Leader>O', '<cmd>only<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>c', '<cmd>close<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>D', '<cmd>bp|bd #<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>DC', '<cmd>bp|bd #|close<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>DD', '<cmd>bp!|bd! #<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>DDC', '<cmd>bp!|bd! #|close<cr>', { noremap = true })
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
local copyToSystemClipboard = function( value )
   vim.fn.setreg( '+', value )
   print( value .. ' (copied to system register)' )
end
vim.keymap.set('n', '<Leader>og', function()
      local link = 'https://opengrok.infra.corp.arista.io/source/xref/eos-trunk'
             .. vim.fn.expand( '%:p' )
      copyToSystemClipboard( link )
    end, { noremap = true, silent = true } )
vim.keymap.set('n', '<Leader>ogl', function()
      local link = 'https://opengrok.infra.corp.arista.io/source/xref/eos-trunk'
          .. vim.fn.expand( '%:p' ) .. '#' .. vim.fn.line( '.' )
      copyToSystemClipboard( link )
   end, { noremap = true, silent = true } )
vim.keymap.set('v', '<Leader>ogl', function()
      local visual = tonumber( vim.fn.line( 'v' ) )
      local cursor = tonumber( vim.fn.line( '.' ) )
      local first = tostring( math.min( visual, cursor ) )
      local last = tostring( math.max( visual, cursor ) )
      local link = 'https://opengrok.infra.corp.arista.io/source/xref/eos-trunk' ..
         vim.fn.expand( '%:p' ) .. '#' .. first .. '-' .. last
      copyToSystemClipboard( link )
   end, { noremap = true, silent = true } )
vim.keymap.set('n', '<Leader>s', function()
      local pathList = vim.fn.split( vim.fn.expand( '%:p' ), '/' )
      local package = pathList[ 2 ]
      local restOfPathList = { unpack( pathList, 3, #pathList ) }
      local restOfPath = vim.fn.join( restOfPathList, '/' )
      local link = 'https://src.infra.corp.arista.io/' .. package ..
         '/eos-trunk/' .. restOfPath
      copyToSystemClipboard( link )
   end, { noremap = true, silent = true } )
vim.keymap.set('n', '<Leader>sl', function()
      local pathList = vim.fn.split( vim.fn.expand( '%:p' ), '/' )
      local package = pathList[ 2 ]
      local restOfPathList = { unpack( pathList, 3, #pathList ) }
      local restOfPath = vim.fn.join( restOfPathList, '/' )
      local link = 'https://src.infra.corp.arista.io/' .. package .. '/eos-trunk/' ..
          restOfPath .. '#line-' .. vim.fn.line( '.' )
      copyToSystemClipboard( link )
   end, { noremap = true, silent = true } )

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
-- Diff modifications
vim.api.nvim_create_user_command(
   'DiffMods', function()
      local bufName = vim.fn.bufname()
      if vim.fn.filereadable( bufName ) ~= 1 then
         print( "Buffer is not readable" )
         return -1
      end

      if vim.t.diffModBuf == nil then
         local ft = vim.o.filetype
         vim.cmd( 'vnew' )
         vim.t.diffModBuf = vim.fn.bufnr()
         vim.o.buftype = 'nofile'
         vim.cmd( 'read ' .. bufName )
         vim.fn.deletebufline( vim.t.diffModBuf, 1 )
         vim.bo.filetype = ft
         vim.bo.modifiable = false
         vim.cmd( 'diffthis' )
         vim.cmd( 'wincmd p' )
         vim.cmd( 'diffthis' )
      else
         vim.cmd( 'diffoff' )
         vim.cmd( 'silent! bdelete! ' .. vim.t.diffModBuf )
         vim.t.diffModBuf = nil
      end
   end, {} )
vim.keymap.set( 'n', '<leader>dm', '<cmd>DiffMods<cr>', { noremap = true } )

-- Quicktrace file handling
local qtCat = function()
   if not vim.bo.modifiable then
      return
   end
   vim.o.binary = true
   vim.cmd( 'silent %!qtcat -f' )
   vim.o.binary = false
   vim.o.modified = false
end

vim.api.nvim_create_user_command(
   'QtCat', qtCat, {} )

vim.filetype.add( {
   pattern = {
      [ '.*%.qt' ] = 'qt',
      [ '.*%.qt%.[1-2]' ] = 'qt',
   } } )

vim.api.nvim_create_autocmd( 'FileType',
   { group = 'config',
     pattern = 'qt',
     callback = qtCat, } )

-- Pcap file handling
vim.filetype.add( {
   pattern = {
      [ '.*%.pcap' ] = 'pcap',
   } } )

-- Open pcap in termshark
local termShark = function()
   if vim.o.filetype ~= 'pcap' then
      print( 'Buffer is not a pcap file' )
      return
   end

   if vim.fn.executable( 'termshark' ) == 0 then
      print( 'termshark not available' )
      return
   end

   local fileName = vim.fn.bufname()
   if vim.fn.filereadable( bufName ) ~= 1 then
      fileName = vim.fn.tempname() .. '.pcap'
      vim.o.binary = true
      vim.cmd( 'write ' .. fileName )
   end

   bufNrToClose = vim.fn.bufnr()
   vim.cmd( 'terminal! termshark ' .. fileName )
   vim.api.nvim_buf_delete( bufNrToClose, {} )
end

vim.api.nvim_create_user_command(
   'TermShark', termShark, {} )

vim.api.nvim_create_autocmd( { 'BufNewFile', 'BufReadPost' },
   { group = 'config',
     pattern = '*.pcap',
     callback = function()
		  vim.schedule( termShark )
	  end, } )

-- Plugins via lazy.nvim
require( 'lazy' ).setup( {
   -- *-Improved
   'haya14busa/vim-asterisk',
   -- Soothing pastel theme for (Neo)vim
   { 'catppuccin/nvim',
      name = 'catppuccin',
      init = function()
         require( 'catppuccin' ).setup( {
            flavour = 'latte', -- latte, frappe, macchiato, mocha
            term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
            dim_inactive = {
               enabled = true, -- dims the background color of inactive window
            },
            styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
               comments = { 'italic' }, -- Change the style of comments
               conditionals = { 'italic' },
               loops = { 'italic' },
               functions = {},
               keywords = {},
               strings = { 'italic' },
               variables = {},
               numbers = {},
               booleans = {},
               properties = {},
               types = {},
               operators = {},
            },
            custom_highlights = function( colors )
               return {
                  [ '@statement' ] = { link = 'Statement' },
                  [ '@structure' ] = { link = 'Structure' },
               }
            end,
            integrations = {
               gitsigns = true,
               treesitter = true,
               aerial = true,
               treesitter_context = true,
            },
         } )
         vim.cmd.colorscheme 'catppuccin'
      end
   },
   -- A Git wrapper so awesome, it should be illegal
   'tpope/vim-fugitive',
   -- Add/change/delete surrounding delimiter pairs with ease
   { 'kylechui/nvim-surround', config = true },
   -- Helpers for UNIX
   'tpope/vim-eunuch',
   -- Improved fzf.vim written in lua
   'ibhagwan/fzf-lua',
   -- Refactored Arista vim plugin
   { 'git@gitlab.aristanetworks.com:the_third_man/arvim.git',
      init = function()
         vim.g.a4_auto_edit = 0
      end
   },
   -- A blazing fast and easy to configure neovim statusline plugin written in
   -- pure lua.
   'nvim-lualine/lualine.nvim',
   -- A lightweight and powerful git branch viewer for vim
   'rbong/vim-flog',
   -- Extensible Neovim Scrollbar
   'petertriho/nvim-scrollbar',
   -- Neovim's answer to the mouse
   'ggandor/leap.nvim',
   -- enable repeating supported plugin maps with "."
   'tpope/vim-repeat',
   -- easily search for, substitute, and abbreviate multiple variants of a word
   'tpope/vim-abolish',
   -- Git integration for buffers
   'lewis6991/gitsigns.nvim',
   -- copy text through SSH with OSC52
   'ojroques/nvim-osc52',
   -- Nvim Treesitter configurations and abstraction layer
   'nvim-treesitter/nvim-treesitter',
   -- Syntax aware text-objects, select, move, swap, and peek support
   { 'nvim-treesitter/nvim-treesitter-textobjects',
      dependencies = 'nvim-treesitter/nvim-treesitter' },
   -- plugin for a code outline window
   'stevearc/aerial.nvim',
   -- lua `fork` of vim-web-devicons for neovim
   'nvim-tree/nvim-web-devicons',
   -- A neovim plugin that shows colorcolumn dynamically
   'Bekaboo/deadcolumn.nvim',
   -- Smart, directional Neovim split resizing and navigation
   'mrjones2014/smart-splits.nvim',
   -- Improved Yank and Put functionalities for Neovim
   'gbprod/yanky.nvim',
   -- Better quickfix window in Neovim, polish old quickfix window
   'kevinhwang91/nvim-bqf',
   -- Single tabpage interface for easily cycling through diffs for all
   -- modified files for any git rev.
   'sindrets/diffview.nvim',
}, {
   ui = {
      -- The border to use for the UI window. Accepts same border values as
      -- nvim_open_win().
      border = 'rounded',
   },
} )

-- netrw settings
vim.g.netrw_localrmdir = 'rm -r'
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 2
vim.g.netrw_http_xcmd = '-O'

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
require( 'fzf-lua' ).setup( {
   winopts = {
      width = 1,
      height = 0.4,
      row = 1,
      col = 0,
      preview = {
         hidden = 'hidden', -- hidden|nohidden
      },
   },
   fzf_opts = {
      [ '--layout' ] = false,
   },
} )
require( 'fzf-lua' ).register_ui_select()

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

-- nvim-lualine/lualine.nvim
require( 'lualine' ).setup( {
   options = {
      theme = 'catppuccin',
      globalstatus = true,
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' }
   },
   sections = {
      lualine_a = { 'mode' },
      lualine_b = { { 'hostname',
                      fmt = function( hostname, ctx )
                               return hostname:match( '[^%.]+' )
                            end,
                    },
                    'branch' },
      lualine_c = { 'searchcount', 'selectioncount' },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
         {
            'tabs',
            cond = function() return vim.fn.tabpagenr( '$' ) > 1 end,
            mode = 0, -- Shows tab_nr
      } },
   },
   winbar = {
      lualine_a = { 'filename' },
      lualine_b = { 'diff', 'diagnostics' },
      lualine_c = { 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
   },
   inactive_winbar = {
      lualine_b = { 'filename' },
      lualine_y = { 'location' },
   },
   extensions = {
      'fugitive',
      'fzf',
      'quickfix',
      'lazy',
      'aerial',
   },
} )
vim.o.showmode = false
vim.o.showtabline = 0 -- never
vim.opt.shortmess:append( 'S' ) -- do not show search count message when searching

-- Configure diagnostic signs to match lualine
local lualineDiagConfig = require( 'lualine.components.diagnostics.config' )
local diagSymbols = lualineDiagConfig.symbols.icons
local diagnostic_signs = {
  { name = "DiagnosticSignError", text = diagSymbols[ 'error' ] },
  { name = "DiagnosticSignWarn", text = diagSymbols[ 'warn' ] },
  { name = "DiagnosticSignHint", text = diagSymbols[ 'info' ] },
  { name = "DiagnosticSignInfo", text = diagSymbols[ 'hint' ] },
}
for _, sign in ipairs(diagnostic_signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
end

-- vim-flog plugin
vim.keymap.set( 'n', '<Leader>gl', '<cmd>Flog -date=local<cr>', { noremap = true } )
vim.keymap.set( 'n', '<Leader>glf', '<cmd>Flog -date=local -path=%<cr>',
   { noremap = true } )
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
vim.keymap.set('n', '<Leader>gsc', ':Gitsigns change_base<space>',
   { noremap = true })
vim.keymap.set('n', '<Leader>gsb',
   function() require('gitsigns').blame_line() end, { noremap = true })
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
local leap = require('leap')
-- Setting the list to `{}` effectively disables the autojump feature.
leap.opts.safe_labels = {}
leap.opts.labels = { 's', 'f', 'n', 'j', 'k', 'l', 'h', 'o', 'd', 'w', 'e',
   'i', 'm', 'b', 'u', 'y', 'v', 'r', 'g', 't', 'a', 'q', 'p', 'c', 'x', 'z' }
vim.api.nvim_set_hl( 0, 'LeapBackdrop', { link = 'Comment' } )
vim.keymap.set( 'n', 'f', '<Plug>(leap-forward-to)' )
-- <Plug>(leap-forward-to) is incorrectly defined to be { offset = 1 } in
-- Visual and Select mode
vim.keymap.set( 'x', 'f', function() require( 'leap' ).leap( { offset = 0 } ) end )
-- <Plug>(leap-forward-to) is incorrectly defined to be { offset = -1 } in
-- Operator-pending mode
vim.keymap.set( 'o', 'f', function() require( 'leap' ).leap( { offset = 1 } ) end )

vim.keymap.set( { 'n', 'x', 'o' }, 'F', '<Plug>(leap-backward-to)' )

vim.keymap.set( { 'n', 'x', 'o' }, 't', '<Plug>(leap-forward-till)' )

-- <Plug>(leap-backward-till) is incorrectly defined to be { backward = true, offset = 2 }
vim.keymap.set( { 'n', 'x', 'o' }, 'T', function()
   require( 'leap' ).leap( { backward = true, offset = 1 } ) end )

-- LSP
local onAttachDiags = function( client, bufnr )
   -- Show line diagnostics in float window
   vim.keymap.set( 'n', '<Leader>l', function()
         vim.diagnostic.open_float( nil, nil )
      end, { noremap = true, silent = true } )
end

local onAttachSymbols = function( client, bufnr )
   -- Register key mappings for definitions and references
   vim.keymap.set('n', '<leader>ld', function()
      require( 'fzf-lua' ).lsp_definitions()
   end, { buffer = true } )
   vim.keymap.set('n', '<leader>lr', function()
      require( 'fzf-lua' ).lsp_references()
   end, { buffer = true } )
end

-- local onAttachHover = function( client, bufnr )
--    -- Display hover information about the symbol under the cursor in a
--    -- floating window
--    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--      buffer = bufnr,
--      callback = function()
--        vim.lsp.buf.hover()
--      end
--    })
-- end

local onAttachCodeAction = function( client, bufnr )
   -- Register key mappings for code action
  vim.keymap.set('n', '<leader>la', function()
     vim.lsp.buf.code_action()
  end, { buffer = true } )
end

vim.api.nvim_create_autocmd( { 'FileType' },
   { group = 'config',
     pattern = 'python',
     callback = function()
        vim.lsp.start( {
           name = 'ar-pylint-ls',
           cmd = { 'ar-pylint-ls' },
           root_dir = '/src',
           settings = { debug = false },
           on_attach = onAttachDiags,
        } )
     end, } )

vim.api.nvim_create_autocmd( { 'FileType' },
   { group = 'config',
     pattern = 'tac',
     callback = function()
        vim.lsp.start( {
           name = 'artaclsp',
           cmd = { 'artaclsp' },
           root_dir = '/src',
           on_attach = function( client, bufnr )
              onAttachDiags( client, bufnr )
              onAttachSymbols( client, bufnr )
              --onAttachHover( client, bufnr )
              onAttachCodeAction( client, bufnr )
           end,
        } )
     end, } )

vim.api.nvim_create_autocmd( { 'BufNewFile', 'BufReadPost' },
   { group = 'config',
     pattern = '/src/**',
     callback = function()
        vim.lsp.start( {
           name = 'ar-formatdiff-ls',
           cmd = { 'ar-formatdiff-ls' },
           root_dir = '/src',
           settings = { debug = false },
           on_attach = onAttachDiags,
        } )
     end, } )

vim.api.nvim_create_autocmd( { 'BufNewFile', 'BufReadPost' },
   { group = 'config',
     pattern = '/src/**',
     callback = function()
        vim.lsp.start( {
           name = 'ar-grok-ls',
           cmd = { 'ar-grok-ls' },
           root_dir = '/src',
           settings = { debug = false },
           on_attach = onAttachSymbols,
        } )
     end, } )

vim.diagnostic.config( {
   underline = false,
   virtual_text = false,
   float = {
      focusable = false,
      close_events = { 'BufLeave', 'CursorMoved', 'CursorMovedI', 'InsertEnter',
                       'InsertLeave', 'FocusLost' },
      border = 'rounded',
      source = 'if_many',
      scope = 'line',
      header = { '', 'Normal' },
    }
} )

-- vim.lsp.handlers[ 'textDocument/hover' ] = vim.lsp.with(
--    vim.lsp.handlers.hover, {
--       focusable = false,
--       border = 'rounded'
--    }
-- )

-- LSP formatting
vim.keymap.set( 'n', '<leader>lf', function()
   vim.lsp.buf.format( { timeout_ms=5000 } ) end )

-- ojroques/nvim-osc52
local function copy(lines, _)
   require('osc52').copy(table.concat(lines, '\n'))
end

local function paste()
   return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end

vim.g.clipboard = {
  name = 'osc52',
  copy = { [ '+' ] = copy, [ '*' ] = copy },
  paste = { [ '+' ] = paste, [ '*' ] = paste },
}

-- Treesitter
require( 'nvim-treesitter.configs' ).setup {
   auto_install = true,
   highlight = {
      enable = true,
      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
   },
   indent = {
      enable = true
   },
   textobjects = {
      select = {
         enable = true,

         -- Automatically jump forward to textobjects, similar to targets.vim
         lookahead = false,
      },
      move = {
         enable = true,
         set_jumps = true, -- whether to set jumps in the jumplist
      },
   },
}

-- Treesitter configuration for tree-sitter-tac
require( 'nvim-treesitter.install' ).prefer_git = true
local parser_config = require( 'nvim-treesitter.parsers' ).get_parser_configs()
parser_config.tac = {
   install_info = {
      url = '~/projects/tree-sitter-tac',
      files = { 'src/parser.c', 'src/scanner.cc' },
   },
   filetype = 'tac',
}

-- aerial.nvim
require( 'aerial' ).setup( {
   backends = { 'treesitter', 'lsp' },
   layout = {
      default_direction = 'prefer_left',
      preserve_equality = true,
   },
   close_automatic_events = { 'unfocus', 'switch_buffer' },
   -- A list of all symbols to display. Set to false to display all symbols.
   -- This can be a filetype map (see :help aerial-filetype-map)
   -- To see all available values, see :help SymbolKind
   filter_kind = {
      'Namespace',
      'Class',
      'Constructor',
      'Enum',
      'Function',
      'Interface',
      'Module',
      'Method',
      'Struct',
      'Field',
   },
} )
vim.keymap.set('n', '<Leader>at', '<cmd>AerialToggle<cr>', { noremap = true })

-- nvim-scrollbar
require('scrollbar').setup( {
   show_in_active_only = true,
   handle = {
      highlight = 'CursorLine',
   },
} )

-- deadcolumn
require('deadcolumn').setup( {
   scope = 'line',
   extra = {
      follow_tw = '+1',
   }
} )

-- smart-splits
require( 'smart-splits' ).setup( {
   cursor_follows_swapped_bufs = true,
} )
-- resizing splits
vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
-- moving between splits
vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
-- swapping buffers between windows
vim.keymap.set( 'n', '<Leader><C-h>', require( 'smart-splits' ).swap_buf_left )
vim.keymap.set( 'n', '<Leader><C-j>', require( 'smart-splits' ).swap_buf_down )
vim.keymap.set( 'n', '<Leader><C-k>', require( 'smart-splits' ).swap_buf_up )
vim.keymap.set( 'n', '<Leader><C-l>', require( 'smart-splits' ).swap_buf_right )

-- yanky
yankyUtils = require( 'yanky.utils' )
yankyPicker = require( 'yanky.picker' )
require( 'yanky' ).setup( {
   system_clipboard = {
     sync_with_ring = false,
   },
   highlight = {
     on_put = false,
     on_yank = false,
   },
} )
vim.keymap.set( { 'n','x' }, 'p', '<Plug>(YankyPutAfter)' )
vim.keymap.set( { 'n','x' }, 'P', '<Plug>(YankyPutBefore)' )
vim.keymap.set( 'n', '<c-n>', '<Plug>(YankyCycleForward)' )
vim.keymap.set( 'n', '<c-p>', '<Plug>(YankyCycleBackward)' )
vim.keymap.set( 'n', '<Leader>yh', '<cmd>YankyRingHistory<cr>', { noremap = true } )
yankyPicker.actions.set_register( yankyUtils.get_default_register() )

