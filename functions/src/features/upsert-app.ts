import { db } from "../config/firebase";
import { AppData } from "../model/app-data";
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
	const appData: AppData = {
		appName: app.appName,
		appIcon: app.appIcon,
	};
	await db
		.doc(FIRESTORE_PATH.app(country, genreId, appId))
		.set(appData, { merge: true })
		.catch((error) => {
			throw error;
		});
}
