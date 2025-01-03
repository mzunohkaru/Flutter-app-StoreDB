import { onSchedule } from "firebase-functions/scheduler";

import {
	CONSTANTS,
	ErrorMessage,
	MAX_INSTANCES,
	SCHEDULE,
} from "../../constant";
import { batchRanking, sendMessage } from "../../features";
import { APP_STORE_COUNTRY, APP_STORE_URL } from "../../config/app-store";

//* JP
//* Life Style

export const scheduleAM4 = onSchedule(
	{
		region: CONSTANTS.DEFAULT_REGION,
		schedule: SCHEDULE.am4,
		timeZone: CONSTANTS.DEFAULT_TIMEZONE,
		maxInstances: MAX_INSTANCES,
	},
	async () => {
		await batchRanking({
			country: APP_STORE_COUNTRY.jp,
			genreId: APP_STORE_URL.lifeStyle,
		}).catch((_) => {
			sendMessage(ErrorMessage(APP_STORE_COUNTRY.jp, APP_STORE_URL.lifeStyle));
		});
	},
);