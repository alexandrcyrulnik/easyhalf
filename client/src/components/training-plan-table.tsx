import { useState, useMemo, useEffect, useRef, useCallback } from "react";
import { Checkbox } from "@/components/ui/checkbox";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { ChevronDown, ChevronUp, Check } from "lucide-react";
import type { WeekData, Workout } from "@shared/schema";
import { cn } from "@/lib/utils";
import type { DistanceUnit, Language } from "@/lib/localStorage";

interface TrainingPlanTableProps {
  weeks: WeekData[];
  completedWorkouts: Set<string>;
  onToggleWorkout: (workoutId: string) => void;
  distanceUnit?: DistanceUnit;
  language?: Language;
}

const workoutTypeColors: Record<string, string> = {
  // English types
  "Easy": "bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300",
  "Long Run": "bg-teal-100 text-teal-800 dark:bg-teal-900 dark:text-teal-300",
  "Tempo": "bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-300",
  "Intervals": "bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300",
  "Fartlek": "bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-300",
  "S&C": "bg-indigo-100 text-indigo-800 dark:bg-indigo-900 dark:text-indigo-300",
  "Race": "bg-[#FFE100] text-black",
  // Russian types
  "Медленно": "bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300",
  "Медленный бег": "bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300",
  "Длительный": "bg-teal-100 text-teal-800 dark:bg-teal-900 dark:text-teal-300",
  "Длительный бег": "bg-teal-100 text-teal-800 dark:bg-teal-900 dark:text-teal-300",
  "Темповой": "bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-300",
  "Темповой кросс": "bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-300",
  "Интервальная": "bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300",
  "Повторы": "bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300",
  "Фартлек": "bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-300",
  "Переменный": "bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-300",
  "ОФП": "bg-indigo-100 text-indigo-800 dark:bg-indigo-900 dark:text-indigo-300",
  "Прогрессивный": "bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-300",
  "Прогрессивный бег": "bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-300",
  "Развивающий": "bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-300",
  "Развивающий бег": "bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-300",
  "Регрессивный": "bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300",
  "Гонка": "bg-[#FFE100] text-black",
  "Старт": "bg-[#FFE100] text-black",
};

function getWorkoutTypeColor(type: string): string {
  if (workoutTypeColors[type]) {
    return workoutTypeColors[type];
  }
  for (const [key, value] of Object.entries(workoutTypeColors)) {
    if (type.toLowerCase().includes(key.toLowerCase())) {
      return value;
    }
  }
  return "bg-secondary text-secondary-foreground";
}

function convertKmToMiles(km: number): number {
  return Math.round(km * 0.621371 * 10) / 10;
}

function convertDescription(description: string, unit: DistanceUnit): string {
  if (unit === "km") return description;

  // Handle both "km" and "км" (Russian)
  return description
    .replace(/(\d+(?:[.,]\d+)?)\s*[–\-]\s*(\d+(?:[.,]\d+)?)\s*(?:km|км)/gi, (_match, num1, num2) => {
      const miles1 = convertKmToMiles(parseFloat(num1.replace(",", ".")));
      const miles2 = convertKmToMiles(parseFloat(num2.replace(",", ".")));
      return `${miles1}–${miles2} mi`;
    })
    .replace(/(\d+(?:[.,]\d+)?)\s*(?:km|км)/gi, (_match, num) => {
      const miles = convertKmToMiles(parseFloat(num.replace(",", ".")));
      return `${miles} mi`;
    });
}

function formatDescription(description: string, isCompleted: boolean, unit: DistanceUnit = "km") {
  const converted = convertDescription(description, unit);
  const unitLabel = unit === "km" ? "(?:km|км)" : "mi";
  const distancePattern = new RegExp(
    `^((?:Easy|Long|Tempo|Intervals|Fartlek|Recovery|Race|Warm-up|Cool-down|Медленно|Длительный|Темповой|Фартлек|Развивающий|Прогрессивный|Регрессивный)?\\s*[\\d.,–\\-]+\\s*${unitLabel})`,
    "i"
  );
  const match = converted.match(distancePattern);

  if (match) {
    const boldPart = match[1];
    const rest = converted.slice(boldPart.length);
    return (
      <>
        <span className={cn("font-semibold", isCompleted ? "text-muted-foreground" : "text-foreground")}>{boldPart}</span>
        {rest}
      </>
    );
  }
  return converted;
}

