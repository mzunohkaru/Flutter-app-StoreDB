export const FIRESTORE_PATH = {
	app: (country: string, genreId: number, appId: number) =>
		`${country}/${VersionConstant.v1}/${genreId}/${appId}`,
	ranking: (
		country: string,
		genreId: number,
		appId: number,
		createdAt: string,
	) =>
		`${country}/${VersionConstant.v1}/${genreId}/${appId}/ranking/${createdAt}`,
};

export const VersionConstant = {
	v1: "v1",
	v2: "v2",
} as const;
