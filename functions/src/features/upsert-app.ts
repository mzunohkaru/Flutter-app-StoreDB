import { db } from "../config/firebase";
import type { ResponseAppStoreRanking } from "../model/ranking";
import { FIRESTORE_PATH } from "../paths/firestore";

export type PropUpsertRanking = {
	country: string;
	genreId: number;
	appId: number;
};

export async function upsertApp(
	app: ResponseAppStoreRanking,
	props: PropUpsertRanking,
) {
	const { country, genreId, appId } = props;
	await db
		.doc(FIRESTORE_PATH.app(country, genreId, appId))
		.set(app, { merge: true })
		.catch((error) => {
			throw error;
		});
}
