enum CalenderType {
  c2w,
  c1m,
  c6m,
  c1y,
  c5y,
}

extension CalenderTypeExtension on CalenderType {
  String get title => {
    CalenderType.c2w: '2週間',
    CalenderType.c1m: '1ヶ月',
    CalenderType.c6m: '6ヶ月',
    CalenderType.c1y: '1年',
    CalenderType.c5y: '5年',
  }[this]!;
}
