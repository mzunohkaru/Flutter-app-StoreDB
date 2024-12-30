import { logger } from "firebase-functions";
import { APP_STORE_COUNTRY, APP_STORE_URL } from "../config/app-store";
import { MAX_LIMIT } from "../constant";
import type { ResponseAppStoreRanking } from "../model/ranking";
import { handleBatchOperation } from "../utils/chunk";
import { getAppStoreRanking } from "./get-app-store";
import { type PropUpsertRanking, upsertRanking } from "./upsert-ranking";

export async function jpSocialNetworking() {
  try {
    const ranking = await getAppStoreRanking({
      country: APP_STORE_COUNTRY.jp,
      genreId: APP_STORE_URL.socialNetworking,
      limit: MAX_LIMIT,
    });

    if (ranking === undefined) {
      throw new Error("ランキング取得に失敗しました");
    }

    await handleBatchOperation<ResponseAppStoreRanking>({
      description: "ランキング取得",
      operation: async (app, index) => {
        const props: PropUpsertRanking = {
          country: APP_STORE_COUNTRY.jp,
          genreId: APP_STORE_URL.socialNetworking,
          rank: index + 1,
        };
        await upsertRanking(app, props);
      },
      array: ranking,
    });
  } catch (error) {
    logger.error("Error: ", error);
  }
}
