import 'package:json_annotation/json_annotation.dart';

part 'param.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Param {
  final String dateFrom;
  final String dateTo;

  Param({required this.dateFrom, required this.dateTo});

  // Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Param.fromJson(Map<String, dynamic> json) => _$ParamFromJson(json);

  /// Connect the generated [_$ParamToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ParamToJson(this);
}
