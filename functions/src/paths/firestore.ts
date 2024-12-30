import type { Timestamp } from "firebase-admin/firestore";

export const FIRESTORE_PATH = {
	ranking: (
		country: string,
		genreId: number,
		id: number,
		createdAt: Timestamp,
		rank: number,
	) =>
		`${country}/${VersionConstant.v1}/${genreId}/${VersionConstant.v1}/${id}/${VersionConstant.v1}/${createdAt}/${rank}`,
};

export const VersionConstant = {
	v1: "v1",
	v2: "v2",
} as const;
