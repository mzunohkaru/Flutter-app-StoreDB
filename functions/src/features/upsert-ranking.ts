import { db } from "../config/firebase";
import { FIRESTORE_PATH } from "../paths/firestore";

export type PropUpsertRanking = {
	country: string;
	genreId: number;
	appId: number;
};

export async function upsertRanking(rank: number, props: PropUpsertRanking) {
	const { country, genreId, appId } = props;
	const createdAt = new Date().toISOString().slice(0, 10).replace(/-/g, "");
	await db
		.doc(FIRESTORE_PATH.ranking(country, genreId, appId, createdAt))
		.set(
			{
				rank,
			},
			{ merge: true },
		)
		.catch((error) => {
			throw error;
		});
}
