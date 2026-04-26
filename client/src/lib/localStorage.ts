import type { PlanType } from "@shared/schema";

const SELECTED_PLAN_KEY = "easyhalf_selected_plan";
const COMPLETED_WORKOUTS_KEY = "easyhalf_completed_workouts";
const DISTANCE_UNIT_KEY = "easyhalf_distance_unit";
const LANGUAGE_KEY = "easyhalf_language";

export type DistanceUnit = "km" | "miles";
export type Language = "en" | "ru";

export function getLanguage(): Language {
  if (typeof window === "undefined") return "en";
  const stored = localStorage.getItem(LANGUAGE_KEY);
  if (stored === "en" || stored === "ru") return stored;
  return "en";
}

export function setLanguage(lang: Language): void {
  localStorage.setItem(LANGUAGE_KEY, lang);
}

export function getDistanceUnit(): DistanceUnit {
  if (typeof window === "undefined") return "km";
  const stored = localStorage.getItem(DISTANCE_UNIT_KEY);
  if (stored === "km" || stored === "miles") {
    return stored;
  }
  return "km";
}

export function setDistanceUnit(unit: DistanceUnit): void {
  localStorage.setItem(DISTANCE_UNIT_KEY, unit);
}

export function getSelectedPlan(): PlanType | null {
  if (typeof window === "undefined") return null;
  const stored = localStorage.getItem(SELECTED_PLAN_KEY);
  if (stored === "1:30" || stored === "1:45" || stored === "2:00") {
    return stored;
  }
  return null;
}

export function setSelectedPlan(plan: PlanType): void {
  localStorage.setItem(SELECTED_PLAN_KEY, plan);
}

export function clearSelectedPlan(): void {
  localStorage.removeItem(SELECTED_PLAN_KEY);
  localStorage.removeItem(COMPLETED_WORKOUTS_KEY);
}

export function getCompletedWorkouts(): Set<string> {
  if (typeof window === "undefined") return new Set();
  const stored = localStorage.getItem(COMPLETED_WORKOUTS_KEY);
  if (stored) {
    try {
      const parsed = JSON.parse(stored);
      return new Set(parsed);
    } catch {
      return new Set();
    }
  }
  return new Set();
}

export function toggleWorkoutComplete(workoutId: string): Set<string> {
  const completed = getCompletedWorkouts();
  if (completed.has(workoutId)) {
    completed.delete(workoutId);
  } else {
    completed.add(workoutId);
  }
  localStorage.setItem(COMPLETED_WORKOUTS_KEY, JSON.stringify(Array.from(completed)));
  return completed;
}

export function isWorkoutComplete(workoutId: string): boolean {
  return getCompletedWorkouts().has(workoutId);
}
