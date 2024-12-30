import { FUNCTIONS } from "./constant";
import * as handler from "./handler";

if (
	!process.env.FUNCTION_TARGET ||
	process.env.FUNCTION_TARGET === FUNCTIONS.scheduleAM9
) {
	exports.scheduleAM9 = handler.scheduleAM9;
}