function getBadgeText(workout: Workout): string {
  const descLower = workout.description.toLowerCase();

  // English combined workouts
  const hasSC = descLower.includes("s&c") || descLower.includes("strength");
  if (hasSC && workout.type !== "S&C") {
    return `${workout.type} + S&C`;
  }
  if (workout.type === "S&C") {
    const runTypes = ["easy", "long", "tempo", "intervals", "fartlek", "recovery"];
    for (const runType of runTypes) {
      if (descLower.includes(runType)) {
        const capitalizedType = runType.charAt(0).toUpperCase() + runType.slice(1);
        return `${capitalizedType} + S&C`;
      }
    }
  }

  // Russian combined workouts: type is "ОФП" but description starts with a run keyword
  if (workout.type === "ОФП") {
    const ruRunTypes: [string, string][] = [
      ["медленно", "Медленно"],
      ["длительный", "Длительный"],
      ["темповой", "Темповой"],
      ["фартлек", "Фартлек"],
      ["развивающий", "Развивающий"],
      ["прогрессивный", "Прогрессивный"],
    ];
    for (const [keyword, label] of ruRunTypes) {
      if (descLower.startsWith(keyword)) {
        return `${label} + ОФП`;
      }
    }
  }
  // Russian: type is a run but description mentions ОФП
  if (descLower.includes("офп") && workout.type !== "ОФП") {
    return `${workout.type} + ОФП`;
  }

  return workout.type;
}

