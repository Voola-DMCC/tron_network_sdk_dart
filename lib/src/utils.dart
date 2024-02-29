import 'dart:math';

import 'package:decimal/decimal.dart';

BigInt valueToSun(Decimal value, int decimals) {
  return (value * Decimal.fromInt(pow(10, decimals).toInt())).toBigInt();
}

Decimal sunToDecimalValue(BigInt sunValue, int decimals) {
  return (Decimal.fromBigInt(sunValue) / Decimal.fromInt(pow(10, decimals).toInt())).toDecimal(scaleOnInfinitePrecision: decimals);
}
