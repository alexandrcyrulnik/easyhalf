import { storage } from "../server/storage";
import { storageRU } from "../server/storage-ru";
import { writeFileSync, mkdirSync } from "fs";
import { join } from "path";

async function main() {
  const outDir = join(process.cwd(), "client/public/data");
  mkdirSync(outDir, { recursive: true });

  for (const plan of ["1:30", "1:45", "2:00"] as const) {
    const slug = plan.replace(":", "-");
    writeFileSync(join(outDir, `plans-${slug}-en.json`), JSON.stringify(await storage.getPlan(plan)));
    writeFileSync(join(outDir, `plans-${slug}-ru.json`), JSON.stringify(await storageRU.getPlan(plan)));
  }

  writeFileSync(join(outDir, "guide-en.json"), JSON.stringify(await storage.getGuide()));
  writeFileSync(join(outDir, "guide-ru.json"), JSON.stringify(await storageRU.getGuide()));
  writeFileSync(join(outDir, "sc-en.json"), JSON.stringify(await storage.getStrengthConditioning()));
  writeFileSync(join(outDir, "sc-ru.json"), JSON.stringify(await storageRU.getStrengthConditioning()));

  console.log("✓ Static data files generated in client/public/data/");
}

main().catch((err) => { console.error(err); process.exit(1); });
