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
//* Travel

export const scheduleAM5 = onSchedule(
	{
		region: CONSTANTS.DEFAULT_REGION,
		schedule: SCHEDULE.am5,
		timeZone: CONSTANTS.DEFAULT_TIMEZONE,
		maxInstances: MAX_INSTANCES,
	},
	async () => {
		await batchRanking({
			country: APP_STORE_COUNTRY.jp,
			genreId: APP_STORE_URL.travel,
		}).catch((_) => {
			sendMessage(ErrorMessage(APP_STORE_COUNTRY.jp, APP_STORE_URL.travel));
		});
	},
);
