{ self, inputs, ... }:
{
  flake.nixosModules.yazi =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          yaziPlugins = prev.yaziPlugins // {
            yatline = prev.yaziPlugins.yatline.overrideAttrs (old: {
              postPatch =
                (old.postPatch or "")
                + ''
                  substituteInPlace main.lua --replace-fail \
                    'hovered:icon().text' \
                    'th.icon:match(hovered).text'
                '';
            });
          };
        })
      ];
    };
}
