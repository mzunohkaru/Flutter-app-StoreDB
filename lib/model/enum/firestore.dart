enum Country {
  jp,
  en,
}

enum Genre {
  business,
  socialNetworking,
	healthAndFitness,
	lifeStyle,
  travel,
}

extension GenreExtension on Genre {
  int get code => {
    Genre.business: 6000,
    Genre.socialNetworking: 6005,
    Genre.healthAndFitness: 6013,
    Genre.lifeStyle: 6012,
    Genre.travel: 6003,
  }[this]!;

  String get title => {
    Genre.business: 'ビジネス',
    Genre.socialNetworking: 'ソーシャルネットワーキング',
    Genre.healthAndFitness: 'ヘルス＆フィットネス',
    Genre.lifeStyle: 'ライフスタイル',
    Genre.travel: 'トラベル',
  }[this]!;
}

enum Version {
  v1,
  v2,
}
