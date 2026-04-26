import type { TrainingPlan, IntroductionContent, PlanType, WeekData, IntroSection } from "@shared/schema";

export interface IStorage {
  getPlan(planType: PlanType): Promise<TrainingPlan | undefined>;
  getGuide(): Promise<IntroductionContent>;
  getStrengthConditioning(): Promise<IntroductionContent>;
}

function get145Plan(): WeekData[] {
  return [
    {
      week: 1,
      focus: "Build routine and aerobic foundation.",
      workouts: [
        { id: "w1d1", week: 1, day: "Tuesday", type: "S&C", description: "Easy 6 km + S&C (4 circuits, ideally no pauses between circuits):\nsquats 20,\ncalf raises 25/leg,\ncrunches 20." },
        { id: "w1d2", week: 1, day: "Wednesday", type: "Fartlek", description: "Fartlek 6 km — 3 min easy / 1 min @ 4:50–5:00." },
        { id: "w1d3", week: 1, day: "Friday", type: "Easy", description: "Easy 6 km + split jumps 2–3 min (continuous or in sets)." },
        { id: "w1d4", week: 1, day: "Sunday", type: "Long Run", description: "Long 12–14 km easy." },
      ],
    },
    {
      week: 2,
      focus: "Endurance + strength progression.",
      workouts: [
        { id: "w2d1", week: 2, day: "Tuesday", type: "S&C", description: "Easy 6 km + S&C (5 circuits, ideally no pauses between circuits):\nsquats 25,\ncalf raises 30/leg,\nstep-ups 30 s,\ncrunches 25." },
        { id: "w2d2", week: 2, day: "Wednesday", type: "Fartlek", description: "Fartlek 7 km — 3 min easy / 1.5 min @ 4:50." },
        { id: "w2d3", week: 2, day: "Friday", type: "Easy", description: "Easy 7 km + split jumps 3–4 min (continuous or in sets)." },
        { id: "w2d4", week: 2, day: "Sunday", type: "Long Run", description: "Long 14–16 km easy." },
      ],
    },
    {
      week: 3,
      focus: "Light load week; maintain rhythm.",
      workouts: [
        { id: "w3d1", week: 3, day: "Tuesday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w3d2", week: 3, day: "Wednesday", type: "Fartlek", description: "Fartlek 7 km — 4 min easy / 2 min @ 5:00." },
        { id: "w3d3", week: 3, day: "Friday", type: "Easy", description: "Easy 8–9 km + split jumps 4 min (continuous or in sets)." },
        { id: "w3d4", week: 3, day: "Sunday", type: "Easy", description: "Easy 10 km." },
      ],
    },
    {
      week: 4,
      focus: "Aerobic development and stability.",
      workouts: [
        { id: "w4d1", week: 4, day: "Tuesday", type: "S&C", description: "Easy 7 km + S&C (5 circuits):\nsquats 25, calf raises 30/leg,\nstep-ups 50 s,\ncrunches 25." },
        { id: "w4d2", week: 4, day: "Wednesday", type: "Variable", description: "Variable 9 km — 1 km easy / 1 km @ 4:40–4:50." },
        { id: "w4d3", week: 4, day: "Friday", type: "Easy", description: "Easy 8 km." },
        { id: "w4d4", week: 4, day: "Sunday", type: "Long Run", description: "Long 15–17 km easy." },
      ],
    },
    {
      week: 5,
      focus: "First interval phase.",
      workouts: [
        { id: "w5d1", week: 5, day: "Tuesday", type: "S&C", description: "Easy 6 km + S&C (5 circuits):\ncoordination 7/leg,\ncalf raises 30/leg,\nstep-ups 50 s,\ncrunches 25." },
        { id: "w5d2", week: 5, day: "Wednesday", type: "Intervals", description: "Intervals 7×1 km @ 4:35–4:50 (400 m resting jog)." },
        { id: "w5d3", week: 5, day: "Friday", type: "Easy", description: "Easy 8 km." },
        { id: "w5d4", week: 5, day: "Sunday", type: "Long Run", description: "Long 16–18 km easy." },
      ],
    },
    {
      week: 6,
      focus: "Benchmark + adaptation.",
      workouts: [
        { id: "w6d1", week: 6, day: "Tuesday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w6d2", week: 6, day: "Wednesday", type: "Fartlek", description: "Fartlek 7 km — 3 min easy / 1 min @ 5:00." },
        { id: "w6d3", week: 6, day: "Friday", type: "Easy", description: "Easy 6 km (recovery)." },
        { id: "w6d4", week: 6, day: "Sunday", type: "Tempo", description: "10 km test run — hard effort @ 4:40–4:55 min/km." },
      ],
    },
    {
      week: 7,
      focus: "Strength maintenance + intensity.",
      workouts: [
        { id: "w7d1", week: 7, day: "Tuesday", type: "Easy", description: "Easy 6 km (recovery)." },
        { id: "w7d2", week: 7, day: "Wednesday", type: "S&C", description: "S&C (5 circuits) — coordination 8/leg, calf raises 35/leg, step-ups 50 s, crunches 25." },
        { id: "w7d3", week: 7, day: "Friday", type: "Intervals", description: "Intervals 10×1 km @ 4:35–4:50 (400 m resting jog)." },
        { id: "w7d4", week: 7, day: "Sunday", type: "Long Run", description: "Long 16–18 km easy." },
      ],
    },
    {
      week: 8,
      focus: "High-volume aerobic block.",
      workouts: [
        { id: "w8d1", week: 8, day: "Tuesday", type: "Easy", description: "Easy 7 km + step-ups 5 min + 1 km jogging (resting)." },
        { id: "w8d2", week: 8, day: "Wednesday", type: "Intervals", description: "Intervals 4×2 km @ 4:40–4:50 (500 m resting jog)." },
        { id: "w8d3", week: 8, day: "Friday", type: "Easy", description: "Easy 8–10 km." },
        { id: "w8d4", week: 8, day: "Sunday", type: "Long Run", description: "Long 18–20 km easy." },
      ],
    },
    {
      week: 9,
      focus: "Peak endurance.",
      workouts: [
        { id: "w9d1", week: 9, day: "Tuesday", type: "Intervals", description: "Easy 7 km + 5×400 m @ 4:00 (400 m resting jog)." },
        { id: "w9d2", week: 9, day: "Wednesday", type: "Easy", description: "Easy 6 km (recovery)." },
        { id: "w9d3", week: 9, day: "Friday", type: "Intervals", description: "Intervals 3×3 km @ 4:35–4:50 (600 m resting jog)." },
        { id: "w9d4", week: 9, day: "Sunday", type: "Long Run", description: "Long 20–22 km easy." },
      ],
    },
    {
      week: 10,
      focus: "Active recovery phase.",
      workouts: [
        { id: "w10d1", week: 10, day: "Tuesday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w10d2", week: 10, day: "Wednesday", type: "Fartlek", description: "Fartlek 8 km — 4 min easy / 2 min @ 5:00." },
        { id: "w10d3", week: 10, day: "Friday", type: "Easy", description: "Easy 12–14 km." },
        { id: "w10d4", week: 10, day: "Sunday", type: "Easy", description: "Easy 7 km (recovery)." },
      ],
    },
    {
      week: 11,
      focus: "Interval sharpening.",
      workouts: [
        { id: "w11d1", week: 11, day: "Tuesday", type: "Intervals", description: "Intervals 5×2 km @ 4:40–4:50 (500 m resting jog)." },
        { id: "w11d2", week: 11, day: "Wednesday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w11d3", week: 11, day: "Friday", type: "Intervals", description: "Easy 7 km + 4×600 m @ 4:00 (400 m resting jog) + 1 km jogging (resting)." },
        { id: "w11d4", week: 11, day: "Sunday", type: "Long Run", description: "Long 18–20 km easy." },
      ],
    },
    {
      week: 12,
      focus: "Taper phase starts.",
      workouts: [
        { id: "w12d1", week: 12, day: "Tuesday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w12d2", week: 12, day: "Wednesday", type: "Intervals", description: "Intervals 3×3 km @ 4:30–4:45 (600 m resting jog)." },
        { id: "w12d3", week: 12, day: "Friday", type: "Easy", description: "Easy 12 km." },
        { id: "w12d4", week: 12, day: "Sunday", type: "Variable", description: "Variable 9 km — 1 km easy / 1 km @ 5:00." },
      ],
    },
    {
      week: 13,
      focus: "Race execution — steady start, strong finish.",
      workouts: [
        { id: "w13d1", week: 13, day: "Tuesday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w13d2", week: 13, day: "Wednesday", type: "Easy", description: "Easy 10 km with 2×1 km @ 5:00 included within the run." },
        { id: "w13d3", week: 13, day: "Friday", type: "Easy", description: "Easy 6–7 km with 2×400 m @ 5:00 included within the run." },
        { id: "w13d4", week: 13, day: "Sunday", type: "Race", description: "HALF MARATHON 21.1 km Race — target 1:45." },
      ],
    },
  ];
}

