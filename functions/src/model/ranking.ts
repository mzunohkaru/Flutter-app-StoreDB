export type ResponseAppStoreRanking = {
	appName: string;
	appId: number;
};

export type RequestAppStoreRanking = {
	country: string;
	genreId: number;
	limit: number;
};
