export const CONSTANTS = {
	APP_NAME: "AppStoreDB",
	DEFAULT_REGION: "asia-northeast1",
	DEFAULT_TIMEZONE: "Asia/Tokyo",
} as const;

export const MAX_INSTANCES = 1;
export const MAX_BATCH_SIZE = 500;
export const MAX_LIMIT = 200;

export const FUNCTIONS = {
	scheduleAM1: "scheduleAM1",
	scheduleAM2: "scheduleAM2",
	scheduleAM3: "scheduleAM3",
	schedulePM1: "schedulePM1",
} as const;

export const SCHEDULE = {
	am1: "0 1 * * *",
	am2: "0 2 * * *",
	am3: "0 3 * * *",
	pm1: "0 12 * * *",
} as const;