function get130Plan(): WeekData[] {
  return [
    {
      week: 1,
      focus: "Build aerobic base + first speed elements.",
      workouts: [
        { id: "w1d1", week: 1, day: "Monday", type: "Easy", description: "Easy 9 km." },
        { id: "w1d2", week: 1, day: "Wednesday", type: "Fartlek", description: "Fartlek 8 km — 3 min easy / 1 min @ 4:10–4:15." },
        { id: "w1d3", week: 1, day: "Thursday", type: "S&C", description: "2 km easy + S&C (4 circuits — rest 20 sec between exercises, 20 sec between circuits):\ncalf raises ×40,\ncrunches 15–20,\nsquats 35,\nplank 50–60 s,\ncoordination 7/leg;\nthen split jumps 3 min (no rest)." },
        { id: "w1d4", week: 1, day: "Friday", type: "Developing", description: "Developing run 8 km — warm-up 1–2 km, run @ HR 80–90%." },
        { id: "w1d5", week: 1, day: "Sunday", type: "Long Run", description: "Long 16–18 km easy." },
      ],
    },
    {
      week: 2,
      focus: "Endurance + strength buildup.",
      workouts: [
        { id: "w2d1", week: 2, day: "Monday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w2d2", week: 2, day: "Wednesday", type: "Fartlek", description: "Fartlek 8 km — 4 min easy / 2 min @ 4:05–4:15." },
        { id: "w2d3", week: 2, day: "Thursday", type: "S&C", description: "2 km easy + S&C (4 circuits — no rest between exercises, no rest between circuits):\ncalf raises ×40,\ncrunches 15–20,\nsquats 35,\nplank 50–60 s,\ncoordination 7/leg;\nthen split jumps 4 min (no rest)." },
        { id: "w2d4", week: 2, day: "Friday", type: "Developing", description: "Developing run 10 km — warm-up 1–2 km, run @ HR 80–90%." },
        { id: "w2d5", week: 2, day: "Sunday", type: "Long Run", description: "Long 20 km easy." },
      ],
    },
    {
      week: 3,
      focus: "Full recovery week.",
      workouts: [
        { id: "w3d1", week: 3, day: "Monday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w3d2", week: 3, day: "Wednesday", type: "S&C", description: "Easy 5–6 km + S&C (5–6 circuits — rest 20 sec between exercises, 30 sec between circuits):\nsplit jumps 1 min,\nstep-ups 1 min,\nhigh knees 30 s,\njumping jack 1 min,\ncalf raises ×40." },
        { id: "w3d3", week: 3, day: "Thursday", type: "Easy", description: "Easy 8 km + 2 km @ 4:15 (included within the run)." },
        { id: "w3d4", week: 3, day: "Friday", type: "Easy", description: "Easy 14 km." },
        { id: "w3d5", week: 3, day: "Sunday", type: "Easy", description: "Easy 7 km (recovery)." },
      ],
    },
    {
      week: 4,
      focus: "Aerobic development + strength.",
      workouts: [
        { id: "w4d1", week: 4, day: "Monday", type: "Fartlek", description: "Fartlek 10 km — 3 easy / 2 @ 4:00–4:10." },
        { id: "w4d2", week: 4, day: "Wednesday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w4d3", week: 4, day: "Thursday", type: "S&C", description: "2 km easy + S&C (5 circuits — no rest between exercises, 1 min between circuits):\ncalf raises ×40,\nhanging knee raises ×10,\nsquats 35,\nplank 50–60 s,\nlunges 14/leg;\nthen split jumps 2 min + step-ups 1 min." },
        { id: "w4d4", week: 4, day: "Friday", type: "Easy", description: "Easy 12 km." },
        { id: "w4d5", week: 4, day: "Sunday", type: "Long Run", description: "Long 22–23 km easy." },
      ],
    },
    {
      week: 5,
      focus: "Strength + speed endurance.",
      workouts: [
        { id: "w5d1", week: 5, day: "Monday", type: "S&C", description: "2 km easy + S&C (5 circuits — no rest between exercises, 1 min between circuits):\ncalf raises ×40,\nhanging raises ×10,\nsquats 35,\nplank 50–60 s,\ncoordination 10/leg;\nthen split jumps 2 min + step-ups 1 min." },
        { id: "w5d2", week: 5, day: "Wednesday", type: "Easy", description: "Easy 12–14 km." },
        { id: "w5d3", week: 5, day: "Thursday", type: "Fartlek", description: "Fartlek 10 km — 2 easy / 2 @ 3:55–4:10 (repeat)." },
        { id: "w5d4", week: 5, day: "Friday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w5d5", week: 5, day: "Sunday", type: "Long Run", description: "Long 21 km easy." },
      ],
    },
    {
      week: 6,
      focus: "High-volume aerobic phase.",
      workouts: [
        { id: "w6d1", week: 6, day: "Monday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w6d2", week: 6, day: "Wednesday", type: "Fartlek", description: "Fartlek 9 km — 1 easy / 2 @ 4:05." },
        { id: "w6d3", week: 6, day: "Thursday", type: "S&C", description: "2 km easy + S&C (6 circuits — no rest between exercises, 1 min between circuits):\ncalf raises ×40,\nhanging raises ×10,\nsquats 35,\nplank 50–60 s,\ncoordination 10/leg;\nthen split jumps 3 min + step-ups 1 min." },
        { id: "w6d4", week: 6, day: "Friday", type: "Easy", description: "Easy 12 km." },
        { id: "w6d5", week: 6, day: "Sunday", type: "Long Run", description: "Long 25 km easy." },
      ],
    },
    {
      week: 7,
      focus: "Active recovery + form work.",
      workouts: [
        { id: "w7d1", week: 7, day: "Monday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w7d2", week: 7, day: "Wednesday", type: "S&C", description: "Easy 5–6 km + S&C (4 circuits — rest 20 sec between exercises, 30 sec between circuits):\nsplit jumps 1 min,\nstep-ups 1 min,\nhigh knees 30 s,\njumping jack 1 min,\ncalf raises ×40." },
        { id: "w7d3", week: 7, day: "Thursday", type: "Variable", description: "Variable 9 km — alternate 1 km easy / 1 km @ 4:15." },
        { id: "w7d4", week: 7, day: "Friday", type: "Easy", description: "Easy 16 km." },
        { id: "w7d5", week: 7, day: "Sunday", type: "Easy", description: "Easy 8 km (recovery)." },
      ],
    },
    {
      week: 8,
      focus: "Strong threshold work.",
      workouts: [
        { id: "w8d1", week: 8, day: "Monday", type: "Intervals", description: "Intervals — 10×1 km @ 3:55–4:10, 600 m jog." },
        { id: "w8d2", week: 8, day: "Wednesday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w8d3", week: 8, day: "Thursday", type: "Regressive", description: "Regressive 10 km — 1 easy → 3 @ 4:00 → 3 @ 4:15 → 3 easy." },
        { id: "w8d4", week: 8, day: "Friday", type: "Easy", description: "Easy 12 km." },
        { id: "w8d5", week: 8, day: "Sunday", type: "Long Run", description: "Long 23 km easy." },
      ],
    },
    {
      week: 9,
      focus: "Peak threshold training.",
      workouts: [
        { id: "w9d1", week: 9, day: "Monday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w9d2", week: 9, day: "Wednesday", type: "Intervals", description: "Intervals — 10×1 km @ 3:55–4:10, 400 m jog." },
        { id: "w9d3", week: 9, day: "Thursday", type: "Easy", description: "Easy 12 km." },
        { id: "w9d4", week: 9, day: "Friday", type: "Progressive", description: "Progressive 10 km — 1 km easy → 3 km @ 4:30 → 3 km @ 4:15 → 2 km @ 4:05 → 1 km easy." },
        { id: "w9d5", week: 9, day: "Sunday", type: "Long Run", description: "Long 26 km easy." },
      ],
    },
    {
      week: 10,
      focus: "Max aerobic power week.",
      workouts: [
        { id: "w10d1", week: 10, day: "Monday", type: "Easy", description: "Easy 8 km (recovery)." },
        { id: "w10d2", week: 10, day: "Wednesday", type: "Intervals", description: "Intervals — 3×3 km @ 4:00–4:10, 1 km jog." },
        { id: "w10d3", week: 10, day: "Thursday", type: "Easy", description: "Easy 10 km." },
        { id: "w10d4", week: 10, day: "Friday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w10d5", week: 10, day: "Sunday", type: "Tempo", description: "Tempo 15 km @ 4:15." },
      ],
    },
    {
      week: 11,
      focus: "Light recovery block.",
      workouts: [
        { id: "w11d1", week: 11, day: "Monday", type: "Easy", description: "Easy 6 km (recovery)." },
        { id: "w11d2", week: 11, day: "Wednesday", type: "Easy", description: "Easy 10 km (recovery)." },
        { id: "w11d3", week: 11, day: "Thursday", type: "Easy", description: "Easy 9 km + 2×1 km @ 4:15 (included within the run)." },
        { id: "w11d4", week: 11, day: "Friday", type: "Long Run", description: "14 km easy." },
        { id: "w11d5", week: 11, day: "Sunday", type: "Easy", description: "Easy 8 km (recovery)." },
      ],
    },
    {
      week: 12,
      focus: "Very heavy threshold + VO₂ load.",
      workouts: [
        { id: "w12d1", week: 12, day: "Monday", type: "Intervals", description: "Intervals — 5 km @ 4:10 → 1 km jog → 3 km @ 4:05 → 1 km jog → 3 km @ 4:00–4:05." },
        { id: "w12d2", week: 12, day: "Wednesday", type: "Easy", description: "Easy 7 km." },
        { id: "w12d3", week: 12, day: "Thursday", type: "Repeats", description: "Repeats — 8×1 km @ 3:50–4:00; 2 min passive rest (walk, sit, stand)." },
        { id: "w12d4", week: 12, day: "Friday", type: "Easy", description: "Easy 10 km (recovery)." },
        { id: "w12d5", week: 12, day: "Sunday", type: "Long Run", description: "Long 27 km easy." },
      ],
    },
    {
      week: 13,
      focus: "Peak high-intensity phase.",
      workouts: [
        { id: "w13d1", week: 13, day: "Monday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w13d2", week: 13, day: "Wednesday", type: "Intervals", description: "Intervals — 4×3 km @ 4:00–4:10, 800–1000 m jog." },
        { id: "w13d3", week: 13, day: "Thursday", type: "Easy", description: "Easy 10 km." },
        { id: "w13d4", week: 13, day: "Friday", type: "Repeats", description: "Repeats — 8×1 km @ 3:50–4:00; 2 min passive rest (walk, sit, stand)." },
        { id: "w13d5", week: 13, day: "Sunday", type: "Long Run", description: "Long 24 km easy." },
      ],
    },
    {
      week: 14,
      focus: "Final sharpening.",
      workouts: [
        { id: "w14d1", week: 14, day: "Monday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w14d2", week: 14, day: "Wednesday", type: "Intervals", description: "Intervals — 3×2 km @ 4:00–4:10, 1 km jog." },
        { id: "w14d3", week: 14, day: "Thursday", type: "Easy", description: "Easy 12 km." },
        { id: "w14d4", week: 14, day: "Friday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w14d5", week: 14, day: "Sunday", type: "Variable", description: "Variable 11 km — alternate 1 km easy / 1 km @ 4:15." },
      ],
    },
    {
      week: 15,
      focus: "Race execution — stay fresh & controlled.",
      workouts: [
        { id: "w15d1", week: 15, day: "Monday", type: "Easy", description: "Easy 8 km (recovery)." },
        { id: "w15d2", week: 15, day: "Wednesday", type: "Easy", description: "Easy 12 km + 2×1 km @ 4:15 (included within the run)." },
        { id: "w15d3", week: 15, day: "Thursday", type: "Easy", description: "Easy 10 km + 1×1 km @ 4:15 (included within the run)." },
        { id: "w15d4", week: 15, day: "Friday", type: "Easy", description: "Easy 7 km (recovery)." },
        { id: "w15d5", week: 15, day: "Sunday", type: "Race", description: "HALF MARATHON — target 1:30." },
      ],
    },
  ];
}

