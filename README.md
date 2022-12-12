# Dotfiles
A list of my configuration scripts (dotfiles)

These dotfiles are copied directly from my own `~/.config/` directory with no modification. 
The additional files `included` and `sync.sh` contain the program configuration names and a program which copies the selected program configurations (from `included`) from the `~/.config/` directory.
Other required packages may be needed for configurations such as packer for `nvim` and `jetbrains mono` font.

# Installation
Dotfiles may be directly placed in the `~./config/` directory if the correct packages are installed

## Links to additional packages for configuration

| Package Name | Link | Required by |
| - | - | - |
| packer.nvim | https://github.com/wbthomason/packer.nvim | nvim |
| Jetbrains Mono | https://github.com/JetBrains/JetBrainsMono | bspwm kitty |
| dmenu | https://github.com/stilvoid/dmenu | sxhkd bspwm |
| vim-plug | https://github.com/junegunn/vim-plug | nvim |
