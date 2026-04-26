import type { Express } from "express";
import { createServer, type Server } from "http";
import express from "express";
import path from "path";
import { storage } from "./storage";
import { storageRU } from "./storage-ru";
import { planTypeSchema } from "@shared/schema";

export async function registerRoutes(
  httpServer: Server,
  app: Express
): Promise<Server> {
  app.use(
    "/exercise-images",
    express.static(path.join(process.cwd(), "public/exercise-images"))
  );

  app.get("/api/plans/:planType", async (req, res) => {
    try {
      const result = planTypeSchema.safeParse(req.params.planType);
      if (!result.success) {
        return res.status(400).json({ error: "Invalid plan type" });
      }
      const store = req.query.lang === "ru" ? storageRU : storage;
      const plan = await store.getPlan(result.data);
      if (!plan) {
        return res.status(404).json({ error: "Plan not found" });
      }
      return res.json(plan);
    } catch (error) {
      return res.status(500).json({ error: "Internal server error" });
    }
  });

  app.get("/api/guide", async (req, res) => {
    try {
      const store = req.query.lang === "ru" ? storageRU : storage;
      const guide = await store.getGuide();
      return res.json(guide);
    } catch (error) {
      return res.status(500).json({ error: "Internal server error" });
    }
  });

  app.get("/api/strength-conditioning", async (req, res) => {
    try {
      const store = req.query.lang === "ru" ? storageRU : storage;
      const sc = await store.getStrengthConditioning();
      return res.json(sc);
    } catch (error) {
      return res.status(500).json({ error: "Internal server error" });
    }
  });

  return httpServer;
}
