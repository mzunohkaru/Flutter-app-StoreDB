import { FUNCTIONS } from "./constant";
import * as handler from "./handler";

if (
	!process.env.FUNCTION_TARGET ||
	process.env.FUNCTION_TARGET === FUNCTIONS.scheduleAM1
) {
	exports.scheduleAM1 = handler.scheduleAM1;
}

if (
	!process.env.FUNCTION_TARGET ||
	process.env.FUNCTION_TARGET === FUNCTIONS.scheduleAM2
) {
	exports.scheduleAM2 = handler.scheduleAM2;
}

if (
	!process.env.FUNCTION_TARGET ||
	process.env.FUNCTION_TARGET === FUNCTIONS.scheduleAM3
) {
	exports.scheduleAM3 = handler.scheduleAM3;
}

if (
	!process.env.FUNCTION_TARGET ||
	process.env.FUNCTION_TARGET === FUNCTIONS.scheduleAM4
) {
	exports.scheduleAM4 = handler.scheduleAM4;
}

if (
	!process.env.FUNCTION_TARGET ||
	process.env.FUNCTION_TARGET === FUNCTIONS.scheduleAM5
) {
	exports.scheduleAM5 = handler.scheduleAM5;
}
