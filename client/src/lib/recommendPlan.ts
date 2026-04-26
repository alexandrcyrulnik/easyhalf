export interface PlanAnswers {
  experience: string;
  weekly_distance: string;
  current_pace: string;
  longest_run: string;
  goal: string;
}

export interface PlanRecommendation {
  level: string;
  plan: string;
  scores: { A: number; B: number; C: number };
  calculationType: "Automatic" | "Manual";
}

type SingleColumn = "A" | "B" | "C";

function getAnswerColumn(category: string, value: string): SingleColumn | null {
  const v = value.toLowerCase();

  if (category === "experience") {
    if (v.includes("< 6 months") || v.includes("less than 6 months")) return "A";
    if (v.includes("1–2 years") || v.includes("1-2 years")) return "B";
    if (v.includes("2+ years")) return "C";
    return null;
  }

  if (category === "distance") {
    if (v.includes("up to 10 km") || v.includes("up to 10")) return "A";
    if (v.includes("20–40 km") || v.includes("20-40")) return "B";
    if (v.includes("40+ km") || v.includes("40+")) return "C";
    return null;
  }

  if (category === "pace") {
    if (v.includes("slower than 6:30")) return "A";
    if (v.includes("4:30–5:30") || v.includes("4:30-5:30")) return "B";
    if (v.includes("faster than 4:30")) return "C";
    return null;
  }

  if (category === "longest_run") {
    if (v.startsWith("5 km") || v === "5 km") return "A";
    if (v.startsWith("15 km") || v === "15 km") return "B";
    if (v.startsWith("20+ km") || v.startsWith("20+")) return "C";
    return null;
  }

  if (category === "goal") {
    if (v.includes("just finish")) return "A";
    return null;
  }

  return null;
}

function determineCalculationType(answers: PlanAnswers): "Automatic" | "Manual" {
  const columns = [
    getAnswerColumn("experience", answers.experience),
    getAnswerColumn("distance", answers.weekly_distance),
    getAnswerColumn("pace", answers.current_pace),
    getAnswerColumn("longest_run", answers.longest_run),
    getAnswerColumn("goal", answers.goal),
  ];

  const validColumns = columns.filter((c) => c !== null) as SingleColumn[];

  if (validColumns.length < 5) {
    return "Manual";
  }

  const firstColumn = validColumns[0];
  const allSameColumn = validColumns.every((c) => c === firstColumn);

  return allSameColumn ? "Automatic" : "Manual";
}

export function recommendPlan(answers: PlanAnswers): PlanRecommendation {
  const { experience, weekly_distance, current_pace, longest_run, goal } = answers;

  let scoreA = 0;
  let scoreB = 0;
  let scoreC = 0;

  const eq = (a: string | undefined, b: string) => String(a || "").trim() === b;

  if (eq(experience, "< 6 months")) {
    scoreA += 2;
  } else if (eq(experience, "6–12 months")) {
    scoreA += 1;
    scoreB += 1;
  } else if (eq(experience, "1–2 years")) {
    scoreB += 1;
    scoreC += 1;
  } else if (eq(experience, "2+ years")) {
    scoreC += 2;
  }

  if (eq(weekly_distance, "Up to 10 km") || weekly_distance?.startsWith("Up to 10 km")) {
    scoreA += 2;
  } else if (eq(weekly_distance, "10–20 km") || weekly_distance?.startsWith("10–20 km")) {
    scoreA += 1;
    scoreB += 1;
  } else if (eq(weekly_distance, "20–40 km") || weekly_distance?.startsWith("20–40 km")) {
    scoreB += 1;
    scoreC += 1;
  } else if (eq(weekly_distance, "40+ km") || weekly_distance?.startsWith("40+ km")) {
    scoreC += 2;
  }

  if (eq(current_pace, "Slower than 6:30 / km") || current_pace?.startsWith("Slower than 6:30")) {
    scoreA += 2;
  } else if (eq(current_pace, "5:30–6:30 / km") || current_pace?.startsWith("5:30–6:30")) {
    scoreA += 1;
    scoreB += 1;
  } else if (eq(current_pace, "4:30–5:30 / km") || current_pace?.startsWith("4:30–5:30")) {
    scoreB += 1;
    scoreC += 1;
  } else if (eq(current_pace, "Faster than 4:30 / km") || current_pace?.startsWith("Faster than 4:30")) {
    scoreC += 2;
  }

  if (eq(longest_run, "5 km") || longest_run?.startsWith("5 km")) {
    scoreA += 2;
  } else if (eq(longest_run, "10 km") || longest_run?.startsWith("10 km")) {
    scoreA += 1;
    scoreB += 1;
  } else if (eq(longest_run, "15 km") || longest_run?.startsWith("15 km")) {
    scoreB += 1;
    scoreC += 1;
  } else if (eq(longest_run, "20+ km") || longest_run?.startsWith("20+ km")) {
    scoreC += 2;
  }

  let level: string | null = null;

  const maxScore = Math.max(scoreA, scoreB, scoreC);
  const topLevels: string[] = [];
  if (scoreA === maxScore) topLevels.push("A");
  if (scoreB === maxScore) topLevels.push("B");
  if (scoreC === maxScore) topLevels.push("C");

  const goalIs145or130 =
    goal === "Finish around 1:45 hours" ||
    goal === "Finish around 1:30 hours" ||
    goal === "~1:45 hours" ||
    goal === "~1:30 hours";
  const goalIs130 = goal === "Finish around 1:30 hours" || goal === "~1:30 hours";
  const goalIs145 = goal === "Finish around 1:45 hours" || goal === "~1:45 hours";

  if (topLevels.length === 1) {
    level = topLevels[0];
  } else {
    if (topLevels.includes("A") && topLevels.includes("B") && !topLevels.includes("C")) {
      level = goalIs145or130 ? "B" : "A";
    } else if (topLevels.includes("B") && topLevels.includes("C") && !topLevels.includes("A")) {
      level = goalIs130 ? "C" : "B";
    } else {
      if (goalIs130) level = "C";
      else if (goalIs145) level = "B";
      else level = "A";
    }
  }

  let plan: string | null = null;

  if (level === "A") {
    plan = "2:00";
  } else if (level === "B") {
    plan = goalIs145or130 ? "1:45" : "2:00";
  } else if (level === "C") {
    plan = goalIs130 ? "1:30" : "1:45";
  }

  const calculationType = determineCalculationType(answers);

  return {
    level: level || "A",
    plan: plan || "2:00",
    scores: { A: scoreA, B: scoreB, C: scoreC },
    calculationType,
  };
}
