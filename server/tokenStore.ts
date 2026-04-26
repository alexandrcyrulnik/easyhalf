import { readFile, writeFile, mkdir } from "fs/promises";
import path from "path";
import type { PlanType } from "@shared/schema";

export interface CustomerTokenRow {
  token: string;
  planType: PlanType;
  used: boolean;
  createdAt: string;
  usedAt: string | null;
}

const DATA_DIR = path.join(process.cwd(), "data");
const TOKENS_FILE = path.join(DATA_DIR, "customer-tokens.json");

async function ensureDataDir(): Promise<void> {
  try {
    await mkdir(DATA_DIR, { recursive: true });
  } catch {
    // ignore
  }
}

async function readTokens(): Promise<CustomerTokenRow[]> {
  await ensureDataDir();
  try {
    const raw = await readFile(TOKENS_FILE, "utf-8");
    const data = JSON.parse(raw);
    return Array.isArray(data) ? data : [];
  } catch {
    return [];
  }
}

async function writeTokens(tokens: CustomerTokenRow[]): Promise<void> {
  await ensureDataDir();
  await writeFile(TOKENS_FILE, JSON.stringify(tokens, null, 2), "utf-8");
}

export async function insertToken(token: string, planType: PlanType): Promise<void> {
  const tokens = await readTokens();
  tokens.push({
    token,
    planType,
    used: false,
    createdAt: new Date().toISOString(),
    usedAt: null,
  });
  await writeTokens(tokens);
}

export async function listTokens(): Promise<CustomerTokenRow[]> {
  const tokens = await readTokens();
  return tokens.sort(
    (a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime()
  );
}

export async function findToken(tokenValue: string): Promise<CustomerTokenRow | null> {
  const tokens = await readTokens();
  return tokens.find((t) => t.token === tokenValue) ?? null;
}

export async function markTokenUsed(tokenValue: string): Promise<void> {
  const tokens = await readTokens();
  const row = tokens.find((t) => t.token === tokenValue);
  if (row && !row.used) {
    row.used = true;
    row.usedAt = new Date().toISOString();
    await writeTokens(tokens);
  }
}

export async function deleteToken(tokenValue: string): Promise<void> {
  const tokens = await readTokens();
  const filtered = tokens.filter((t) => t.token !== tokenValue);
  if (filtered.length !== tokens.length) {
    await writeTokens(filtered);
  }
}