function get200Plan(): WeekData[] {
  return [
    {
      week: 1,
      focus: "Build routine and aerobic foundation.",
      workouts: [
        { id: "w1d1", week: 1, day: "Monday", type: "Fartlek", description: "Fartlek 6 km — 3 min easy / 1 min @ 5:20–5:40." },
        { id: "w1d2", week: 1, day: "Wednesday", type: "Easy", description: "Easy 6–8 km." },
        { id: "w1d3", week: 1, day: "Friday", type: "S&C", description: "2 km easy + S&C (2 circuits, rest 20 s between exercises, 1 min between circuits):\nsplit jumps 40 s,\nplank 30–40 s,\nfrog 10 reps,\ncalf raises 30/leg,\nsquats 20,\nhanging knee raises 10,\nlunges 8/leg,\nhigh knees 30 s." },
        { id: "w1d4", week: 1, day: "Sunday", type: "Long Run", description: "Long 9–11 km easy." },
      ],
    },
    {
      week: 2,
      focus: "Endurance + strength progression.",
      workouts: [
        { id: "w2d1", week: 2, day: "Monday", type: "Fartlek", description: "Fartlek 7 km — 4 min easy / 2 min @ 5:10–5:40." },
        { id: "w2d2", week: 2, day: "Wednesday", type: "Easy", description: "Easy 6–8 km." },
        { id: "w2d3", week: 2, day: "Friday", type: "S&C", description: "2 km easy + S&C (3 circuits, rest 20 s between exercises, 1 min between circuits):\nsplit jumps 40 s,\nplank 30–40 s,\nfrog 10 reps,\ncalf raises 30/leg,\nsquats 20,\nhanging knee raises 10,\nlunges 8/leg,\nhigh knees 30 s." },
        { id: "w2d4", week: 2, day: "Sunday", type: "Long Run", description: "Long 10–12 km easy." },
      ],
    },
    {
      week: 3,
      focus: "Light load week; maintain rhythm.",
      workouts: [
        { id: "w3d1", week: 3, day: "Monday", type: "Fartlek", description: "Fartlek 7 km — 3 min easy / 2 min @ 5:10–5:40." },
        { id: "w3d2", week: 3, day: "Wednesday", type: "Regressive", description: "Regressive run 8 km — 1 km easy → 3 km @ 5:30–5:40 → 3 km @ 6:00 → 1 km easy." },
        { id: "w3d3", week: 3, day: "Friday", type: "S&C", description: "2 km easy + S&C (4 circuits, rest 20 s between exercises, 1 min between circuits):\nsplit jumps 40 s,\nplank 30–40 s,\nfrog 10 reps,\ncalf raises 30/leg,\nsquats 20,\nhanging knee raises 10,\nlunges 8/leg,\nhigh knees 30 s." },
        { id: "w3d4", week: 3, day: "Sunday", type: "Easy", description: "Easy 10–14 km." },
      ],
    },
    {
      week: 4,
      focus: "Recovery adaptation.",
      workouts: [
        { id: "w4d1", week: 4, day: "Monday", type: "Easy", description: "Easy 6–8 km (recovery)." },
        { id: "w4d2", week: 4, day: "Wednesday", type: "Fartlek", description: "Fartlek 7 km — 4 min easy / 1 min @ 5:30–5:40." },
        { id: "w4d3", week: 4, day: "Friday", type: "Easy", description: "Easy 8–10 km." },
        { id: "w4d4", week: 4, day: "Sunday", type: "Easy", description: "Easy 6–8 km." },
      ],
    },
    {
      week: 5,
      focus: "Aerobic development + stability.",
      workouts: [
        { id: "w5d1", week: 5, day: "Monday", type: "Variable", description: "Variable run 8 km — 1 km easy / 1 km @ 5:30–5:40." },
        { id: "w5d2", week: 5, day: "Wednesday", type: "Easy", description: "Easy 6–8 km (recovery)." },
        { id: "w5d3", week: 5, day: "Friday", type: "S&C", description: "2 km easy + S&C (3 circuits, rest 20 s between exercises, 1 min between circuits):\nsplit jumps 30 s,\nplank 30–40 s,\nhigh knees 30 s,\nplank 30–40 s,\njumping jack 40–50 s,\ncalf raises 40,\nbutt kicks 40 s." },
        { id: "w5d4", week: 5, day: "Sunday", type: "Long Run", description: "Long 11–15 km easy." },
      ],
    },
    {
      week: 6,
      focus: "Speed + strength blend.",
      workouts: [
        { id: "w6d1", week: 6, day: "Monday", type: "Variable", description: "Variable run 8 km — same structure as week 5." },
        { id: "w6d2", week: 6, day: "Wednesday", type: "Intervals", description: "Easy 9 km + 3×500 m @ 5:00–5:20." },
        { id: "w6d3", week: 6, day: "Friday", type: "S&C", description: "2 km easy + S&C (4 circuits, rest 20 s between exercises, 1 min between circuits):\nsplit jumps 30 s,\nplank 30–40 s,\nhigh knees 30 s,\nplank 30–40 s,\njumping jack 40–50 s,\ncalf raises 40,\nbutt kicks 40 s." },
        { id: "w6d4", week: 6, day: "Sunday", type: "Long Run", description: "Long 12–15 km easy." },
      ],
    },
    {
      week: 7,
      focus: "Strength maintenance + intensity.",
      workouts: [
        { id: "w7d1", week: 7, day: "Monday", type: "Progressive", description: "Progressive run 10 km — 4 km easy → 3 km @ 5:30–5:40 → 2 km @ 5:00–5:10 → 1 km easy." },
        { id: "w7d2", week: 7, day: "Wednesday", type: "Easy", description: "2 km easy → full warm-up → 5 km easy." },
        { id: "w7d3", week: 7, day: "Friday", type: "S&C", description: "2 km easy + S&C (5 circuits, rest 20 s between exercises, 1 min between circuits):\nsplit jumps 30 s,\nplank 30–40 s,\nhigh knees 30 s,\ncrunches 20,\njumping jack 50 s,\ncalf raises 40/leg,\nbutt kicks 40 s." },
        { id: "w7d4", week: 7, day: "Sunday", type: "Long Run", description: "Long 12–15 km easy." },
      ],
    },
    {
      week: 8,
      focus: "Recovery and aerobic reset.",
      workouts: [
        { id: "w8d1", week: 8, day: "Monday", type: "Easy", description: "Easy 6–8 km." },
        { id: "w8d2", week: 8, day: "Wednesday", type: "Fartlek", description: "Fartlek 7 km — 4 min easy / 1 min @ 5:30–5:40." },
        { id: "w8d3", week: 8, day: "Friday", type: "Easy", description: "Easy 10–12 km." },
        { id: "w8d4", week: 8, day: "Sunday", type: "Easy", description: "Easy 8 km." },
      ],
    },
    {
      week: 9,
      focus: "Threshold development.",
      workouts: [
        { id: "w9d1", week: 9, day: "Monday", type: "Intervals", description: "Intervals 2×3 km @ 5:00–5:20 — 600 m jog recoveries." },
        { id: "w9d2", week: 9, day: "Wednesday", type: "Easy", description: "Easy 6 km (recovery)." },
        { id: "w9d3", week: 9, day: "Friday", type: "Tempo", description: "Tempo run 10 km — 5:20–5:35." },
        { id: "w9d4", week: 9, day: "Sunday", type: "Long Run", description: "Long 12–15 km easy." },
      ],
    },
    {
      week: 10,
      focus: "Active recovery phase.",
      workouts: [
        { id: "w10d1", week: 10, day: "Monday", type: "Easy", description: "Easy 6 km (recovery)." },
        { id: "w10d2", week: 10, day: "Wednesday", type: "Fartlek", description: "Fartlek 8 km — 4 min easy / 2 min @ 5:00." },
        { id: "w10d3", week: 10, day: "Friday", type: "Easy", description: "Easy 10 km." },
        { id: "w10d4", week: 10, day: "Sunday", type: "Easy", description: "Easy 15–18 km easy." },
      ],
    },
    {
      week: 11,
      focus: "Peak endurance.",
      workouts: [
        { id: "w11d1", week: 11, day: "Monday", type: "Easy", description: "Easy 6 km (recovery)." },
        { id: "w11d2", week: 11, day: "Wednesday", type: "Intervals", description: "Intervals 3×3 km @ 5:00–5:20 — 800 m jog." },
        { id: "w11d3", week: 11, day: "Friday", type: "Easy", description: "Easy 10 km." },
        { id: "w11d4", week: 11, day: "Sunday", type: "Long Run", description: "Long 21.1 km easy (full-distance simulation)." },
      ],
    },
    {
      week: 12,
      focus: "Recovery week.",
      workouts: [
        { id: "w12d1", week: 12, day: "Monday", type: "Easy", description: "Easy 6–8 km (recovery)." },
        { id: "w12d2", week: 12, day: "Wednesday", type: "Fartlek", description: "Fartlek 9 km — 3 min easy / 1 min @ 5:30–5:40." },
        { id: "w12d3", week: 12, day: "Friday", type: "Easy", description: "Easy 12–14 km." },
        { id: "w12d4", week: 12, day: "Sunday", type: "Easy", description: "Easy 6–8 km (recovery)." },
      ],
    },
    {
      week: 13,
      focus: "Sharpening phase.",
      workouts: [
        { id: "w13d1", week: 13, day: "Monday", type: "Tempo", description: "Tempo 10 km — 5:10–5:30." },
        { id: "w13d2", week: 13, day: "Wednesday", type: "Easy", description: "Easy 6–8 km." },
        { id: "w13d3", week: 13, day: "Friday", type: "Intervals", description: "Intervals 6×600 m @ 4:40–5:00 — 400 m jog." },
        { id: "w13d4", week: 13, day: "Sunday", type: "Long Run", description: "Long 15–17 km easy." },
      ],
    },
    {
      week: 14,
      focus: "Final build.",
      workouts: [
        { id: "w14d1", week: 14, day: "Monday", type: "Easy", description: "Easy 6–8 km." },
        { id: "w14d2", week: 14, day: "Wednesday", type: "Variable", description: "Variable 12 km — alternate 3 km easy / 3 km @ 5:35–5:40 / 3 km easy." },
        { id: "w14d3", week: 14, day: "Friday", type: "Easy", description: "Easy 10 km." },
        { id: "w14d4", week: 14, day: "Sunday", type: "Fartlek", description: "Fartlek 9 km — 3 min easy / 2 min @ 5:10–5:40." },
      ],
    },
    {
      week: 15,
      focus: "Race week — stay fresh.",
      workouts: [
        { id: "w15d1", week: 15, day: "Monday", type: "Easy", description: "Easy 10 km + 3×1 km @ 5:35 (included within run)." },
        { id: "w15d2", week: 15, day: "Wednesday", type: "Easy", description: "Easy 10 km." },
        { id: "w15d3", week: 15, day: "Friday", type: "Easy", description: "Easy 6 km." },
        { id: "w15d4", week: 15, day: "Sunday", type: "Race", description: "Half Marathon 21.1 km — target 2:00." },
      ],
    },
  ];
}

