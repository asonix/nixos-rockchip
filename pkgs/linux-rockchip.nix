{ pkgs, lib }:

let
  kernelConfig = with lib.kernel; {
    ARCH_ROCKCHIP = yes;
    CHARGER_RK817 = yes;
    COMMON_CLK_RK808 = yes;
    COMMON_CLK_ROCKCHIP = yes;
    GPIO_ROCKCHIP = yes;
    MFD_RK808 = yes;
    MMC_DW = yes;
    MMC_DW_ROCKCHIP = yes;
    MMC_SDHCI_OF_DWCMSHC = yes;
    MOTORCOMM_PHY = yes;
    PCIE_ROCKCHIP_DW_HOST = yes;
    PHY_ROCKCHIP_INNO_CSIDPHY = yes;
    PHY_ROCKCHIP_INNO_DSIDPHY = yes;
    PHY_ROCKCHIP_INNO_USB2 = yes;
    PHY_ROCKCHIP_NANENG_COMBO_PHY = yes;
    PINCTRL_ROCKCHIP = yes;
    PWM_ROCKCHIP = yes;
    REGULATOR_RK808 = yes;
    ROCKCHIP_DW_HDMI = yes;
    ROCKCHIP_IODOMAIN = yes;
    ROCKCHIP_IOMMU = yes;
    ROCKCHIP_MBOX = yes;
    ROCKCHIP_PHY = yes;
    ROCKCHIP_PM_DOMAINS = yes;
    ROCKCHIP_SARADC = yes;
    ROCKCHIP_THERMAL = yes;
    ROCKCHIP_VOP2 = yes;
    RTC_DRV_RK808 = yes;
    SND_SOC_RK817 = yes;
    SND_SOC_ROCKCHIP = yes;
    SND_SOC_ROCKCHIP_I2S_TDM = yes;
    SPI_ROCKCHIP = yes;
    STMMAC_ETH = yes;
    VIDEO_HANTRO_ROCKCHIP = yes;
  };
in
with pkgs.linuxKernel;
{
  linux_6_1          = pkgs.linuxPackages_6_1;
  linux_6_1_rockchip = packagesFor (kernels.linux_6_1.override { structuredExtraConfig = kernelConfig; });

  linux_6_6          = pkgs.linuxPackages_6_6;
  linux_6_6_rockchip = packagesFor (kernels.linux_6_6.override { structuredExtraConfig = kernelConfig; });

  linux_6_6_pinetab  = packagesFor (kernels.linux_6_6.override {
    argsOverride = {
      src = pkgs.fetchFromGitHub {
        owner = "dreemurrs-embedded";
        repo = "linux-pinetab2";
        rev = "81e3aa387e0dcb349e0d3f3c05f2f62742f814d7";
        sha256 = "kkO54FbexUuuvZNFDuTtFMokBgKrCZXTQDCzsSRZNDE=";
      };
      version = "6.6.8-danctnix1";
      modDirVersion = "6.6.8-danctnix1";
    };
    structuredExtraConfig = kernelConfig;
  });
}

