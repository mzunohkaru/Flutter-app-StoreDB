enum Country {
  jp,
  en,
}

enum Genre {
  business,
  socialNetworking,
	healthAndFitness,
}

extension GenreExtension on Genre {
  int get code => {
    Genre.business: 6005,
    Genre.socialNetworking: 6005,
    Genre.healthAndFitness: 6012,
  }[this]!;

  String get title => {
    Genre.business: 'ビジネス',
    Genre.socialNetworking: 'ソーシャルネットワーキング',
    Genre.healthAndFitness: 'ヘルス＆フィットネス',
  }[this]!;
}

enum Version {
  v1,
  v2,
}
