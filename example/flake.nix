{
  description = "Build example NixOS image for Quartz64A";

  inputs = {
    utils.url    = "github:numtide/flake-utils";
    nixpkgs.url  = "github:NixOS/nixpkgs/nixos-23.11";

    rockchip = {
      url = "github:nabam/nixos-rockchip";
    };
  };

  # Use cache with packages from nabam/nixos-rockchip CI.
  nixConfig = {
    extra-substituters = [ "https://nabam-nixos-rockchip.cachix.org" ];
    extra-trusted-public-keys = [
      "nabam-nixos-rockchip.cachix.org-1:BQDltcnV8GS/G86tdvjLwLFz1WeFqSk7O9yl+DR0AVM"
    ];
  };

  outputs = { self, ... }@inputs:
    let
      osConfig = system: inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          inputs.rockchip.nixosModules.sdImageRockchip
          inputs.rockchip.nixosModules.dtOverlayQuartz64ASATA
          inputs.rockchip.nixosModules.dtOverlayPCIeFix
          ./config.nix
          {
            # Use cross-compilation for uBoot and Kernel.
            rockchip.uBoot = (inputs.rockchip.uBoot system).uBootQuartz64A;
            boot.kernelPackages = (inputs.rockchip.kernel system).linux_6_6_rockchip;
          }
        ];
      };
    in {
      # Set system to "x86_64-linux" by default to benefit from cross-compiled packages in the cache.
      nixosConfigurations.quartz64 = osConfig "x86_64-linux";

      # Or use configuration below to compile kernel and uBoot on device.
      # nixosConfigurations.quartz64 = osConfig "aarch64-linux";
    } // inputs.utils.lib.eachDefaultSystem ( system: {
      # Set system to "x86_64-linux" by default to benefit from cross-compiled packages in the cache.
      packages.image = (osConfig "x86_64-linux").config.system.build.sdImage;

      # Or use configuration below to cross-compile kernel and uBoot on the current platform.
      # packages.image = (osConfig system).config.system.build.sdImage;

      defaultPackage = self.packages."${system}".image;
    });
}
