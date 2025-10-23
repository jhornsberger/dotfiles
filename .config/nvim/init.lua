-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
   local lazyrepo = "https://github.com/folke/lazy.nvim.git"
   local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
   if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
         { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
         { out, "WarningMsg" },
         { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
   end
end
vim.opt.rtp:prepend(lazypath)

-- Options
vim.o.shiftwidth = 3
vim.o.tabstop = 3
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.cindent = true
vim.o.expandtab = true
vim.o.virtualedit = 'all'
vim.o.mouse='a'
vim.o.directory = '/tmp'
vim.o.foldenable = false
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
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.fsync = false
vim.o.spelllang = 'en_us'
vim.o.winborder = 'rounded'
vim.o.tabclose = 'uselast'
vim.opt.diffopt:append( { 'vertical', 'algorithm:histogram', 'linematch:60' } )
vim.opt.completeopt:append( 'fuzzy' )
vim.g.mapleader = ' '
-- vim.g.clipboard = 'osc52'
-- Wezterm doesn't support OSC 52 paste
local function paste()
   return {
      vim.fn.split(vim.fn.getreg(""), "\n"),
      vim.fn.getregtype(""),
   }
end

vim.g.clipboard = {
   name = "OSC 52",
   copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
   },
   paste = {
      ["+"] = paste,
      ["*"] = paste,
   },
}
vim.opt.errorformat = {
   '[%.%#] %f:%l:%c: %trror: %m', -- C++ compiler errors
   '%-G%.%#', -- ignore every other line
}

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

-- Always make quickfix window occupy the full width at the bottom
vim.api.nvim_create_autocmd( { 'FileType' },
   { group = 'config',
     pattern = 'qf',
     command = 'wincmd J', } )

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

-- Set spell
vim.api.nvim_create_autocmd({'FileType'},
   { group = 'config',
     pattern = { 'tac', 'cpp', 'python', 'lua', 'gitcommit' },
     callback = function()
        vim.opt_local.spell = true
     end,
     nested = true, })

-- Set commentstring
vim.api.nvim_create_autocmd({'FileType'},
   { group = 'config',
     pattern = { 'tac', 'cpp' },
     callback = function()
        vim.bo.commentstring = '// %s'
     end,
     nested = true, })

-- Set treesitter folding where supported
-- Had an issue that froze nvim with python
vim.api.nvim_create_autocmd( {'FileType'},
   { group = 'config',
     pattern = { 'tac', 'cpp', 'python', },
     callback = function()
         vim.opt_local.foldmethod = 'expr'
         vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      end,
     nested = true, } )

-- Set syntax folding for git
vim.api.nvim_create_autocmd( {'FileType'},
   { group = 'config',
     pattern = { 'git', },
     callback = function()
         vim.opt_local.foldmethod = 'syntax'
      end,
     nested = true, } )

-- Better indenting for tac files
-- vim.api.nvim_create_autocmd( { 'FileType' },
--    { group = 'config',
--      pattern = 'tac',
--      callback = function()
--          tacFtpluginFile = '/usr/share/vim/vimfiles/ftplugin/tac.vim'
--          if vim.fn.filereadable( tacFtpluginFile ) == 1 then
--             vim.cmd.source( tacFtpluginFile )
--          end
--
--          tacIndentFile = '/usr/share/vim/vimfiles/indent/tac.vim'
--          if vim.fn.filereadable( tacIndentFile ) == 1 then
--             vim.cmd.source( tacIndentFile )
--          end
--       end, } )

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

-- Disable slow features in large files
vim.api.nvim_create_autocmd( { 'BufNewFile', 'BufReadPost' },
   { group = 'config',
     pattern = '*',
     callback = function()
        bufMB =  vim.fn.wordcount().bytes / 1024 / 1024
        if bufMB < 2 then
           vim.b.bigFile = false
           return
        end

        -- Disable features
        vim.b.bigFile = true

        local winid = vim.api.nvim_get_current_win()
        vim.wo[winid][0].wrap = false

        vim.b.matchparen_timeout = 100

        vim.opt_local.syntax = 'off'
        vim.cmd( 'syntax clear' )
     end, })

-- Mappings
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
vim.keymap.set('n', 'z.', 'zszH', { noremap = true })
vim.keymap.set('n', '<Leader>//', '<cmd>nohlsearch<cr>',
   { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>ms', '<cmd>mksession! ~/.vim_session<cr>',
   { noremap = true })
vim.keymap.set('n', '<Leader>ls', function()
      if vim.fn.confirm( 'Load session?', '&Yes\n&No', 2 ) == 1 then
         vim.cmd( 'source ~/.vim_session' )
         print( 'Session loaded' )
      end
   end, { noremap = true })
vim.keymap.set('n', '<Leader>|', '<cmd>vsplit<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>-', '<cmd>split<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>=', '<C-w>=', { noremap = true })
vim.keymap.set('n', '<Leader>O', '<cmd>only<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>c', '<cmd>close<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>D', '<cmd>bp|bd #<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>DC', '<cmd>bp|bd #|close<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>DD', '<cmd>bp!|bd! #<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>DDC', '<cmd>bp!|bd! #|close<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>W', '<cmd>set wrap!<cr>', { noremap = true })
-- Yank register to another register
vim.keymap.set('n', 'yr', function()
      local sourceReg = vim.fn.nr2char( vim.fn.getchar() )
      local targetReg = vim.v.register
      local sourceRegInfo = vim.fn.getreginfo( sourceReg )
      vim.fn.setreg( targetReg, sourceRegInfo )
   end, { noremap = true })
-- Edit register content
vim.keymap.set('n', '<Leader>er', function()
      local reg = vim.v.register
      local regInfo = vim.fn.getreginfo( reg )
      if next( regInfo ) == nil then
         return
      end
      local buf = vim.api.nvim_create_buf( false, true )
      vim.api.nvim_buf_set_lines( buf, 0, -1, true, regInfo.regcontents )
      local win = vim.api.nvim_open_win( buf, true, {
         relative = 'editor',
         width = math.floor( vim.o.columns / 2 ),
         height = math.floor( vim.o.lines / 2 ),
         col = math.floor( vim.o.columns / 4 ),
         row = math.floor( vim.o.lines / 4 ),
         title = 'Edit register [' .. reg .. ']'
      } )
      vim.api.nvim_create_autocmd( 'WinClosed', {
         group = 'config',
         buffer = buf,
         callback = function()
            if not ( reg == '"' or ( reg >= 'a' and reg <= 'z' ) ) then
               return
            end
            local regLines = vim.api.nvim_buf_get_lines( buf, 0, -1, true )
            regInfo.regcontents = regLines
            vim.fn.setreg( reg, regInfo )
            vim.api.nvim_buf_delete( buf, { force = true, unload = false } )
         end, } )
      vim.keymap.set('n', 'q', '<cmd>close<cr>', { noremap = true, buffer = buf })
   end, { noremap = true })
-- Open file under cursor in vertical split
vim.keymap.set('n', '<C-W><C-F>', '<C-W>vgf', { noremap = true })
vim.keymap.set('n', '<Leader>j', '<cmd>pedit +$ `job -g <cword>`<cr>',
   { noremap = true })
vim.keymap.set('n', '<Leader>J', '<cmd>edit +$ `job -g <cword>`<cr>',
   { noremap = true })
vim.keymap.set('n', '<Leader>jf',
   '<cmd>split | terminal less +F $(job -g <cword>)<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>JF', '<cmd>terminal less +F $(job -g <cword>)<cr>',
   { noremap = true })
vim.keymap.set('n', '<Leader>cf',
   '<cmd>cgetfile `job -g .`<cr>', { noremap = true })
-- Show hidden characters
vim.keymap.set('n', '<Leader>H', function() vim.wo.list = not vim.wo.list end,
   { noremap = true })

-- Resizing splits
vim.keymap.set( 'n', '<A-h>', '<Cmd>wincmd <<cr>', { noremap = true, silent = true } )
vim.keymap.set( 'n', '<A-j>', '<Cmd>wincmd -<cr>', { noremap = true, silent = true } )
vim.keymap.set( 'n', '<A-k>', '<Cmd>wincmd +<cr>', { noremap = true, silent = true } )
vim.keymap.set( 'n', '<A-l>', '<Cmd>wincmd ><cr>', { noremap = true, silent = true } )

-- Moving between splits
vim.keymap.set( 'n', '<C-h>', '<Cmd>wincmd h<cr>', { noremap = true, silent = true } )
vim.keymap.set( 'n', '<C-j>', '<Cmd>wincmd j<cr>', { noremap = true, silent = true } )
vim.keymap.set( 'n', '<C-k>', '<Cmd>wincmd k<cr>', { noremap = true, silent = true } )
vim.keymap.set( 'n', '<C-l>', '<Cmd>wincmd l<cr>', { noremap = true, silent = true } )

-- Adding and subtracting
vim.keymap.set( 'n', '+', '<C-a>', { noremap = true } )
vim.keymap.set( 'v', '+', 'g<C-a>', { noremap = true } )
vim.keymap.set( 'n', '-', '<C-x>', { noremap = true } )
vim.keymap.set( 'v', '-', 'g<C-x>', { noremap = true } )

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
-- vim.keymap.set('t', '<C-\\>', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('t', '<M-Esc>', '<C-\\><C-n>', { noremap = true })
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
   'Pb', ':<line1>,<line2>w !curl -F "t=$USER@arista.com" -F c=@- pb.infra.corp.arista.io', { range = '%' })

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

-- -- Arista Git commit
-- vim.api.nvim_create_user_command( 'AGitCommit',
--    function( arg )
--       local bufFile = vim.api.nvim_buf_get_name( 0 )
--       local bufNr = vim.api.nvim_get_current_buf()
--       local cmdList = { 'a', 'git', 'commit', '--file', bufFile }
--       local argList = vim.split( arg.args, ' +', { trimempty=true } )
--       vim.list_extend( cmdList, argList )
--       vim.system( cmdList, { text = true },
--          function( context )
--             local msg = ''
--             if context.stdout ~= '' then
--                msg = msg .. context.stdout
--             end
--             if context.stderr ~= '' then
--                if msg ~= '' then
--                   msg = msg .. '\n'
--                end
--                msg = msg .. context.stderr
--             end
--             if msg == '' then
--                msg = 'AGitCommit complete'
--             end
--             local level = vim.log.levels.INFO
--             if context.code ~= 0 then
--                level = vim.log.levels.ERROR
--             end
--             vim.schedule_wrap( vim.notify )( msg, level )
--
--             vim.schedule_wrap( vim.cmd.bdelete )( bufNr )
--          end )
--    end, { nargs = '*' } )
-- vim.keymap.set( 'n', '<leader>ac', ':AGitCommit<cr>' )
-- vim.keymap.set( 'n', '<leader>aca', ':AGitCommit --amend<cr>' )

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
      [ '.*%.qt%.%d' ] = 'qt',
   } } )

