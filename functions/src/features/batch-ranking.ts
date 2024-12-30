import { logger } from "firebase-functions";
import { MAX_LIMIT } from "../constant";
import type { ResponseAppStoreRanking } from "../model/ranking";
import { handleBatchOperation } from "../utils/chunk";
import { getAppStoreRanking } from "./get-app-store";
import { type PropUpsertRanking, upsertRanking } from "./upsert-ranking";

type Props = {
	country: string;
	genreId: number;
};

export async function batchRanking(props: Props) {
	try {
		const { country, genreId } = props;

		const ranking = await getAppStoreRanking({
			country,
			genreId,
			limit: MAX_LIMIT,
		});

		if (ranking === undefined) {
			throw new Error(
				`国:${country} ジャンル:${genreId} - ランキング取得に失敗しました`,
			);
		}

		await handleBatchOperation<ResponseAppStoreRanking>({
			description: `国:${country} ジャンル:${genreId} - ランキング取得`,
			operation: async (app, index) => {
				const props: PropUpsertRanking = {
					country,
					genreId,
					rank: index + 1,
				};
				await upsertRanking(app, props);
			},
			array: ranking,
		});
		logger.info(`国:${country} ジャンル:${genreId} - ランキング取得完了`);
	} catch (error) {
		logger.error("Error: ", error);
	}
}
