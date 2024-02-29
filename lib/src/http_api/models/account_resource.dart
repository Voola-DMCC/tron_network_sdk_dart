class AccountResourceResp {
  /// Free bandwidth used
  int? freeNetUsed;

  /// Total free bandwidth
  int? freeNetLimit;

  /// Used amount of bandwidth obtained by staking
  int? netUsed;

  /// Total bandwidth obtained by staking
  int? netLimit;

  /// Total bandwidth can be obtained by staking
  int? totalNetLimit;

  /// Total TRX staked for bandwidth
  int? totalNetWeight;

  /// TRON Power(vote)
  int? tronPowerLimit;

  /// Energy used
  int? energyUsed;

  /// Total energy obtained by staking
  int? energyLimit;

  /// Total energy can be obtained by staking
  int? totalEnergyLimit;

  /// Total TRX staked for energy
  int? totalEnergyWeight;

  Map<String, int>? assetNetUsed;
  Map<String, int>? assetNetLimit;

  AccountResourceResp(
      {this.freeNetLimit,
      this.netLimit,
      this.assetNetUsed,
      this.assetNetLimit,
      this.totalNetLimit,
      this.totalNetWeight,
      this.tronPowerLimit,
      this.energyLimit,
      this.totalEnergyLimit,
      this.totalEnergyWeight});

  AccountResourceResp.fromJson(Map<String, dynamic> json) {
    freeNetUsed = json['freeNetUsed'] ?? 0;
    freeNetLimit = json['freeNetLimit'] ?? 0;
    netUsed = json['NetUsed'] ?? 0;
    netLimit = json['NetLimit'] ?? 0;
    totalNetLimit = json['TotalNetLimit'] ?? 0;
    totalNetWeight = json['TotalNetWeight'] ?? 0;
    tronPowerLimit = json['tronPowerLimit'] ?? 0;
    energyUsed = json['EnergyUsed'] ?? 0;
    energyLimit = json['EnergyLimit'] ?? 0;
    totalEnergyLimit = json['TotalEnergyLimit'] ?? 0;
    totalEnergyWeight = json['TotalEnergyWeight'] ?? 0;

    if (json['assetNetUsed'] != null) {
      assetNetUsed = Map.fromEntries([for (var a in json['assetNetUsed']) MapEntry(a['key'] as String, a['value'] as int)]);
    }
    if (json['assetNetLimit'] != null) {
      assetNetLimit = Map.fromEntries([for (var a in json['assetNetLimit']) MapEntry(a['key'] as String, a['value'] as int)]);
    }
  }
}