vim.api.nvim_create_autocmd( 'FileType',
   { group = 'config',
     pattern = 'qt',
     callback = qtCat, } )

-- Pcap file handling
vim.filetype.add( {
   pattern = {
      [ '.*%.pcap' ] = 'pcap',
      [ '.*%.pcapng' ] = 'pcap',
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
   if vim.fn.filereadable( fileName ) ~= 1 then
      fileName = vim.fn.tempname() .. '.pcap'
      vim.o.binary = true
      vim.cmd( 'write ' .. fileName )
   end

   bufNrToClose = vim.fn.bufnr()
   vim.cmd( 'terminal! termshark ' .. fileName )
   vim.api.nvim_buf_delete( bufNrToClose, {} )
end

vim.api.nvim_create_user_command( 'TermShark', termShark, {} )

vim.api.nvim_create_autocmd( { 'BufNewFile', 'BufReadPost' },
   { group = 'config',
     pattern = { '*.pcap', '*.pcapng' },
     callback = function()
        vim.schedule( termShark )
     end, } )

-- Plugins via lazy.nvim
require( 'lazy' ).setup( {
   spec = {
      -- *-Improved
      'haya14busa/vim-asterisk',
      -- -- Soho vibes for Neovim
      -- { 'rose-pine/neovim',
      --   lazy = false,
      --   priority = 1000,
      --   version = '*',
      --   config = function()
      --      require( 'rose-pine' ).setup( {
      --         -- dim_inactive_windows = true,
      --         highlight_groups = {
      --            [ '@statement' ] = { link = 'Statement' },
      --            [ '@structure' ] = { link = 'Structure' },
      --         }
      --      } )
      --      vim.cmd.colorscheme 'rose-pine'
      --   end,
      -- },
      -- A highly customizable theme for vim and neovim with support for lsp,
      -- treesitter and a variety of plugins.
      -- { 'EdenEast/nightfox.nvim',
      --    lazy = false,
      --    priority = 1000,
      --    version = '*',
      --    config = function()
      --       require( 'nightfox' ).setup( {
      --          options = {
      --             colorblind = {
      --                enable = true,
      --                severity = {
      --                   protan = 0.8,
      --                   deutan = 0.3,
      --                   tritan = 0.1,
      --                },
      --             },
      --             styles = {
      --                comments = "italic",
      --                keywords = "bold",
      --                types = "italic,bold",
      --             }
      --          },
      --          groups = {
      --             all = {
      --                [ '@statement' ] = { link = 'Statement' },
      --                [ '@structure' ] = { link = 'Structure' },
      --             },
      --          },
      --       } )
      --       vim.cmd.colorscheme 'dayfox'
      --    end,
      -- },
      {
         'zenbones-theme/zenbones.nvim',
         -- Optionally install Lush. Allows for more configuration or extending the colorscheme
         -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
         -- In Vim, compat mode is turned on as Lush only works in Neovim.
         dependencies = 'rktjmp/lush.nvim',
         lazy = false,
         priority = 1000,
         -- you can set set configuration options here
         config = function()
             vim.cmd.colorscheme( 'zenbones' )
         end
      },
      -- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
      'sindrets/diffview.nvim',
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
      -- Extensible Neovim Scrollbar
      'petertriho/nvim-scrollbar',
      -- Neovim's answer to the mouse
      'ggandor/leap.nvim',
      -- enable repeating supported plugin maps with "."
      'tpope/vim-repeat',
      -- Pairs of handy bracket mappings
      'tpope/vim-unimpaired',
      -- easily search for, substitute, and abbreviate multiple variants of a word
      'tpope/vim-abolish',
      -- Git integration for buffers
      { 'lewis6991/gitsigns.nvim',
         version = '*',
      },
      -- Nvim Treesitter configurations and abstraction layer
      'nvim-treesitter/nvim-treesitter',
      -- Syntax aware text-objects, select, move, swap, and peek support
      { 'rrethy/nvim-treesitter-textsubjects',
         dependencies = 'nvim-treesitter/nvim-treesitter' },
      -- plugin for a code outline window
      'stevearc/aerial.nvim',
      -- lua `fork` of vim-web-devicons for neovim
      { 'nvim-tree/nvim-web-devicons',
         version = '*',
      },
      -- A neovim plugin that shows colorcolumn dynamically
      'Bekaboo/deadcolumn.nvim',
      -- Rearrange your windows with ease.
      'sindrets/winshift.nvim',
      -- Improved Yank and Put functionalities for Neovim
      'gbprod/yanky.nvim',
      -- A better user experience for viewing and interacting with Vim marks.
      { 'chentoast/marks.nvim',
         opts = { force_write_shada = true },
      },
      -- Indent guides for Neovim
      { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', },
      -- Improved UI and workflow for the Neovim quickfix
      { 'stevearc/quicker.nvim',
         opts = {
            constrain_cursor = false,
              keys = {
                 {
                    '>',
                    function()
                      require('quicker').expand({ before = 2, after = 2, add_to_existing = true })
                    end,
                    desc = 'Expand quickfix context',
                 },
                 {
                    '<',
                    function()
                      require('quicker').collapse()
                    end,
                    desc = 'Collapse quickfix context',
                 },
              },
         },
      },
      -- A collection of QoL plugins for Neovim
      { 'folke/snacks.nvim',
        opts = {
          input = {},
          notifier = {
             timeout = 10000,
          },
        },
      },
      -- -- Performant, batteries-included completion plugin for Neovim
      -- { 'saghen/blink.cmp',
      --    version = '*',
      --    opts = {},
      -- },
      -- -- AI-powered coding, seamlessly in Neovim
      -- { 'olimorris/codecompanion.nvim',
      --    opts = {
      --       strategies = {
      --          chat = {
      --             adapter = "gemini",
      --          },
      --          inline = {
      --             adapter = "gemini",
      --          },
      --          cmd = {
      --             adapter = "gemini",
      --          }
      --       },
      --       adapters = {
      --          gemini = function()
      --             return require( 'codecompanion.adapters' ).extend( 'gemini', {
      --                env = {
      --                  api_key = 'cmd:cat ~/.gemini_api_key',
      --                  -- model = 'gemini-2.5-pro-exp-03-25',
      --                },
      --             } )
      --          end,
      --       },
      --    },
      --    dependencies = {
      --      'nvim-lua/plenary.nvim',
      --      'nvim-treesitter/nvim-treesitter',
      --    },
      -- },
   },
   ui = {
      border = 'rounded',
   },
   performance = {
      reset_packpath = false, -- reset the package path to improve startup time
      rtp = { reset = false },
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

-- -- vim-fugitive plugin
-- -- vim.api.nvim_create_user_command(
-- --    'GitDir', 'silent cd <args> | topleft vertical Git | cd- | lcd <args>',
-- --    { nargs = 1 } )
-- vim.keymap.set( 'n', '<Leader>fs', '<cmd>topleft vertical Git<cr>' )
-- -- vim.keymap.set( 'n', '<Leader>gsd', ':GitDir<space>' )
-- -- vim.keymap.set( 'n', '<Leader>ge', ':Gedit<space>' )
-- -- vim.keymap.set( 'n', '<Leader>gd', ':Gdiffsplit<space>' )
-- -- vim.keymap.set( 'n', '<Leader>ged', '<cmd>Gedit | windo difft<cr>' )
-- -- vim.keymap.set( 'n', '<Leader>gc', ':Git commit<space>' )
-- -- vim.keymap.set( 'n', '<Leader>G', ':Git<space>' )

-- fzf-lua plugin
require( 'fzf-lua' ).setup( {
   files = {
      fd_opts = [[--color=never --type f --follow --exclude .git]],
   },
   fzf_opts = {
      [ '--layout' ] = false,
   },
   defaults = {
      copen = false,
   },
   grep = {
      RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH
   },
   marks = {
      marks = '%a',
      actions = {
         [ 'default' ] = require( 'fzf-lua' ).actions.goto_mark,
         [ 'ctrl-x' ]  = function( selected )
            local mark = selected[1]:match("[^ ]+")
            vim.cmd.delmarks( mark )
         end,
      },
   },
   quickfix = {
      actions = { ["ctrl-o"] = function( selected )
            vim.cmd.copen()
         end
      },
   },
} )
require( 'fzf-lua' ).register_ui_select()

vim.api.nvim_create_user_command(
   'FzfRg',
   function(opts)
      require('fzf-lua').grep({
         search = '',
         cmd = 'rg --line-number --column ' .. opts.args,
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

local function altFiles( mappings )
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

local function fzfFileListFunc( contents, opts )
   local config = require( 'fzf-lua.config' )
   local core = require( 'fzf-lua.core' )
   opts = config.normalize_opts( opts, config.globals.files )
   if not opts then return end
   opts = core.set_header( opts, opts.headers )
   return core.fzf_exec( contents, opts )
end

local tacTarget = "%1/%2.tac"
local tinTarget = "%1/%2.tin"
local itinTarget = "%1/%2.itin"
local testTarget = "%1/test/%2Test*.py"
local altMappings = {{
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

vim.keymap.set('n', '<Leader><Leader>', require('fzf-lua').builtin, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>r', require('fzf-lua').resume, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>f', "<cmd>FzfFiles<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>F', ":FzfFiles<space>", { noremap = true })
vim.keymap.set('n', '<Leader>of', require('fzf-lua').oldfiles, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>b', require('fzf-lua').buffers, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>bt', function() require('fzf-lua').btags({ ctags_autogen = true }) end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>t', require('fzf-lua').tabs, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>g', ":FzfRg<space>", { noremap = true })
vim.keymap.set('n', '<Leader>bl', require('fzf-lua').blines, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>h', require('fzf-lua').help_tags, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>:', require('fzf-lua').command_history, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>/', require('fzf-lua').search_history, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>m', require('fzf-lua').marks, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>qf', require('fzf-lua').quickfix, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>qfs', require('fzf-lua').quickfix_stack, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>z', require('fzf-lua').spell_suggest, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>d', require('fzf-lua').lsp_document_diagnostics, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>af',
   function()
      fzfFileListFunc( altFiles( altMappings ), { prompt = 'Alternate Files❯ ' } )
   end,
   { noremap = true, silent = true })

-- Active job in lualine
local function setActiveJobs()
   local cmdList = { 'job', '--info' }
   local results = vim.system( cmdList, { text = true }, function( context )
      vim.g.active_jobs =
         tonumber( string.gmatch( context.stdout, '(%d+) \'activeJobs\'' )() )
   end )
end

-- Initialization
vim.g.active_jobs = 0
setActiveJobs()

-- Update on DB file changes
local jobDbWatch = vim.uv.new_fs_event()
local res = jobDbWatch:start(
   vim.fs.abspath( '~/.local/share/jobDb/db/jobsDb.sqlite' ), {},
   function( err, filename, events )
      setActiveJobs()
   end )

-- nvim-lualine/lualine.nvim
-- Some themes do not set everything they should
local fixedTheme = require( 'lualine.themes.zenbones' )
fixedTheme.insert.b = fixedTheme.insert.a
fixedTheme.command.b = fixedTheme.command.a
fixedTheme.visual.b = fixedTheme.visual.a
fixedTheme.replace.b = fixedTheme.replace.a
fixedTheme.terminal = fixedTheme.insert
require( 'lualine' ).setup( {
   options = {
      theme = fixedTheme,
      always_divide_middle = false,
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' },
   },
   tabline = {
      lualine_a = {},
      lualine_b = {
         'progress',
         {
            'location',
            cond = function() return not vim.b.bigFile end,
         },
         {
            'diff',
            colored = false,
            symbols = {added = ' ', modified = ' ', removed = ' '},
            source = function()
               local gitsigns = vim.b.gitsigns_status_dict
               if gitsigns then
                  return {
                     added = gitsigns.added,
                     modified = gitsigns.changed,
                     removed = gitsigns.removed
                  }
               end
            end,
         },
         'branch',
      },
      lualine_c = {
         {
            function()
               return '󰀦 '
            end,
            cond = function() return vim.b.bigFile end,
         },
         {
            'diagnostics',
            colored = false, -- Displays diagnostics status in color if set to true.
         },
         {
            'aerial',
            colored = false,
         },
         {
            'searchcount',
            cond = function() return not vim.b.bigFile end,
         },
         {
            'selectioncount',
            cond = function() return not vim.b.bigFile end,
         },
      },
      lualine_x = {},
      lualine_y = {
         {
            'tabs',
            use_mode_colors = true,
            cond = function() return vim.fn.tabpagenr( '$' ) > 1 end,
            mode = 0, -- Shows tab_nr
            symbols = {
               modified = '  ',
            },
         },
      },
      lualine_z = {
         {
            'g:active_jobs',
            icon = '',
            cond = function() return vim.g.active_jobs > 0 end,
         },
         "string.gmatch( vim.env.HOSTNAME, '([%a%d%-]+).*' )()",
      },
   },
   winbar = {},
   inactive_winbar = {},
   sections = {
      lualine_a = {
         {
            'filename',
            symbols = {
               modified = ' ', -- Text to show when the file is modified.
               readonly = ' ', -- Text to show when the file is non-modifiable or readonly.
               unnamed = ' ', -- Text to show for unnamed buffers.
               newfile = ' ', -- Text to show for newly created file before first write
            },
         },
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
   },
   inactive_sections = {
      lualine_a = {
         {
            'filename',
            symbols = {
               modified = ' ', -- Text to show when the file is modified.
               readonly = ' ', -- Text to show when the file is non-modifiable or readonly.
               unnamed = ' ', -- Text to show for unnamed buffers.
               newfile = ' ', -- Text to show for newly created file before first write
            },
         },
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
   },
   extensions = {
      -- 'fugitive',
      'fzf',
      'quickfix',
      'lazy',
      'aerial',
   },
} )
vim.o.showmode = false
vim.opt.shortmess:append( 'S' )
vim.o.showcmd = false
vim.o.laststatus = 2
vim.o.ruler = false

-- gitsigns.nvim
require('gitsigns').setup( {
   attach_to_untracked = true,
   worktrees = {
      {
         toplevel = vim.env.HOME,
         gitdir = vim.env.HOME .. '/.cfg',
      },
   },
   on_attach = function( bufnr )
      local gitsigns = require( 'gitsigns' )

      vim.keymap.set( 'n', '<Leader>gt',
         gitsigns.toggle_signs, { noremap = true, buffer = bufnr } )
      vim.keymap.set( 'n', '<Leader>gp',
         gitsigns.preview_hunk,
         { noremap = true, buffer = bufnr } )
      vim.keymap.set( 'n', '<Leader>gd', ':Gitsigns diffthis<space>',
         { noremap = true, buffer = bufnr } )
      vim.keymap.set( {'n', 'x'}, '<Leader>gs',
         gitsigns.stage_hunk, { noremap = true, buffer = bufnr } )
      vim.keymap.set( {'n', 'x'}, '<Leader>gu',
         gitsigns.undo_stage_hunk, { noremap = true, buffer = bufnr } )
      vim.keymap.set( {'n', 'x'}, '<Leader>gr',
         gitsigns.reset_hunk, { noremap = true, buffer = bufnr } )
      vim.keymap.set( 'n', '<Leader>gc', ':Gitsigns change_base<space>',
         { noremap = true, buffer = bufnr } )
      vim.keymap.set('n', '<Leader>gb',
         gitsigns.blame_line, { noremap = true, buffer = bufnr })
      -- vim.keymap( 'n', '<leader>gq', function()
      --       gitsigns.setqflist( 'all' )
      --    end, { noremap = true, buffer = bufnr } )
      vim.keymap.set( {'n', 'x'}, ']c', function()
         if vim.wo.diff then return ']c' end
            vim.schedule( function() gitsigns.nav_hunk( 'next' ) end )
            return '<Ignore>'
         end, { expr = true, buffer = bufnr } )
      vim.keymap.set( {'n', 'x'}, '[c', function()
            if vim.wo.diff then return '[c' end
               vim.schedule( function() gitsigns.nav_hunk( 'prev' ) end )
            return '<Ignore>'
         end, { expr = true, buffer = bufnr } )
   end
} )
require( 'scrollbar.handlers.gitsigns' ).setup()

-- leap.nvim
local leap = require('leap')
-- Setting the list to `{}` effectively disables the autojump feature.
leap.opts.safe_labels = {}
leap.opts.labels = { 's', 'f', 'n', 'j', 'k', 'l', 'h', 'o', 'd', 'w', 'e',
   'i', 'm', 'b', 'u', 'y', 'v', 'r', 'g', 't', 'a', 'q', 'p', 'c', 'x', 'z' }
-- vim.api.nvim_set_hl( 0, 'LeapBackdrop', { link = 'Comment' } )
vim.keymap.set( { 'n', 'x', 'o' }, 'f', '<Plug>(leap-forward)' )
vim.keymap.set( { 'n', 'x', 'o' }, 'F', '<Plug>(leap-backward)' )
vim.keymap.set( { 'n', 'x', 'o' }, 't', '<Plug>(leap-forward-till)' )
vim.keymap.set( { 'n', 'x', 'o' }, 'T', '<Plug>(leap-backward-till)' )

-- LSP
local onAttachSymbols = function( client, bufnr )
   -- Register key mappings for definitions and references
   vim.keymap.set('n', '<leader>ld', function()
      require( 'fzf-lua' ).lsp_definitions()
   end, { buffer = true } )
   vim.keymap.set('n', '<leader>lr', function()
      require( 'fzf-lua' ).lsp_references()
   end, { buffer = true } )

   vim.api.nvim_buf_create_user_command( 0,
      'FzfLuaWorkspaceSymbols', function( arg )
         require( 'fzf-lua' ).lsp_workspace_symbols( { lsp_query = arg.args } )
      end, { nargs = 1 } )
   vim.keymap.set( 'n', '<leader>lws', ':FzfLuaWorkspaceSymbols<space>',
                   { buffer = true } )
end

local onAttachCodeAction = function( client, bufnr )
   -- Register key mappings for code action
  vim.keymap.set('n', '<leader>la', function()
     vim.lsp.buf.code_action()
  end, { buffer = true } )
end

vim.lsp.config( 'ar-pylint-ls', {
   cmd = { 'ar-pylint-ls' },
   filetypes = { 'python' },
   root_dir = '/src',
   settings = { debug = false },
} )
vim.lsp.enable( 'ar-pylint-ls' )

vim.lsp.config( 'artaclsp', {
   cmd = { 'artaclsp' },
   filetypes = { 'tac' },
   root_dir = '/src',
   on_attach = function( client, bufnr )
      onAttachSymbols( client, bufnr )
      onAttachCodeAction( client, bufnr )
   end,
} )
vim.lsp.enable( 'artaclsp' )

vim.lsp.config( 'ar-formatdiff-ls', {
   cmd = { 'ar-formatdiff-ls' },
   root_dir = '/src',
   settings = { debug = false },
} )
vim.lsp.enable( 'ar-formatdiff-ls' )

vim.lsp.config( 'ar-grok-ls', {
   cmd = { 'ar-grok-ls' },
   root_dir = '/src',
   settings = { debug = false },
   on_attach = onAttachSymbols,
} )
vim.lsp.enable( 'ar-grok-ls' )

-- Configure diagnostic signs to match lualine
local lualineDiagConfig = require( 'lualine.components.diagnostics.config' )
local diagSymbols = lualineDiagConfig.symbols.icons

vim.diagnostic.config( {
   underline = false,
   -- virtual_lines = {
   --    current_line = true,
   -- },
   signs = {
      text = {
         [vim.diagnostic.severity.ERROR] = diagSymbols[ 'error' ],
         [vim.diagnostic.severity.WARN] = diagSymbols[ 'warn' ],
         [vim.diagnostic.severity.INFO] = diagSymbols[ 'info' ],
         [vim.diagnostic.severity.HINT] = diagSymbols[ 'hint' ],
      },
   },
   float = {
      scope = 'cursor',
      source = 'if_many',
   },
   severity_sort = true,
   jump = {
      float = true,
   },
} )

-- LSP formatting
vim.keymap.set( 'n', '<leader>lf', function()
   vim.lsp.buf.format( { timeout_ms=10000 } ) end )

-- Treesitter
require( 'nvim-treesitter.configs' ).setup( {
   auto_install = false,
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
   textsubjects = {
      enable = true,
      keymaps = {
          ['ac'] = 'textsubjects-container-outer',
          ['ic'] = 'textsubjects-container-inner',
      },
   },
} )

-- Treesitter configuration for tree-sitter-tac
require( 'nvim-treesitter.install' ).prefer_git = true
local parser_config = require( 'nvim-treesitter.parsers' ).get_parser_configs()
parser_config.tac = {
   install_info = {
      url = '~/projects/tree-sitter-tac',
      files = { 'src/parser.c', 'src/scanner.c' },
   },
   filetype = 'tac',
}

-- aerial.nvim
require( 'aerial' ).setup( {
   backends = { 'treesitter', 'lsp' },
   layout = {
      default_direction = 'prefer_left',
      placement = 'edge',
      resize_to_content = false,
      preserve_equality = true,
   },
   attach_mode = 'global',
   -- Keymaps in aerial window. Set to `false` to remove a keymap.
   keymaps = {
     [ 'l' ] = false,
     [ 'L' ] = false,
     [ 'h' ] = false,
     [ 'H' ] = false,
   },
   disable_max_lines = 0, -- disabled
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
vim.keymap.set('n', '<Leader>as', require( 'aerial' ).fzf_lua_picker, { noremap = true })

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

-- WinShift
vim.keymap.set( 'n', '<Leader>w', '<cmd>WinShift<cr>' )

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
   picker = {
      select = {
         action = yankyPicker.actions.set_register(
            yankyUtils.get_default_register() )
      },
   },
} )
vim.keymap.set( { 'n','x' }, 'p', '<Plug>(YankyPutAfter)' )
vim.keymap.set( { 'n','x' }, 'P', '<Plug>(YankyPutBefore)' )
vim.keymap.set( 'n', '<c-n>', '<Plug>(YankyCycleForward)' )
vim.keymap.set( 'n', '<c-p>', '<Plug>(YankyCycleBackward)' )
vim.keymap.set( 'n', '<Leader>yh', '<cmd>YankyRingHistory<cr>', { noremap = true } )

-- indent-blankline
require( 'ibl' ).setup( {
   indent = { char = '▏' },
} )
-- Enable indent-blankline only on current window
vim.api.nvim_create_autocmd( { 'VimEnter', 'WinEnter', 'BufWinEnter' },
   { group = 'config',
     pattern = '*',
     callback = function()
        if vim.b.bigFile then
           return
        end
        require( 'ibl' ).setup_buffer( 0, { enabled = true, } )
     end, } )
vim.api.nvim_create_autocmd( { 'WinLeave' },
   { group = 'config',
     pattern = '*',
     callback = function()
        require( 'ibl' ).setup_buffer( 0, { enabled = false, } )
     end, } )

-- Open Lazygit in directory
local function openLazygitDir( packageName )
   if not packageName then
      return
   end

   if vim.fn.executable( 'lazygit' ) == 0 then
      vim.notify( 'lazygit not available', vim.log.levels.ERROR )
      return
   end

   -- Open Lazygit
   vim.cmd.tabnew()
   buffer = vim.fn.bufnr()
   vim.fn.termopen( 'lazygit', {
      cwd=packageName,
      on_exit=function( _, exitCode, _ )
         if exitCode == 0 then
            vim.cmd.bwipeout( buffer )
         end
      end,
   } )
end

-- Process list of Gitar packages
local function lazyGitar()
   -- Get the list of Gitar packages
   local cmdList = { 'agu-minimal', 'included-packages' }
   local results = vim.system( cmdList, { text = true } ):wait()
   local packageNames = vim.split( results.stdout, '\n', { trimempty=true } )

   -- Process the package list.
   local packageDirs = {}
   local i = 1
   while i <= #( packageNames ) do
      packageName = packageNames[ i ]

      if packageName == 'GitarBandMutDb' then
         -- Remove GitarBandMutDb, which is always included
         table.remove( packageNames, i )
      else
         -- Populate list of package directories
         packageDir = '/src/' .. packageName
         table.insert( packageDirs, packageDir )
         i = i + 1
      end
   end
   if #( packageNames ) == 0 then
      vim.notify( 'No git packages.', vim.log.levels.INFO )
      return
   end

   -- Update ~/.config/lazygit/state.yml with the package directories
   local transformation =
      '.recentrepos = [ "' .. table.concat( packageDirs, '", "' ) .. '" ]'
   local cmdList = {
      'yq',
      '--yaml-output',
      '--in-place',
      transformation,
      os.getenv( 'HOME' ) .. '/.config/lazygit/state.yml' }
   vim.system( cmdList, { text = true } ):wait()

   -- Invoke Lazygit
   -- Use git repo information from gitsigns if available
   if vim.b[ 'gitsigns_status_dict' ] ~= nil then
      openLazygitDir( vim.b.gitsigns_status_dict[ 'root' ] )
      return
   end

   -- Single package workspace
   if #( packageNames ) == 1 then
      vim.schedule_wrap( openLazygitDir )( packageNames[ 1 ] )
      return
   end

   -- Select package
   vim.schedule_wrap( vim.ui.select )(
      packageNames, { prompt = 'Package:' }, openLazygitDir )
end

vim.api.nvim_create_user_command( 'LazyGitar', function()
   vim.schedule_wrap( lazyGitar )()
end, {} )
vim.keymap.set( 'n', '<leader>lg', '<cmd>LazyGitar<cr>', { noremap = true } )

-- diffview.nvim
vim.keymap.set( 'n', '<Leader>do', '<cmd>DiffviewOpen<cr>', { noremap = true } )
vim.keymap.set( 'n', '<Leader>DO', ':DiffviewOpen<space>', { noremap = true } )
vim.keymap.set( 'n', '<Leader>dh', '<cmd>DiffviewFileHistory<cr>', { noremap = true } )
vim.keymap.set( 'v', '<Leader>dh', ':DiffviewFileHistory<cr>', { noremap = true } )
vim.keymap.set( 'n', '<Leader>DH', ':DiffviewFileHistory<space>', { noremap = true } )
vim.keymap.set( 'v', '<Leader>DH', ':DiffviewFileHistory<space>', { noremap = true } )
