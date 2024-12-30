import { onSchedule } from "firebase-functions/scheduler";

import { CONSTANTS, MAX_INSTANCES, SCHEDULE } from "../../constant";
import { batchRanking } from "../../features";
import { APP_STORE_COUNTRY, APP_STORE_URL } from "../../config/app-store";

//* USA
//* Social Networking

export const schedulePM1 = onSchedule(
	{
		region: CONSTANTS.DEFAULT_REGION,
		schedule: SCHEDULE.pm1,
		timeZone: CONSTANTS.DEFAULT_TIMEZONE,
		maxInstances: MAX_INSTANCES,
	},
	async () => {
		await batchRanking({
			country: APP_STORE_COUNTRY.us,
			genreId: APP_STORE_URL.socialNetworking,
		});
	},
);
