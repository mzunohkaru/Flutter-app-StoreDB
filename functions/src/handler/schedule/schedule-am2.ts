import { onSchedule } from "firebase-functions/scheduler";

import { CONSTANTS, MAX_INSTANCES, SCHEDULE } from "../../constant";
import { batchRanking } from "../../features";
import { APP_STORE_COUNTRY, APP_STORE_URL } from "../../config/app-store";

//* JP
//* Business

export const scheduleAM2 = onSchedule(
	{
		region: CONSTANTS.DEFAULT_REGION,
		schedule: SCHEDULE.am2,
		timeZone: CONSTANTS.DEFAULT_TIMEZONE,
		maxInstances: MAX_INSTANCES,
	},
	async () => {
		await batchRanking({
			country: APP_STORE_COUNTRY.jp,
			genreId: APP_STORE_URL.business,
		});
	},
);