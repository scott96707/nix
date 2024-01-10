{
  config,
  pkgs,
  fetchFromGitHub,
  ...
}: 

let
  miramare = pkgs.vimUtils.buildVimPlugin {
    name = "miramare";
    src = pkgs.fetchFromGitHub {
      owner = "franbach";
      repo = "miramare";
      rev = "04330816640c3162275d69e7094126727948cd0d";
      hash = "sha256-CPxBeeWOryhSlocNZwHf2EZkdRv6LvhLu9jO+IjuzSg=";
    };
  };
in
{
  #environment.variables = { EDITOR = "vim"; };
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ 
      vim-airline 
      vim-gitgutter
      # Colors rgb, hex values in-line
      vim-css-color 
      #vim-airline/vim-airline
      #vim-airline/vim-airline-themes
      # Best colorscheme
      miramare
      #splitjoin
      #js-beautify
      # Fuzzyfinder for files within vim
      #ctrlp
      # Fuzzyfinder for grep within vim
      #/ctrlsf.vim
      # 'hail2u/vim-css3-syntax'
      ## Adds ES6 syntax support
      # 'isRuslan/vim-es6' 
      ## Add JSX syntax
      # 'mxw/vim-jsx' 
      ## JS syntax and indention support
      # 'pangloss/vim-javascript' 
      # 'psliwka/vim-smoothie'
      ## Better syntax highlighting for lots of languages
      # 'sheerun/vim-polyglot' 
      # 'tpope/vim-fugitive'
      # 'vim-python/python-syntax'
    ];
    settings = { ignorecase = true; };
    extraConfig = ''
      set mouse=a
      set cursorline    
      set expandtab     
      set hlsearch      
      set ignorecase    
      set listchars=tab:→\ ,eol:↲,space:␣,trail:•,extends:⟩,precedes:⟨
      set nobackup      
      set number        
      set shiftwidth=2  
      set showmatch     
      set softtabstop=2 
      set tabstop=2     
      set colorcolumn=80    
      let mapleader=","
      colorscheme miramare 

      noremap <F5> :set list!<CR>
      nnoremap <F6> :set number!<CR>
      nnoremap <F7> :GitGutterToggle<CR>
      nnoremap <F8> :Git blame<CR>

      " Runs CtrlSF with , W
      vmap     <C-F>f <Plug>CtrlSFVwordPath
      nnoremap <leader>W :CtrlSFVwordPath

      " Search and replace text highlighted in Visual mode
      vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

      "Enables Python syntax highlighting
      let g:python_highlight_all=1
      let g:python_highlight_builtins=1
      '';
  };
}
