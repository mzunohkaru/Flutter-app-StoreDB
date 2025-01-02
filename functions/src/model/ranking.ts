export type ResponseAppStoreRanking = {
	appName: string;
	appId: number;
	appIcon: string;
};

export type RequestAppStoreRanking = {
	country: string;
	genreId: number;
	limit: number;
};
