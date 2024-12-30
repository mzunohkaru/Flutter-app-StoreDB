import { onSchedule } from "firebase-functions/scheduler";

import { CONSTANTS, MAX_INSTANCES, SCHEDULE } from "../../constant";
import {  jpSocialNetworking } from "../../features";

export const scheduleAM9 = onSchedule(
	{
		region: CONSTANTS.DEFAULT_REGION,
		schedule: SCHEDULE.am9,
		timeZone: CONSTANTS.DEFAULT_TIMEZONE,
		maxInstances: MAX_INSTANCES,
	},
	async () => {
		jpSocialNetworking();
	},
);
