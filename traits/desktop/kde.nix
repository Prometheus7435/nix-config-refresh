{ inputs, pkgs, username, ... }: {
  imports = [

  ];

  services = {
    accounts-daemon.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "us";
      # xkb.options = "grp:win_space_toggle";

      desktopManager = {
        plasma5 = {
          enable = true;
        };
      };

      displayManager = {
        lightdm.enable = true;  # lets me autoLogin after decrypting zfs
        defaultSession = "plasmawayland";
        autoLogin = {
          enable = true;
          user = "${username}";
        };
      };
    };

  };

  programs = {
    dconf = {
      enable = true;
    };
    kdeconnect = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    libsForQt5.applet-window-buttons
    libsForQt5.discover
    libsForQt5.dragon
    libsForQt5.filelight
    libsForQt5.kalk
    libsForQt5.kfind
    libsForQt5.plasma-integration
    libsForQt5.xdg-desktop-portal-kde
    libsForQt5.kdecoration
    libsForQt5.qtstyleplugin-kvantum
    okular
    kate
  ];
}