function generateGuide(): IntroSection[] {
  return [
    {
      id: "gen1",
      section: "General",
      icon: "Settings",
      type: "After eating",
      detail: "Start running at least 1.5 hours after a meal.",
    },
    {
      id: "gen2",
      section: "General",
      icon: "Settings",
      type: "Rest days",
      detail: "Have 1 full rest day and 1 low-load day (easy run) each week.",
    },
    {
      id: "gen3",
      section: "General",
      icon: "Settings",
      type: "Extra rest",
      detail: "If very tired, replace session with only warm-up or take an extra rest day.",
    },
    {
      id: "gen4",
      section: "General",
      icon: "Settings",
      type: "Pain - serious",
      detail: "Stop training if you feel strong chest pain or severe headache.",
    },
    {
      id: "gen5",
      section: "General",
      icon: "Settings",
      type: "Pain - side stitch",
      detail: "Slow down or walk and take deep belly breaths; resume when it eases.",
    },
    {
      id: "gen6",
      section: "General",
      icon: "Settings",
      type: "Self-check",
      detail: "Consider sleep, stress, weather and life load when judging how hard to train.",
    },
    {
      id: "wu1",
      section: "Warm-up",
      icon: "Flame",
      type: "When required",
      detail: "Warm up before intervals, speed work, fartlek, developing runs, and marathon/tempo efforts (unless plan says otherwise).",
    },
    {
      id: "wu2",
      section: "Warm-up",
      icon: "Flame",
      type: "When not needed",
      detail: "Easy runs (Zone 2) can start directly without warm-up.",
    },
    {
      id: "wu3",
      section: "Warm-up",
      icon: "Flame",
      type: "Routine",
      detail: "1–2 km very easy jog → dynamic stretches (leg swings, butt kicks, A-skips) → 3–4 strides 60–80 m.",
    },
    {
      id: "cd1",
      section: "Cool-down",
      icon: "Wind",
      type: "After hard sessions",
      detail: "5–10 min very easy jog → light stretching or foam rolling.",
    },
    {
      id: "cd2",
      section: "Cool-down",
      icon: "Wind",
      type: "After easy runs",
      detail: "Optional; stop when you feel comfortable.",
    },
    {
      id: "hr1",
      section: "HR Zones",
      icon: "Heart",
      type: "Zone 2 (60–70% from max HR)",
      detail: "Easy / recovery runs — conversational pace.",
    },
    {
      id: "hr2",
      section: "HR Zones",
      icon: "Heart",
      type: "Zone 3 (70–80% from max HR)",
      detail: "Tempo / developing runs — comfortably hard.",
    },
    {
      id: "hr3",
      section: "HR Zones",
      icon: "Heart",
      type: "Zone 4 (80–90% from max HR)",
      detail: "Threshold / intervals — hard, can speak only a few words.",
    },
    {
      id: "hr4",
      section: "HR Zones",
      icon: "Heart",
      type: "Zone 5 (90–100% from max HR)",
      detail: "VO₂ max / speed work — very hard, minimal talking.",
    },
    {
      id: "wt1",
      section: "Workout Types",
      icon: "Zap",
      type: "Easy run",
      detail: "Relaxed Zone 2 effort; builds aerobic base.",
    },
    {
      id: "wt2",
      section: "Workout Types",
      icon: "Zap",
      type: "Long run",
      detail: "Extended Zone 2 effort; builds endurance and mental toughness.",
    },
    {
      id: "wt3",
      section: "Workout Types",
      icon: "Zap",
      type: "Fartlek",
      detail: "Unstructured speed play alternating fast and easy efforts.",
    },
    {
      id: "wt4",
      section: "Workout Types",
      icon: "Zap",
      type: "Tempo run",
      detail: "Sustained Zone 3–4 effort; improves lactate threshold.",
    },
    {
      id: "wt5",
      section: "Workout Types",
      icon: "Zap",
      type: "Intervals",
      detail: "Repeated hard efforts with recovery jogs; builds speed and VO₂ max.",
    },
    {
      id: "wt6",
      section: "Workout Types",
      icon: "Zap",
      type: "Progressive run",
      detail: "Start easy, finish fast; teaches pace control.",
    },
    {
      id: "wt7",
      section: "Workout Types",
      icon: "Zap",
      type: "Developing run",
      detail: "Zone 3–4 sustained effort; prepares for race intensity.",
    },
  ];
}

