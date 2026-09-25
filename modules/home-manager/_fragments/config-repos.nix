{
  config,
  lib,
  pkgs,
  ...
}:
let
  configRepos = [
    {
      name = "bash";
      branch = "main";
    }
    {
      name = "carapace";
      branch = "main";
    }
    {
      name = "helix";
      branch = "main";
    }
    {
      name = "niri";
      branch = "main";
    }
    {
      name = "noctalia";
      branch = "main";
    }
    {
      name = "nushell";
      branch = "main";
    }
    {
      name = "nvim";
      branch = "jeez";
    }
    {
      name = "starship";
      branch = "main";
    }
    {
      name = "wezterm";
      branch = "main";
    }
  ];

  configDir = config.xdg.configHome;

  gitBin = lib.getExe pkgs.git;

  repoEntries = map (repo: "${repo.name} ${repo.branch}") configRepos;

  syncScript = pkgs.writeShellScriptBin "config-repos-sync" ''
    set -uo pipefail

    config_dir=${lib.escapeShellArg configDir}
    git_bin=${lib.escapeShellArg gitBin}
    quiet=0
    [ "''${1:-}" = "--quiet" ] && quiet=1

    for entry in ${lib.concatMapStringsSep " " lib.escapeShellArg repoEntries}; do
      set -- $entry
      name="$1"
      branch="$2"
      dir="$config_dir/$name"
      url=$(printf 'https://github.com/EGRrqq/%s.git' "$name")

      if [ ! -d "$dir/.git" ]; then
        mkdir -p "$(dirname "$dir")"
        if timeout 60 "$git_bin" clone --quiet --branch "$branch" "$url" "$dir"; then
          [ "$quiet" = 1 ] || echo "config-repos: cloned $name ($branch)"
        else
          echo "config-repos: failed to clone $name ($branch)" >&2
        fi
        continue
      fi

      current=$("$git_bin" -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null) || continue
      if [ "$current" != "$branch" ]; then
        [ "$quiet" = 1 ] || echo "config-repos: skipped $name (on $current, expected $branch)" >&2
        continue
      fi

      if [ -n "$("$git_bin" -C "$dir" status --porcelain 2>/dev/null)" ]; then
        [ "$quiet" = 1 ] || echo "config-repos: skipped $name (uncommitted changes)" >&2
        continue
      fi

      before=$("$git_bin" -C "$dir" rev-parse HEAD)
      if timeout 60 "$git_bin" -C "$dir" fetch --quiet "$url" "$branch" 2>/dev/null; then
        if "$git_bin" -C "$dir" merge --ff-only --quiet FETCH_HEAD 2>/dev/null; then
          after=$("$git_bin" -C "$dir" rev-parse HEAD)
          if [ "$before" != "$after" ]; then
            [ "$quiet" = 1 ] || echo "config-repos: updated $name ($branch)"
          fi
        else
          [ "$quiet" = 1 ] || echo "config-repos: skipped $name (local commits, no fast-forward)" >&2
        fi
      else
        [ "$quiet" = 1 ] || echo "config-repos: skipped $name (fetch failed)" >&2
      fi
    done
  '';
in
{
  home.activation.configRepos = lib.hm.dag.entryAfter [ "linkConfFiles" ] ''
    ${syncScript}/bin/config-repos-sync --quiet || true
  '';

  home.packages = [ syncScript ];
}
