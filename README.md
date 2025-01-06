### initializing flake
```
sudo nix flake init --template github:vimjoyer/flake-starter-config
```

### rebuilding with flakes enabled
```
sudo nixos-rebuild switch --flake ~/.config/nixos/#default
```

