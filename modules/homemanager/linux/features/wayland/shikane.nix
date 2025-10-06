{ pkgs, ... }: {
  home.packages = [
    pkgs.shikane
  ];

  services.shikane = {
    enable = true;

    settings = {
      profile = [
        {
          name = "default";
          exec = ["notify-send shikane \"Profile '$SHIKANE_PROFILE_NAME' has been applied\"" ];
          output = [
            {
              match = "eDP-1";
              enable = true;
            }
          ];
        }
        {
          name = "Home office";
          exec = ["notify-send shikane \"Profile '$SHIKANE_PROFILE_NAME' has been applied\"" ];
          output = [
            {
              match = "eDP-1";
              enable = false;
            }
            {
              search = ["m=DELL U2724DE" "s=1LRK7P3" "v=Dell Inc."];
              enable = true;
            }
          ];
        }
        {
          name = "Office";
          exec = ["notify-send shikane \"Profile '$SHIKANE_PROFILE_NAME' has been applied\"" ];
          output = [
            {
              match = "eDP-1";
              enable = false;
            }
            {
              search = ["v%Beihai Century" "m=X340 PRO 165"];
              enable = true;
            }
          ];
        }
      ];
    };
  };
}
