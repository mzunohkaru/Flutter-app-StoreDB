import type {
	RequestAppStoreRanking,
	ResponseAppStoreRanking,
} from "../model/ranking";

export async function getAppStoreRanking({
	country,
	genreId,
	limit,
}: RequestAppStoreRanking): Promise<ResponseAppStoreRanking[] | undefined> {
	const response = await fetch(
		`https://itunes.apple.com/${country}/rss/topfreeapplications/limit=${limit}/genre=${genreId}/json`,
	);
	const data = await response.json();

	return data.feed.entry.map((app: any) => {
		const res: ResponseAppStoreRanking = {
			appName: app.title.label,
			appId: app.id.attributes["im:id"],
			appIcon: app["im:image"][0].label,
		};

		return res;
	});
}
