if status is-interactive
   # Commands to run in interactive sessions can go here
   fish_add_path --prepend ~/.local/bin
   set -e VISUAL
   set -gx TZ 'America/Vancouver'
   set -gx TZDIR /usr/share/zoneinfo
   set -gx EDITOR nvim
   set -gx NOTI_PB o.xXcIRDklt4berjLHFbbiwOe7f8QjRDml
   set -gx P4_AUTO_LOGIN 1
   set -gx SKIPTACGO 1

   function key_bindings
      fish_vi_key_bindings

      # Remove some annoying preset escape bindings from insert/visual mode.
      for mode in insert visual
         bind --silent --erase --preset -M $mode \ee
         bind --silent --erase --preset -M $mode \eh
         bind --silent --erase --preset -M $mode \el
         bind --silent --erase --preset -M $mode \ev
         bind --silent --erase --preset -M $mode \ew
         bind --silent --erase --preset -M $mode \ep
      end
   end

   set -g fish_greeting
   set -g fish_key_bindings key_bindings
   set -g fish_prompt_pwd_dir_length 1

   if set -q NVIM; and command -q nvr
      set -gx EDITOR "nvr --servername $NVIM --remote-wait +'set bufhidden=wipe'"
      alias nvim=$EDITOR
   end

   # Aliases
   alias vi='nvim -u NONE'
   alias pb='curl -F "t=$USER@arista.com" -F c=@- pb.infra.corp.arista.io'
   alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

   # Fzf
   if command -q fzf
      # Set up fzf key bindings
      fzf --fish | source
   end

   if test -e ~/.gemini_api_key
      read -gx GEMINI_API_KEY < ~/.gemini_api_key
   end
   set -gx RIPGREP_CONFIG_PATH ~/.ripgreprc

   # Functions
   function newdir -a dir
      mkdir -p $dir
      echo -n $dir
   end
end
