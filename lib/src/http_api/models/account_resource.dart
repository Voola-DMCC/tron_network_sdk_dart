class AccountResourceResp {
  int? freeNetLimit;
  int? netLimit;
  Map<String, int>? assetNetUsed;
  Map<String, int>? assetNetLimit;
  int? totalNetLimit;
  int? totalNetWeight;
  int? tronPowerLimit;
  int? energyLimit;
  int? totalEnergyLimit;
  int? totalEnergyWeight;

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
    freeNetLimit = json['freeNetLimit'];
    netLimit = json['NetLimit'];
    if (json['assetNetUsed'] != null) {
      assetNetUsed = Map.fromEntries([for (var a in json['assetNetUsed']) MapEntry(a['key'] as String, a['value'] as int)]);
    }
    if (json['assetNetLimit'] != null) {
      assetNetLimit = Map.fromEntries([for (var a in json['assetNetLimit']) MapEntry(a['key'] as String, a['value'] as int)]);
    }
    totalNetLimit = json['TotalNetLimit'];
    totalNetWeight = json['TotalNetWeight'];
    tronPowerLimit = json['tronPowerLimit'];
    energyLimit = json['EnergyLimit'];
    totalEnergyLimit = json['TotalEnergyLimit'];
    totalEnergyWeight = json['TotalEnergyWeight'];
  }
}
