import { storage } from "../server/storage";
import { storageRU } from "../server/storage-ru";

export default async function handler(req: any, res: any) {
  const lang = req.query?.lang;
  const store = lang === "ru" ? storageRU : storage;
  const sc = await store.getStrengthConditioning();
  res.json(sc);
}
