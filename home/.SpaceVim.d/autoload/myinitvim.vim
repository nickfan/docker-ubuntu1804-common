func! myinitvim#after() abort
  #if !has('nvim')
  #  set ttymouse=xterm2
  #endif
  #if (has("termguicolors"))
  #  set termguicolors
  #endif

  #let g:spacevim_default_indent = 2
  #let g:spacevim_max_column     = 80

  #let g:spacevim_guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ 11'
  #let g:spacevim_relativenumber = 0
    
  #let mapleader = "\<space>"
  #let g:spacevim_windows_leader = 's'
  #let g:spacevim_unite_leader = 'f'
  #call SpaceVim#layers#load('lang#go')

  #set nu!
  #set mouse=i
  #set paste

endf

