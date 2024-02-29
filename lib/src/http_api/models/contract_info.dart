class ContractInfoResp {
  String? bytecode;
  int? consumeUserResourcePercent;
  String? name;
  String? originAddress;
  Map<String, dynamic>? abi;
  int? originEnergyLimit;
  String? contractAddress;
  String? codeHash;

  ContractInfoResp(
      {this.bytecode,
      this.consumeUserResourcePercent,
      this.name,
      this.originAddress,
      this.abi,
      this.originEnergyLimit,
      this.contractAddress,
      this.codeHash});

  ContractInfoResp.fromJson(Map<String, dynamic> json) {
    bytecode = json['bytecode'];
    consumeUserResourcePercent = json['consume_user_resource_percent'];
    name = json['name'];
    originAddress = json['origin_address'];
    abi = json['abi'];
    originEnergyLimit = json['origin_energy_limit'];
    contractAddress = json['contract_address'];
    codeHash = json['code_hash'];
  }
}
