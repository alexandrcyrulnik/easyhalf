import { useState, useEffect, useMemo } from "react";
import { useQuery } from "@tanstack/react-query";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { Skeleton } from "@/components/ui/skeleton";
import { LogOut, BookOpen, Calendar, Dumbbell } from "lucide-react";
import type { PlanType, TrainingPlan, IntroductionContent } from "@shared/schema";
import { getCompletedWorkouts, toggleWorkoutComplete, clearSelectedPlan, type Language } from "@/lib/localStorage";
import TrainingPlanTable from "@/components/training-plan-table";
import IntroductionView from "@/components/introduction-view";

interface DashboardProps {
  selectedPlan: PlanType;
  onChangePlan: () => void;
  language: Language;
  onToggleLanguage: () => void;
}

export default function Dashboard({ selectedPlan, onChangePlan, language, onToggleLanguage }: DashboardProps) {
  const [completedWorkouts, setCompletedWorkouts] = useState<Set<string>>(new Set());
  const [activeTab, setActiveTab] = useState("plan");

  useEffect(() => {
    setCompletedWorkouts(getCompletedWorkouts());
  }, []);

  const langSuffix = language === "ru" ? "?lang=ru" : "";

  const { data: plan, isLoading: planLoading } = useQuery<TrainingPlan>({
    queryKey: ["/api/plans", selectedPlan + langSuffix],
  });

  const { data: guide, isLoading: guideLoading } = useQuery<IntroductionContent>({
    queryKey: ["/api/guide" + langSuffix],
  });

  const { data: strengthConditioning, isLoading: scLoading } = useQuery<IntroductionContent>({
    queryKey: ["/api/strength-conditioning" + langSuffix],
  });

  const handleToggleWorkout = (workoutId: string) => {
    const updated = toggleWorkoutComplete(workoutId);
    setCompletedWorkouts(new Set(updated));
  };

  const handleChangePlan = () => {
    const msg = language === "ru"
      ? "Сменить план? Прогресс этого плана будет сброшен."
      : "Change plan? Progress for this plan will be reset.";
    if (confirm(msg)) {
      clearSelectedPlan();
      onChangePlan();
    }
  };

  const totalWorkouts = useMemo(() => {
    if (!plan) return 0;
    return plan.weeks.reduce((sum, week) => sum + week.workouts.length, 0);
  }, [plan]);

  const completedCount = useMemo(() => {
    if (!plan) return 0;
    return plan.weeks.reduce((sum, week) => {
      return sum + week.workouts.filter((w) => completedWorkouts.has(w.id)).length;
    }, 0);
  }, [plan, completedWorkouts]);

  const progressPercentage = useMemo(() => {
    if (totalWorkouts === 0) return 0;
    return Math.round((completedCount / totalWorkouts) * 100);
  }, [totalWorkouts, completedCount]);

  const goalTimeFormatted = useMemo(() => {
    if (!plan) return "";
    const parts = plan.goalTime.split(":");
    if (parts.length === 2) {
      return language === "ru"
        ? `${parts[0]} ч ${parts[1]} мин`
        : `${parts[0]} hour ${parts[1]} minutes`;
    }
    return plan.goalTime;
  }, [plan, language]);

  return (
    <div className="min-h-screen bg-background flex flex-col">
      <header className="bg-black text-white sticky top-0 z-50">
        <div className="max-w-6xl mx-auto px-4 py-4 flex items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <img
              src="/EH%20new%20logo.jpeg"
              alt="EasyHalf"
              className="h-8 w-auto object-contain"
              onError={(e) => {
                e.currentTarget.onerror = null;
                e.currentTarget.src = "/favicon/favicon.svg";
              }}
            />
            <div
              className="flex items-center bg-white/10 rounded-full p-0.5 cursor-pointer"
              onClick={onToggleLanguage}
              data-testid="button-toggle-language"
            >
              <span
                className={`text-xs font-medium px-2 py-1 rounded-full transition-colors ${
                  language === "en" ? "bg-[#FFE100] text-black" : "text-white/70"
                }`}
              >
                EN
              </span>
              <span
                className={`text-xs font-medium px-2 py-1 rounded-full transition-colors ${
                  language === "ru" ? "bg-[#FFE100] text-black" : "text-white/70"
                }`}
              >
                RU
              </span>
            </div>
          </div>
          <div className="flex items-center gap-4">
            {plan && (
              <span className="text-sm text-white/70" data-testid="text-header-info">
                {plan.goalTime} | {plan.totalWeeks} weeks
              </span>
            )}
            <Button
              variant="ghost"
              size="sm"
              onClick={handleChangePlan}
              className="text-white hover:text-white hover:bg-white/10"
              data-testid="button-change-plan"
            >
              <LogOut className="w-4 h-4 mr-2" />
              <span className="hidden sm:inline">{language === "ru" ? "Планы" : "Plans"}</span>
            </Button>
          </div>
        </div>
      </header>

      <Tabs value={activeTab} onValueChange={setActiveTab} className="flex-1 flex flex-col">
        <div className="bg-background sticky top-[56px] z-40">
          <div className="max-w-6xl mx-auto px-4 overflow-x-auto scrollbar-hide">
            <TabsList className="w-max justify-start bg-transparent h-auto p-0 gap-8 relative after:absolute after:bottom-0 after:left-0 after:right-0 after:h-px after:bg-border after:z-0 after:content-[''] after:w-[200vw] after:-translate-x-1/2">
              <TabsTrigger
                value="plan"
                className="py-3 px-0 rounded-none whitespace-nowrap bg-transparent shadow-none relative data-[state=active]:bg-transparent data-[state=active]:shadow-none data-[state=active]:after:absolute data-[state=active]:after:bottom-0 data-[state=active]:after:left-0 data-[state=active]:after:right-0 data-[state=active]:after:h-[2px] data-[state=active]:after:bg-[#FFE100] data-[state=active]:after:z-10 data-[state=active]:after:content-['']"
                data-testid="tab-training-plan"
              >
                <Calendar className="w-4 h-4 mr-2 shrink-0" />
                {language === "ru" ? "План" : "Training Plan"}
              </TabsTrigger>
              <TabsTrigger
                value="sc"
                className="py-3 px-0 rounded-none whitespace-nowrap bg-transparent shadow-none relative data-[state=active]:bg-transparent data-[state=active]:shadow-none data-[state=active]:after:absolute data-[state=active]:after:bottom-0 data-[state=active]:after:left-0 data-[state=active]:after:right-0 data-[state=active]:after:h-[2px] data-[state=active]:after:bg-[#FFE100] data-[state=active]:after:z-10 data-[state=active]:after:content-['']"
                data-testid="tab-sc"
              >
                <Dumbbell className="w-4 h-4 mr-2 shrink-0" />
                {language === "ru" ? "ОФП" : "S&C"}
              </TabsTrigger>
              <TabsTrigger
                value="guide"
                className="py-3 px-0 rounded-none whitespace-nowrap bg-transparent shadow-none relative data-[state=active]:bg-transparent data-[state=active]:shadow-none data-[state=active]:after:absolute data-[state=active]:after:bottom-0 data-[state=active]:after:left-0 data-[state=active]:after:right-0 data-[state=active]:after:h-[2px] data-[state=active]:after:bg-[#FFE100] data-[state=active]:after:z-10 data-[state=active]:after:content-['']"
                data-testid="tab-guide"
              >
                <BookOpen className="w-4 h-4 mr-2 shrink-0" />
                {language === "ru" ? "Гайд" : "Guide"}
              </TabsTrigger>
            </TabsList>
          </div>
        </div>

        <TabsContent value="plan" className="flex-1 mt-0">
          <div className="max-w-6xl mx-auto px-4 py-6">
            <div className="mb-6">
              {planLoading ? (
                <>
                  <Skeleton className="h-8 w-48 mb-2" />
                  <Skeleton className="h-5 w-32" />
                </>
              ) : (
                <>
                  <h2 className="text-2xl font-bold" data-testid="text-plan-title">
                    {language === "ru" ? "Полумарафон" : "Half Marathon"} {plan?.goalTime || ""}
                  </h2>
                  <p className="text-muted-foreground" data-testid="text-plan-subtitle">
                    {language === "ru" ? "Цель" : "Target"}: {goalTimeFormatted} | {plan?.totalWeeks || 0} {language === "ru" ? "нед." : "weeks"}
                  </p>
                </>
              )}
            </div>

            <div className="mb-6">
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm font-medium" data-testid="text-progress">
                  {completedCount}/{totalWorkouts} {language === "ru" ? "дней" : "days"} ({progressPercentage}%)
                </span>
                <span className="text-base" data-testid="icon-finish-flag">🏁</span>
              </div>
              <Progress value={progressPercentage} className="h-2" />
            </div>

            {planLoading ? (
              <div className="space-y-4">
                <Skeleton className="h-12 w-full" />
                {Array.from({ length: 10 }).map((_, i) => (
                  <Skeleton key={i} className="h-16 w-full" />
                ))}
              </div>
            ) : plan ? (
              <TrainingPlanTable
                weeks={plan.weeks}
                completedWorkouts={completedWorkouts}
                onToggleWorkout={handleToggleWorkout}
                language={language}
              />
            ) : (
              <div className="text-center py-12 text-muted-foreground">
                Failed to load training plan
              </div>
            )}
          </div>
        </TabsContent>

        <TabsContent value="guide" className="flex-1 mt-0">
          <div className="max-w-4xl mx-auto px-4 py-6">
            {guideLoading ? (
              <div className="space-y-4">
                {Array.from({ length: 5 }).map((_, i) => (
                  <Skeleton key={i} className="h-24 w-full" />
                ))}
              </div>
            ) : guide ? (
              <IntroductionView sections={guide.sections} />
            ) : (
              <div className="text-center py-12 text-muted-foreground">
                Failed to load guide
              </div>
            )}
          </div>
        </TabsContent>

        <TabsContent value="sc" className="flex-1 mt-0">
          <div className="max-w-4xl mx-auto px-4 py-6">
            <div className="mb-6">
              <h2 className="text-2xl font-bold" data-testid="text-sc-title">
                {language === "ru" ? "Силовая и общефизическая подготовка" : "Strength and Conditioning"}
              </h2>
              <p className="text-muted-foreground" data-testid="text-sc-description">
                {language === "ru"
                  ? "Для улучшения силы, координации, устойчивости к травмам и эффективности бега."
                  : "To improve strength, coordination, injury resistance, and running efficiency."}
              </p>
            </div>
            {scLoading ? (
              <div className="space-y-4">
                {Array.from({ length: 5 }).map((_, i) => (
                  <Skeleton key={i} className="h-24 w-full" />
                ))}
              </div>
            ) : strengthConditioning ? (
              <IntroductionView sections={strengthConditioning.sections} hideHeader />
            ) : (
              <div className="text-center py-12 text-muted-foreground">
                Failed to load strength & conditioning
              </div>
            )}
          </div>
        </TabsContent>
      </Tabs>
    </div>
  );
}
