{ config, pkgs, ... }:

{
  home.username = "home";
  home.homeDirectory = "/home/home";
  home.stateVersion = "24.11";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
  };

  home.packages = with pkgs; [
    libreoffice
    mpv
    wezterm
    yt-dlp
    transmission_4-qt
    vlc
  ];

  home.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

  # Disable Gnome donation reminder
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/housekeeping" = {
      donation-reminder-enabled = false;
    };
  };

  home.shellAliases = {
    hms = "home-manager switch --flake ~/nixos-config/#home";
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config/#nixos";
    cleanup = "sudo nix-collect-garbage -d"; 
    sunvim = "sudo -E nvim"; 
    pbcopy = "wl-copy";
    pbpaste = "wl-paste";
  };

  # IMPORTANT: This must be true for home-manager to write to bashrc
  programs.bash.enable = true; 

  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      settings = {
        # --- PRIVACY & TELEMETRY ---
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "app.shield.optoutstudies.enabled" = false;

        # --- AI & BLOAT OPT-OUT ---
        "browser.ml.enable" = false;             # Disable local ML engine
        "browser.ml.chat.enabled" = false;       # Disable Chatbot sidebar
        "browser.ml.linkPreview.enabled" = false;# Disable AI link previews
        "browser.tabs.groups.smart.enabled" = false; 
        "extensions.getAddons.showPane" = false; # Hide "Recommendations"
        "browser.discovery.enabled" = false;     # Disable "Pocket" discovery
        
        # --- UX TWEAKS ---
        "browser.shell.checkDefaultBrowser" = false;
        "browser.aboutConfig.showWarning" = false;
      };
    };
  };
    
  programs.git = {
    enable = true;

    # 1. Identity goes at the TOP level (not inside a settings block)
    userName = "scott96707";
    userEmail = "scott96707@gmail.com";

    # 2. Aliases have their own specific option
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      br = "branch";
      hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
      type = "cat-file -t";
      dump = "cat-file -p";
    };

    # 3. Everything else goes into 'extraConfig'
    extraConfig = {
      # Core settings
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
      color.ui = true;
      push.autoSetupRemote = true;
      safe.directory = "/home/home/nixos-config";

      # Delta Configuration (Modern Diff)
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      
      delta = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
      };

      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
    };
  };

  programs.neovim = {
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;

  # --- 1. PLUGINS (Replaces Lazy.nvim) ---
  plugins = with pkgs.vimPlugins; [
    
    # Dependencies (Explicitly added to be safe)
    plenary-nvim
    nvim-web-devicons
    nui-nvim

    # Add Indent Blankline (Vertical Context Lines)
    {
      plugin = indent-blankline-nvim;
      config = ''
        require("ibl").setup({
            scope = { enabled = true },  -- Highlight the current context
            indent = { char = "│" },     -- Use a solid vertical bar
        })
      '';
      type = "lua";
    }
    # Theme: Tokyo Night
    {
      plugin = tokyonight-nvim;
      config = "vim.cmd[[colorscheme tokyonight]]";
      type = "lua";
    }

    # File Explorer: Neo-tree
    {
      plugin = neo-tree-nvim;
      config = ''
        -- Keymaps for Neo-tree
        vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Explorer' })
      '';
      type = "lua";
    }

    # Fuzzy Finder: Telescope
    {
      plugin = telescope-nvim;
      config = ''
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find File' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Find Text' })
      '';
      type = "lua";
    }

    # Status Line: Lualine
    {
      plugin = lualine-nvim;
      config = "require('lualine').setup()";
      type = "lua";
    }

    # Autopairs
    {
      plugin = nvim-autopairs;
      config = "require('nvim-autopairs').setup({})";
      type = "lua";
    }

    # Treesitter (Highlighting)
    # Note: We use 'withAllGrammars' so you don't need to manually install parsers
    {
      plugin = nvim-treesitter.withAllGrammars;
      config = ''
        require('nvim-treesitter.configs').setup({
          highlight = { enable = true },
          indent = { enable = true },
          auto_install = false, -- Nix handles this, so turn off auto-install
        })
      '';
      type = "lua";
    }
  ];

    # --- 2. GENERAL SETTINGS (Your vim.opt options) ---
    extraLuaConfig = ''
      vim.g.mapleader = " "
      vim.opt.clipboard = "unnamedplus"

      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.softtabstop = 2
      vim.opt.ignorecase = true
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.scrolloff = 8
      vim.opt.smartcase = true
      vim.opt.termguicolors = true
      -- Highlights the specific column your cursor is on (can be noisy)
      vim.opt.cursorcolumn = true
      -- Clear search highlight on Esc
      vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
    '';
  };

  programs.readline = {
    enable = true;
    extraConfig = ''
      # Disable the weird characters during paste
      set enable-bracketed-paste off
      # Readline is how bash terminal handles
      # character inputs
      '';
  };

  programs.home-manager.enable = true;
}
