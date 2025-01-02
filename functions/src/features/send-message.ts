import { TextMessage, messagingApi } from "@line/bot-sdk";
import { Env } from "../env";

const client = new messagingApi.MessagingApiClient({
	channelAccessToken: Env.channelAccessToken,
});

export async function sendMessage(message: string): Promise<void> {
	const response: TextMessage = {
		type: "text",
		text: message,
	};
	await client.pushMessage({
		to: Env.userId,
		messages: [response],
	});
}
