import { z } from "zod";

export type PlanType = "1:30" | "1:45" | "2:00";

export interface Workout {
  id: string;
  week: number;
  day: string;
  type: string;
  description: string;
}

export interface WeekData {
  week: number;
  focus: string;
  workouts: Workout[];
}

export interface TrainingPlan {
  id: PlanType;
  name: string;
  goalTime: string;
  totalWeeks: number;
  weeks: WeekData[];
}

export interface IntroSection {
  id: string;
  section: string;
  icon?: string;
  type: string;
  detail: string;
  hrPercent?: string;
  videoUrl?: string;
  imageUrl?: string;
}

export interface IntroductionContent {
  sections: IntroSection[];
}

export const planTypeSchema = z.enum(["1:30", "1:45", "2:00"]);

export const workoutSchema = z.object({
  id: z.string(),
  week: z.number(),
  day: z.string(),
  type: z.string(),
  description: z.string(),
});

export const weekDataSchema = z.object({
  week: z.number(),
  focus: z.string(),
  workouts: z.array(workoutSchema),
});

export const trainingPlanSchema = z.object({
  id: planTypeSchema,
  name: z.string(),
  goalTime: z.string(),
  totalWeeks: z.number(),
  weeks: z.array(weekDataSchema),
});

export const introSectionSchema = z.object({
  id: z.string(),
  section: z.string(),
  icon: z.string().optional(),
  type: z.string(),
  detail: z.string(),
  hrPercent: z.string().optional(),
  videoUrl: z.string().optional(),
  imageUrl: z.string().optional(),
});

export const introductionContentSchema = z.object({
  sections: z.array(introSectionSchema),
});
