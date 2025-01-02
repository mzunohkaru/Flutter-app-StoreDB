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
			const rank = index + 1;
			const props: PropUpsertRanking = {
				country,
				genreId,
			};
			const ranking: ResponseAppStoreRanking & { rank: number } = {
				...app,
				rank,
			};
			await upsertRanking(ranking, props);
		},
		array: ranking,
	});
}