export default function TrainingPlanTable({
  weeks,
  completedWorkouts,
  onToggleWorkout,
  distanceUnit = "km",
  language = "en",
}: TrainingPlanTableProps) {
  const t = {
    week: language === "ru" ? "Неделя" : "Week",
    complete: language === "ru" ? "Выполнено" : "Complete",
    noWorkouts: language === "ru" ? "Тренировки не найдены" : "No workouts found",
  };
  const [collapsedWeeks, setCollapsedWeeks] = useState<Set<number>>(() => {
    if (!weeks) return new Set();
    return new Set(weeks.filter(w => w.week !== 1).map(w => w.week));
  });
  const [stickyWeek, setStickyWeek] = useState<WeekData | null>(null);
  const weekRefs = useRef<Map<number, HTMLDivElement>>(new Map());
  const stickyThreshold = 104;

  const weekStats = useMemo(() => {
    const stats: Record<number, { total: number; completed: number }> = {};
    if (!weeks) return stats;
    weeks.forEach((weekData) => {
      stats[weekData.week] = {
        total: weekData.workouts.length,
        completed: weekData.workouts.filter((w) => completedWorkouts.has(w.id)).length,
      };
    });
    return stats;
  }, [weeks, completedWorkouts]);

  const handleScroll = useCallback(() => {
    let currentWeek: WeekData | null = null;
    
    for (const weekData of weeks) {
      const element = weekRefs.current.get(weekData.week);
      if (!element) continue;
      
      const rect = element.getBoundingClientRect();
      if (rect.top <= stickyThreshold && rect.bottom > stickyThreshold + 50) {
        currentWeek = weekData;
      }
    }
    
    setStickyWeek(currentWeek);
  }, [weeks, stickyThreshold]);

  useEffect(() => {
    window.addEventListener('scroll', handleScroll, { passive: true });
    handleScroll();
    return () => window.removeEventListener('scroll', handleScroll);
  }, [handleScroll]);

  if (!weeks || weeks.length === 0) {
    return <div className="text-center py-8 text-muted-foreground">{t.noWorkouts}</div>;
  }

  const toggleWeek = (week: number) => {
    const newCollapsed = new Set(collapsedWeeks);
    if (newCollapsed.has(week)) {
      newCollapsed.delete(week);
    } else {
      newCollapsed.add(week);
    }
    setCollapsedWeeks(newCollapsed);
  };

  const stickyWeekStats = stickyWeek ? weekStats[stickyWeek.week] : null;
  const isStickyWeekComplete = stickyWeekStats ? stickyWeekStats.completed === stickyWeekStats.total : false;

  return (
    <div className="space-y-4 relative">
      <div 
        className={cn(
          "fixed top-[104px] left-0 right-0 z-30 border-b shadow-sm transition-opacity duration-200",
          stickyWeek ? "opacity-100" : "opacity-0 pointer-events-none",
          stickyWeek && isStickyWeekComplete ? "bg-[#FFE100]" : "bg-card"
        )}
        data-testid="sticky-week-header"
      >
        <div className="max-w-6xl mx-auto px-8 py-3">
          <div className="flex items-center justify-between gap-2">
            <div className="flex items-center gap-2 shrink-0">
              <ChevronUp className={cn("w-4 h-4 shrink-0", stickyWeek && isStickyWeekComplete ? "text-black" : "text-muted-foreground")} />
              <span className={cn("font-semibold whitespace-nowrap", stickyWeek && isStickyWeekComplete && "text-black")}>
                {t.week} {stickyWeek?.week}
              </span>
              {isStickyWeekComplete && (
                <Badge className="bg-green-100 text-green-700 dark:bg-green-900 dark:text-green-300 no-default-hover-elevate no-default-active-elevate">
                  <Check className="w-3 h-3 mr-1" />
                  {t.complete}
                </Badge>
              )}
            </div>
            <span
              className={cn(
                "text-sm text-right",
                isStickyWeekComplete ? "text-black/70" : "text-muted-foreground"
              )}
            >
              {stickyWeek?.focus}
            </span>
          </div>
        </div>
      </div>

      {weeks.map((weekData) => {
        const isCollapsed = collapsedWeeks.has(weekData.week);
        const stats = weekStats[weekData.week];
        const isWeekComplete = stats.completed === stats.total;

        return (
          <div 
            key={weekData.week} 
            ref={(el) => { if (el) weekRefs.current.set(weekData.week, el); }}
          >
            <Card className="overflow-visible">
              <CardHeader
                className={cn(
                  "py-3 px-4 cursor-pointer select-none",
                  isWeekComplete ? "bg-[#FFE100]" : "bg-card"
                )}
                onClick={() => toggleWeek(weekData.week)}
                data-testid={`button-week-${weekData.week}`}
              >
                <div className="flex items-center justify-between gap-2">
                  <div className="flex items-center gap-2 shrink-0">
                    {isCollapsed ? (
                      <ChevronDown className={cn("w-4 h-4 shrink-0", isWeekComplete ? "text-black" : "text-muted-foreground")} />
                    ) : (
                      <ChevronUp className={cn("w-4 h-4 shrink-0", isWeekComplete ? "text-black" : "text-muted-foreground")} />
                    )}
                    <span className={cn("font-semibold whitespace-nowrap", isWeekComplete && "text-black")}>
                      {t.week} {weekData.week}
                    </span>
                    {isWeekComplete && (
                      <Badge className="bg-green-100 text-green-700 dark:bg-green-900 dark:text-green-300 no-default-hover-elevate no-default-active-elevate">
                        <Check className="w-3 h-3 mr-1" />
                        {t.complete}
                      </Badge>
                    )}
                  </div>
                  <span
                    className={cn(
                      "text-sm text-right",
                      isWeekComplete ? "text-black/70" : "text-muted-foreground"
                    )}
                  >
                    {weekData.focus}
                  </span>
                </div>
              </CardHeader>

              {!isCollapsed && (
                <CardContent className="p-0">
                  <div className="divide-y divide-border/50">
                    {weekData.workouts.map((workout) => {
                      const isCompleted = completedWorkouts.has(workout.id);
                      return (
                        <div
                          key={workout.id}
                          className={cn(
                            "flex items-start gap-3 py-4 px-4 transition-colors cursor-pointer",
                            isCompleted && "bg-green-50 dark:bg-green-950/20"
                          )}
                          onClick={() => onToggleWorkout(workout.id)}
                          data-testid={`row-workout-${workout.id}`}
                        >
                          <div className="flex items-start pt-0.5">
                            <Checkbox
                              checked={isCompleted}
                              onCheckedChange={() => onToggleWorkout(workout.id)}
                              onClick={(e) => e.stopPropagation()}
                              className={cn(
                                "w-5 h-5 rounded border-2",
                                isCompleted
                                  ? "bg-[#FFE100] border-[#FFE100] data-[state=checked]:bg-[#FFE100] data-[state=checked]:text-black"
                                  : "border-muted-foreground/30"
                              )}
                              data-testid={`checkbox-workout-${workout.id}`}
                            />
                          </div>
                          <div className="flex-1 min-w-0 space-y-1">
                            <div className="flex flex-wrap items-center gap-2">
                              <span
                                className={cn(
                                  "font-medium text-sm",
                                  isCompleted && "line-through text-muted-foreground"
                                )}
                              >
                                {workout.day}
                              </span>
                              <Badge
                                variant="secondary"
                                className={cn(
                                  "text-xs font-medium px-2 py-0.5 no-default-hover-elevate no-default-active-elevate",
                                  getWorkoutTypeColor(workout.type)
                                )}
                              >
                                {getBadgeText(workout)}
                              </Badge>
                            </div>
                            <p
                              className={cn(
                                "text-sm whitespace-pre-wrap",
                                isCompleted
                                  ? "text-muted-foreground line-through"
                                  : "text-muted-foreground"
                              )}
                            >
                              {formatDescription(workout.description, isCompleted, distanceUnit)}
                            </p>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </CardContent>
              )}
            </Card>
          </div>
        );
      })}
    </div>
  );
}
