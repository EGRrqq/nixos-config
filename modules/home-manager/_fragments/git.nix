{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      init.defaultBranch = "main";
      core.editor = "hx";
      user = {
        name = "EGR";
        email = "egrrqqdev@gmail.com";
      };
      aliases = {
        ci = "commit";
        co = "checkout";
        s = "status";
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      hosts = [ "github.com" ];
    };
    settings = {
      git_protocol = "ssh";
    };
  };

  # programs.jujutsu = {
  #   enable = true;
  #   settings = {
  #     user = { name = "EGRrqq"; email = "egrrqqdev@gmail.com"; };
  #   };
  # };
}