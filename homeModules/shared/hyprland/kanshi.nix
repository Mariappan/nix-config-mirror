{
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    profiles = {
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            scale = 1.0;
            status = "enable";
          }
        ];
      };

      home_office = {
        outputs = [
          {
            criteria = "Dell Inc. DELL U2724DE 1LRK7P3";
            position = "0,0";
            mode = "2560x1440@60Hz";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      };

      office = {
        outputs = [
          {
            criteria = "Beihai Century Joint Innovation Technology Co.,Ltd X340 PRO 165 Unknown";
            position = "0,0";
            mode = "3440x1440@60Hz";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      };
    };
  };
}
