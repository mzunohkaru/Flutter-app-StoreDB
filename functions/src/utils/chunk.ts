import { logger } from "firebase-functions/v2";
import { MAX_BATCH_SIZE } from "../constant";
import { batch } from "../config/firebase";

type PropHandleBatchOperation<T> = {
	description: string;
	operation: (item: T, index: number) => Promise<void>;
	array: T[];
};

export const handleBatchOperation = async <T>({
	description,
	operation,
	array,
}: PropHandleBatchOperation<T>) => {
	const chunkedDocs = _chunk(array, MAX_BATCH_SIZE);

	await Promise.all(
		chunkedDocs.map(async (chunk) => {
			await Promise.all(
				chunk.map(async (item, index) => {
					try {
						await operation(item, index);
					} catch (_error) {
						console.error(_error);
					}
				}),
			);
			try {
				await batch.commit();
			} catch (error) {
				logger.error(`${description} batch commit failed:`, error);
			}
		}),
	);
};

function _chunk<T>(array: T[], size: number): T[][] {
	return array.reduce<T[][]>((newArr, _, i) => {
		if (i % size === 0) {
			newArr.push(array.slice(i, i + size) as T[]);
		}
		return newArr;
	}, []);
}
