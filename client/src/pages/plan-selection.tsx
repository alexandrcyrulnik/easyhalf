import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Zap, Rocket, Timer, ChevronRight } from "lucide-react";
import type { PlanType } from "@shared/schema";
import type { Language } from "@/lib/localStorage";

interface PlanSelectionProps {
  onSelectPlan: (plan: PlanType) => void;
  language: Language;
  onToggleLanguage: () => void;
}

const plans: { id: PlanType; name: string; icon: typeof Zap; emoji: string; description: string; descriptionRu: string }[] = [
  {
    id: "1:30",
    name: "1:30",
    icon: Zap,
    emoji: "⚡️",
    description: "For experienced runners aiming for a fast finish",
    descriptionRu: "Для опытных бегунов, нацеленных на быстрый финиш",
  },
  {
    id: "1:45",
    name: "1:45",
    icon: Zap,
    emoji: "⚡️",
    description: "For intermediate runners looking to improve",
    descriptionRu: "Для бегунов среднего уровня, стремящихся к результату",
  },
  {
    id: "2:00",
    name: "2:00",
    icon: Rocket,
    emoji: "🚀",
    description: "For beginners or those targeting a steady pace",
    descriptionRu: "Для новичков или тех, кто хочет пробежать в спокойном темпе",
  },
];

export default function PlanSelection({ onSelectPlan, language, onToggleLanguage }: PlanSelectionProps) {
  return (
    <div className="min-h-screen bg-background flex flex-col">
      <header className="bg-black text-white py-6 px-4">
        <div className="max-w-4xl mx-auto flex flex-col items-center relative">
          <div
            className="absolute right-0 top-0 flex items-center bg-white/10 rounded-full p-0.5 cursor-pointer"
            onClick={onToggleLanguage}
            data-testid="button-toggle-language-selection"
          >
            <span className={`text-xs font-medium px-2 py-1 rounded-full transition-colors ${language === "en" ? "bg-[#FFE100] text-black" : "text-white/70"}`}>
              EN
            </span>
            <span className={`text-xs font-medium px-2 py-1 rounded-full transition-colors ${language === "ru" ? "bg-[#FFE100] text-black" : "text-white/70"}`}>
              RU
            </span>
          </div>
          <img
            src="/EH%20new%20logo.jpeg"
            alt="EasyHalf"
            className="h-12 md:h-14 w-auto object-contain"
            onError={(e) => {
              e.currentTarget.onerror = null;
              e.currentTarget.src = "/favicon/favicon.svg";
            }}
          />
          <p className="text-muted-foreground mt-3 text-sm md:text-base">
            {language === "ru" ? "Трекер тренировок к полумарафону" : "Half Marathon Training Tracker"}
          </p>
        </div>
      </header>

      <main className="flex-1 flex flex-col items-center justify-center p-4 md:p-8">
        <div className="max-w-4xl w-full space-y-8">
          <div className="text-center space-y-4">
            <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-[#FFE100] mb-4">
              <Timer className="w-8 h-8 text-black" />
            </div>
            <h2 className="text-2xl md:text-3xl font-bold text-foreground">
              {language === "ru" ? "Выберите план тренировок" : "Select Your Training Plan"}
            </h2>
            <p className="text-muted-foreground max-w-md mx-auto">
              {language === "ru" ? "Выберите план исходя из вашего целевого времени." : "Choose a plan based on your goal time."}
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 md:gap-6">
            {plans.map((plan) => {
              const Icon = plan.icon;
              return (
                <Card
                  key={plan.id}
                  className="group cursor-pointer transition-all duration-200 hover:border-[#FFE100] hover-elevate"
                  onClick={() => onSelectPlan(plan.id)}
                  data-testid={`card-plan-${plan.id}`}
                >
                  <CardHeader className="text-center pb-2">
                    <div className="mx-auto mb-2 w-12 h-12 rounded-full bg-[#FFE100] flex items-center justify-center">
                      <Icon className="w-6 h-6 text-black" />
                    </div>
                    <CardTitle className="text-4xl font-bold">
                      {plan.name} <span className="text-3xl">{plan.emoji}</span>
                    </CardTitle>
                    <CardDescription className="text-xs uppercase tracking-wider">
                      {language === "ru" ? "Целевое время" : "Goal Time"}
                    </CardDescription>
                  </CardHeader>
                  <CardContent className="text-center space-y-4">
                    <p className="text-sm text-muted-foreground">
                      {language === "ru" ? plan.descriptionRu : plan.description}
                    </p>
                    <Button
                      className="w-full bg-black text-white hover:bg-black/90"
                      data-testid={`button-select-plan-${plan.id}`}
                    >
                      {language === "ru" ? "Выбрать план" : "Select Plan"}
                      <ChevronRight className="w-4 h-4 ml-2" />
                    </Button>
                  </CardContent>
                </Card>
              );
            })}
          </div>
        </div>
      </main>
    </div>
  );
}
