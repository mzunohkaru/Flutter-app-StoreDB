import * as dotenv from "dotenv";

dotenv.config();

export const Env = {
	channelAccessToken: process.env.CHANNEL_ACCESS_TOKEN || "",
	channelSecret: process.env.CHANNEL_SECRET || "",
	userId: process.env.USER_ID || "",
} as const;
