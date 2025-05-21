import { onSchedule } from "firebase-functions/scheduler";

import {
	CONSTANTS,
	ErrorMessage,
	MAX_INSTANCES,
	SCHEDULE,
} from "../../constant";
import { batchRanking, sendMessage } from "../../features";
import { APP_STORE_COUNTRY, APP_STORE_GENRE } from "../../config/app-store";
import { logger } from "firebase-functions";

//* CHINA
//* Social Networking

export const scheduleAM1 = onSchedule(
	{
		region: CONSTANTS.DEFAULT_REGION,
		schedule: SCHEDULE.am1,
		timeZone: CONSTANTS.DEFAULT_TIMEZONE,
		maxInstances: MAX_INSTANCES,
	},
	async () => {
		await batchRanking({
			country: APP_STORE_COUNTRY.china,
			genreId: APP_STORE_GENRE.socialNetworking,
		})
			.then((_) => {
				sendMessage("ランキング取得完了");
			})
			.catch((e) => {
				logger.error(e);
				sendMessage(
					ErrorMessage(
						APP_STORE_COUNTRY.china,
						APP_STORE_GENRE.socialNetworking,
					),
				);
			});
	},
);
