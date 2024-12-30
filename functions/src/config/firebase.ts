import * as admin from "firebase-admin";

admin.initializeApp({
	credential: admin.credential.cert(require("../../serviceAccountKey.json")),
});

export const db = admin.firestore();
export const batch = db.batch();
