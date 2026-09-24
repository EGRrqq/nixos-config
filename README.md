# NixOS Config

Personal NixOS configuration for the "blob" machine, using the dendritic pattern with flake-parts and import-tree

## Structure

```
flake.nix                    - flake inputs and entry point
modules/
  parts.nix                  - flake-parts config (target systems)
  blob-host/                 - machine-specific files
    default.nix              - wires up the "blob" nixosConfiguration
    configuration.nix        - imports all modules for this machine
    egr.nix                  - the "egr" user
    hardware-configuration.nix
  features/                  - reusable NixOS modules, one per file
    app-*.nix                - applications and packages
    desktop-*.nix            - display manager, window manager, keyring
    hw-*.nix                 - hardware drivers and firmware
    sys-*.nix                - system settings
    srv-*.nix                - services
  home-manager/              - home-manager config for user "egr"
    default.nix              - assembles the egr home from fragments
    _fragments/              - home-manager modules (not flake modules)
```

## How it works

Every `.nix` file under `modules/` is a flake-parts module, imported automatically by import-tree

Files under a folder starting with `_` are ignored by import-tree, so `_fragments/` holds plain home-manager modules picked up by `default.nix`

## Usage

```sh
sudo nixos-rebuild switch --flake ~/.config/nixos#blob
```

If the rebuild changes the config, deploy with `boot`, not `switch`, to keep a known-good generation around in case the new system fails to boot

## Conventions

- Feature files are named with a domain prefix (`app-`, `desktop-`, `hw-`, `sys-`, `srv-`)
- Anything specific to this machine goes in `blob-host/`, reusable things go in `features/`
- Add a feature by dropping a new file into `modules/features/` and importing it in `modules/blob-host/configuration.nix`