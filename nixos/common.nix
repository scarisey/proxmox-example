{ lib, config, pkgs, inputs, outputs, ... }:
{
  imports = [
    inputs.nixos-generators.nixosModules.all-formats
  ];
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };
  time = {
    hardwareClockInLocalTime = true;
    timeZone = "Europe/Paris";
  };
  i18n = {
    defaultLocale = "fr_FR.UTF-8";
  };
  console.keyMap = "fr";
  services.journald = {
    extraConfig = ''
      SystemMaxUse=512MB
      RuntimeMaxUse=512MB
    '';
  };
  users.users.foo = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "foo"; #TODO you should rename this user
    extraGroups = [ "networkmanager" "wheel" "jellyfin" ];
  #  openssh.authorizedKeys.keys = [ ]; //TODO put your ssh keys here
    hashedPassword = "$y$j9T$lqgsPmt3CQRacIs4/TQqk0$XAvgjsZiAJxZX0c7/jz2U97j3oWjaNvaHlPWt804hu7"; #TODO you can put a password here with `mkpasswd -m sha512crypt`
  };
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];
  programs.zsh.enable = true;
  services.openssh = lib.mkDefault {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    extraConfig = ''
      HashKnownHosts yes
    '';
  };

  system.stateVersion = "23.05";
}
