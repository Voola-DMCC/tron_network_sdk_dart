import 'response_meta.dart';

class TGridAccountInfo {
  bool? success;
  TGridRespMeta? meta;
  int? latestOprationTime;
  TGridOwnerPermission? ownerPermission;
  List<FreeAssetNetUsageV2>? freeAssetNetUsageV2;
  AccountResource? accountResource;
  List<TGridActivePermission>? activePermission;
  Map<String, int>? assetV2;
  String? address;
  int? balance;
  int? createTime;
  Map<String, String>? trc20;
  int? latestConsumeFreeTime;

  TGridAccountInfo.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      var data = json['data'].first;

      latestOprationTime = data['latest_opration_time'];
      ownerPermission = data['owner_permission'] != null ? TGridOwnerPermission.fromJson(data['owner_permission']) : null;
      if (data['free_asset_net_usageV2'] != null) {
        freeAssetNetUsageV2 = <FreeAssetNetUsageV2>[];
        data['free_asset_net_usageV2'].forEach((v) {
          freeAssetNetUsageV2!.add(FreeAssetNetUsageV2.fromJson(v));
        });
      }
      accountResource = data['account_resource'] != null ? AccountResource.fromJson(data['account_resource']) : null;
      if (data['active_permission'] != null) {
        activePermission = <TGridActivePermission>[];
        data['active_permission'].forEach((v) {
          activePermission!.add(TGridActivePermission.fromJson(v));
        });
      }
      if (data['assetV2'] != null) assetV2 = Map.fromEntries([for (var a in data['assetV2']) MapEntry(a['key'] as String, a['value'] as int)]);

      address = data['address'];
      balance = data['balance'];
      createTime = data['create_time'];

      if (data['trc20'] != null) {
        trc20 = Map.fromEntries([
          for (var t in data['trc20'])
            () {
              var tt = t.entries.first;
              return MapEntry(tt.key as String, tt.value as String);
            }()
        ]);
      }

      latestConsumeFreeTime = data['latest_consume_free_time'];
    }
    success = json['success'];
    meta = json['meta'] != null ? TGridRespMeta.fromJson(json['meta']) : null;
  }
}

class TGridOwnerPermission {
  List<TGridPermissionKeys>? keys;
  int? threshold;
  String? permissionName;

  TGridOwnerPermission({this.keys, this.threshold, this.permissionName});

  TGridOwnerPermission.fromJson(Map<String, dynamic> json) {
    if (json['keys'] != null) {
      keys = <TGridPermissionKeys>[];
      json['keys'].forEach((v) {
        keys!.add(TGridPermissionKeys.fromJson(v));
      });
    }
    threshold = json['threshold'];
    permissionName = json['permission_name'];
  }
}

class TGridPermissionKeys {
  String? address;
  int? weight;

  TGridPermissionKeys({this.address, this.weight});

  TGridPermissionKeys.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    weight = json['weight'];
  }
}

class FreeAssetNetUsageV2 {
  int? value;
  String? key;

  FreeAssetNetUsageV2({this.value, this.key});

  FreeAssetNetUsageV2.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    key = json['key'];
  }
}

class AccountResource {
  int? latestConsumeTimeForEnergy;

  AccountResource({this.latestConsumeTimeForEnergy});

  AccountResource.fromJson(Map<String, dynamic> json) {
    latestConsumeTimeForEnergy = json['latest_consume_time_for_energy'];
  }
}

class TGridActivePermission {
  String? operations;
  List<TGridPermissionKeys>? keys;
  int? threshold;
  int? id;
  String? type;
  String? permissionName;

  TGridActivePermission({this.operations, this.keys, this.threshold, this.id, this.type, this.permissionName});

  TGridActivePermission.fromJson(Map<String, dynamic> json) {
    operations = json['operations'];
    if (json['keys'] != null) {
      keys = <TGridPermissionKeys>[];
      json['keys'].forEach((v) {
        keys!.add(TGridPermissionKeys.fromJson(v));
      });
    }
    threshold = json['threshold'];
    id = json['id'];
    type = json['type'];
    permissionName = json['permission_name'];
  }
}
