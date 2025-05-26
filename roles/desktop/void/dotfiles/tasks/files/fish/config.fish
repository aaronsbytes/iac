if status is-interactive
    #::::::::::::::::#
    #:::::Config:::::#
    #::::::::::::::::#
    
    # Disable default fish greeting
    set fish_greeting ""
    
    #::::::::::::::::::::::::#
    #:::::Initialization:::::#
    #::::::::::::::::::::::::#

    # Starship
    starship init fish | source

    # Fastfetch
    fastfetch

    #Zoxide
    zoxide init fish | source

    # Fish
    fzf --fish | source

    #:::::::::::::::::#
    #:::::Aliases:::::#
    #:::::::::::::::::#
    
    # Replacement for 'ls'
    alias ls="eza --icons=always --git --git-repos --all"
    
    # Replacement for 'cat'
    #alias cat="bat --theme base16 --color=always"
    
    # Terminal file manager
    alias y="yazi"
    
    # Replacement for 'cd'
    alias cd="z"

    #:::::::::::::#
    #:::::FZF:::::#
    #:::::::::::::#

    # Fzf
    alias fzf="fzf --preview 'bat --theme base16 --color=always {}'"
    
    # Bat content of selected file
    alias bfzf="bat (fzf --preview 'bat --theme base16 --color=always {}')"
    
    # Open selected path in neovim
    alias nfzf="fzf | xargs nvim"

    #::::::::::::::::::::::::::#
    #:::::Git::and::Github:::::#
    #::::::::::::::::::::::::::#
    
    # Commit
    function commit
      git add .
      git commit -m "$argv"
    end

    # Push
    alias push="git push -u origin"
end