function generateStrengthConditioning(): IntroSection[] {
  return [
    {
      id: "sc1",
      section: "Lower Body",
      type: "Squats",
      icon: "Footprints",
      detail: "Feet shoulder-width apart. Squat down with control. If healthy, squat as low as possible. Keep torso upright.",
    },
    {
      id: "sc2",
      section: "Lower Body",
      type: "Lunges",
      detail: "Step forward into a lunge. Push back to the starting position using the front leg only. Alternate legs.",
    },
    {
      id: "sc3",
      section: "Lower Body",
      type: "Calf Raises",
      detail: "Rise onto the toes, then slowly lower heels to the ground. Can be done holding a support or on one leg.",
    },
    {
      id: "sc4",
      section: "Lower Body",
      type: "Step-Ups",
      detail: "Step or jump onto an elevated platform (20 cm to knee height), alternating legs.",
    },
    {
      id: "sc5",
      section: "Lower Body",
      type: "Split Jumps",
      detail: "Jump and switch legs in the air, landing with one leg forward and one back. Use arms like running.",
    },
    {
      id: "sc6",
      section: "Lower Body",
      type: "Frog Jumps",
      detail: "From a squat, jump upward or forward, fully extending legs. Land softly on toes.",
    },
    {
      id: "sc7",
      section: "Core",
      type: "Plank",
      icon: "Target",
      detail: "Hold a straight-body position supported on hands or elbows. Keep core tight and hips level.",
    },
    {
      id: "sc8",
      section: "Core",
      type: "Crunches",
      detail: "Lie on your back with knees bent. Lift shoulders or bring elbows toward knees. Control the movement.",
    },
    {
      id: "sc9",
      section: "Core",
      type: "Hanging Knee Raises",
      detail: "Hang from a bar and lift bent knees toward the chest with control.",
    },
    {
      id: "sc10",
      section: "Dynamic",
      type: "High Knee Raises",
      icon: "Zap",
      detail: "Run in place, lifting knees as high and as fast as possible while staying light on your feet.",
    },
    {
      id: "sc11",
      section: "Dynamic",
      type: "Butt Kicks",
      detail: "Run in place, kicking heels toward the glutes while staying light on the balls of your feet.",
    },
    {
      id: "sc12",
      section: "Dynamic",
      type: "Jumping Jacks",
      detail: "Jump legs out wide and back together while raising and lowering arms simultaneously.",
    },
    {
      id: "sc13",
      section: "Coordination",
      type: "Coordination / Balance Drills",
      icon: "PersonStanding",
      detail: "Stand on one leg. Bend forward and reach with the opposite hand toward the toes while the free leg is bent and lifted behind. After touching, quickly straighten up, lift the bent knee upward and raise the opposite arm. The supporting foot rises onto the toes. Alternate sides.",
    },
  ];
}

export class MemStorage implements IStorage {
  async getPlan(planType: PlanType): Promise<TrainingPlan | undefined> {
    let weeks: WeekData[];
    let name: string;
    let goalTime: string;
    let totalWeeks: number;

    switch (planType) {
      case "1:30":
        weeks = get130Plan();
        name = "Sub 1:30 Plan";
        goalTime = "1:30";
        totalWeeks = 15;
        break;
      case "1:45":
        weeks = get145Plan();
        name = "Sub 1:45 Plan";
        goalTime = "1:45";
        totalWeeks = 13;
        break;
      case "2:00":
        weeks = get200Plan();
        name = "Sub 2:00 Plan";
        goalTime = "2:00";
        totalWeeks = 15;
        break;
      default:
        return undefined;
    }

    return {
      id: planType,
      name,
      goalTime,
      totalWeeks,
      weeks,
    };
  }

  async getGuide(): Promise<IntroductionContent> {
    return {
      sections: generateGuide(),
    };
  }

  async getStrengthConditioning(): Promise<IntroductionContent> {
    return {
      sections: generateStrengthConditioning(),
    };
  }
}

export const storage = new MemStorage();
