{ ... }:
{
  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";

    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.5;
            status = "enable";
            position = "0,0";
            mode = "2880x1800@120Hz";
          }
        ];
      }
      {
        profile.name = "home_office";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "Dell Inc. DELL U2724DE 1LRK7P3";
            position = "0,0";
            mode = "2560x1440@60Hz";
          }
        ];
      }
      {
        profile.name = "office";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "Beihai Century Joint Innovation Technology Co.,Ltd X340 PRO 165 Unknown";
            position = "0,0";
            mode = "3440x1440@60Hz";
          }
        ];
      }
    ];
  };
}
