import { Timestamp } from "firebase-admin/firestore";

import { db } from "../config/firebase";
import type { ResponseAppStoreRanking } from "../model/ranking";
import { FIRESTORE_PATH } from "../paths/firestore";

export type PropUpsertRanking = {
  country: string;
  genreId: number;
  rank: number;
};

export async function upsertRanking(
  ranking: ResponseAppStoreRanking,
  props: PropUpsertRanking
) {
  const { country, genreId, rank } = props;
  await db
    .doc(
      FIRESTORE_PATH.ranking(
        country,
        genreId,
        ranking.appId,
        Timestamp.now(),
        rank
      )
    )
    .set(ranking, { merge: true });
}
