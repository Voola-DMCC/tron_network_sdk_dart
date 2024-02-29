class AccountResp {
  String? accountName;
  String? type;
  String? address;
  int? balance;
  List<Vote>? votes;
  Map<String, int>? asset;
  Map<String, int>? assetV2;
  List<Frozen>? frozen;
  int? netUsage;
  int? acquiredDelegatedFrozenBalanceForEnergy;
  int? delegatedFrozenBalanceForEnergy;
  int? createTime;
  int? latestOprationTime;
  int? allowance;
  int? latestWithdrawTime;
  List<Frozen>? frozenSupply;
  String? assetIssuedName;
  String? assetIssuedID;
  Map<String, int>? latestAssetOperationTime;
  Map<String, int>? latestAssetOperationTimeV2;
  int? freeNetUsage;
  Map<String, int>? freeAssetNetUsage;
  Map<String, int>? freeAssetNetUsageV2;
  int? latestConsumeTime;
  int? latestConsumeFreeTime;
  String? accountId;
  AccountResource? accountResource;
  String? codeHash;
  Permission? ownerPermission;
  Permission? witnessPermission;
  List<Permission>? activePermission;

  AccountResp();

  AccountResp.fromJson(Map<String, dynamic> json) {
    accountName = json['account_name'];
    type = json['type'];
    address = json['address'];
    balance = json['balance'];
    if (json['votes'] != null) votes = [for (var i in json['votes']) Vote.fromJson(i)];
    if (json['asset'] != null) asset = Map.fromEntries([for (var a in json['asset']) MapEntry(a['key'] as String, a['value'] as int)]);
    if (json['assetV2'] != null) assetV2 = Map.fromEntries([for (var a in json['assetV2']) MapEntry(a['key'] as String, a['value'] as int)]);
    if (json['frozen'] != null) frozen = [for (var i in json['frozen']) Frozen.fromJson(i)];
    netUsage = json['net_usage'];
    acquiredDelegatedFrozenBalanceForEnergy = json['acquired_delegated_frozen_balance_for_bandwidth'];
    delegatedFrozenBalanceForEnergy = json['delegated_frozen_balance_for_bandwidth'];
    createTime = json['create_time'];
    latestOprationTime = json['latest_opration_time'];
    allowance = json['allowance'];
    latestWithdrawTime = json['latestWithdrawTime'];
    if (json['frozen_supply'] != null) frozenSupply = [for (var i in json['frozen_supply']) Frozen.fromJson(i)];
    assetIssuedName = json['asset_issued_name'];
    assetIssuedID = json['asset_issued_ID'];
    if (json['latest_asset_operation_time'] != null) {
      latestAssetOperationTime =
          Map.fromEntries([for (var a in json['latest_asset_operation_time']) MapEntry(a['key'] as String, a['value'] as int)]);
    }
    if (json['latest_asset_operation_timeV2'] != null) {
      latestAssetOperationTimeV2 =
          Map.fromEntries([for (var a in json['latest_asset_operation_timeV2']) MapEntry(a['key'] as String, a['value'] as int)]);
    }
    freeNetUsage = json['free_net_usage'];
    if (json['free_asset_net_usage'] != null) {
      freeAssetNetUsage = Map.fromEntries([for (var a in json['free_asset_net_usage']) MapEntry(a['key'] as String, a['value'] as int)]);
    }
    if (json['free_asset_net_usageV2'] != null) {
      freeAssetNetUsageV2 = Map.fromEntries([for (var a in json['free_asset_net_usageV2']) MapEntry(a['key'] as String, a['value'] as int)]);
    }
    latestConsumeTime = json['latest_consume_time'];
    latestConsumeFreeTime = json['latest_consume_free_time'];
    accountId = json['account_id'];
    if (json['account_resource'] != null) accountResource = AccountResource.fromJson(json['account_resource']);
    codeHash = json['codeHash'];
    if (json['owner_permission'] != null) ownerPermission = Permission.fromJson(json['owner_permission']);
    if (json['witness_permission'] != null) witnessPermission = Permission.fromJson(json['witness_permission']);
    if (json['active_permission'] != null) activePermission = [for (var i in json['active_permission']) Permission.fromJson(i)];
  }
}

class AccountResource {
  int? latestConsumeTimeForEnergy;
  int? energyUsage;
  int? acquiredDelegatedFrozenBalanceForEnergy;
  int? delegatedFrozenBalanceForEnergy;
  int? storageLimit;
  int? storageUsage;
  int? latestExchangeStorageTime;

  AccountResource({this.latestConsumeTimeForEnergy});

  AccountResource.fromJson(Map<String, dynamic> json) {
    latestConsumeTimeForEnergy = json['latest_consume_time_for_energy'];
  }
}

class Frozen {
  int? frozenBalance;
  int? expireTime;
  Frozen(this.frozenBalance, this.expireTime);
  Frozen.fromJson(Map<String, dynamic> json) {
    frozenBalance = json['frozen_balance'];
    expireTime = json['expire_time'];
  }
}

class Vote {
  String? voteAddress;
  int? voteCount;

  Vote(this.voteAddress, this.voteCount);

  Vote.fromJson(Map<String, dynamic> json) {
    voteAddress = json['vote_address'];
    voteCount = json['vote_count'];
  }
}

class Permission {
  String? type;
  int? id;
  String? permissionName;
  int? threshold;
  int? parentID;
  String? operations;
  List<Key>? keys;

  Permission();

  Permission.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    permissionName = json['permission_name'];
    threshold = json['threshold'];
    parentID = json['parent_id'];
    operations = json['operations'];
    if (json['keys'] != null) keys = [for (var i in json['keys']) Key.fromJson(i)];
  }
}

class Key {
  String? address;
  int? weight;
  Key(this.address, this.weight);
  Key.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    weight = json['weight'];
  }
}
