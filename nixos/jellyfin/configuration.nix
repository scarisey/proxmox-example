{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ../common.nix
  ];
  networking.hostName = "jellyfin";
  networking.enableIPv6 = false;
  networking.networkmanager.enable = true;
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" "1.1.1.1" ];
  services.resolved = {
    enable = true;
    fallbackDns = [ "8.8.8.8" "1.1.1.1"];
  };

  environment.systemPackages = with pkgs;[
    dig
    netcat-openbsd
  ];
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  programs.zsh = {
    enableCompletion = true;
    enableBashCompletion = true;
  };

}
