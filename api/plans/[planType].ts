import { storage } from "../../server/storage";
import { storageRU } from "../../server/storage-ru";

const VALID_PLANS = ["1:30", "1:45", "2:00"] as const;
type PlanType = typeof VALID_PLANS[number];

export default async function handler(req: any, res: any) {
  const planType = req.query?.planType as string;
  if (!VALID_PLANS.includes(planType as PlanType)) {
    return res.status(400).json({ error: "Invalid plan type" });
  }
  const store = req.query?.lang === "ru" ? storageRU : storage;
  const plan = await store.getPlan(planType as PlanType);
  if (!plan) {
    return res.status(404).json({ error: "Plan not found" });
  }
  res.json(plan);
}
