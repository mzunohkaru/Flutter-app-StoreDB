export const FIRESTORE_PATH = {
	ranking: (
		country: string,
		genreId: number,
		appId: number,
		createdAt: string,
	) =>
		`${country}/${VersionConstant.v1}/${genreId}/${VersionConstant.v1}/${appId}/${createdAt}`,
};

export const VersionConstant = {
	v1: "v1",
	v2: "v2",
} as const;
