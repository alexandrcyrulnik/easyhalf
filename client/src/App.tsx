import { useState } from "react";
import { queryClient } from "./lib/queryClient";
import { QueryClientProvider } from "@tanstack/react-query";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import PlanSelection from "@/pages/plan-selection";
import Dashboard from "@/pages/dashboard";
import { getSelectedPlan, setSelectedPlan, clearSelectedPlan, getLanguage, setLanguage, type Language } from "@/lib/localStorage";
import type { PlanType } from "@shared/schema";

function App() {
  const [selectedPlan, setSelectedPlanState] = useState<PlanType | null>(getSelectedPlan());
  const [language, setLanguageState] = useState<Language>(getLanguage());

  const handleSelectPlan = (plan: PlanType) => {
    setSelectedPlan(plan);
    setSelectedPlanState(plan);
  };

  const handleChangePlan = () => {
    clearSelectedPlan();
    setSelectedPlanState(null);
  };

  const handleToggleLanguage = () => {
    const newLang = language === "en" ? "ru" : "en";
    setLanguage(newLang);
    setLanguageState(newLang);
  };

  return (
    <QueryClientProvider client={queryClient}>
      <TooltipProvider>
        <Toaster />
        {selectedPlan ? (
          <Dashboard
            selectedPlan={selectedPlan}
            onChangePlan={handleChangePlan}
            language={language}
            onToggleLanguage={handleToggleLanguage}
          />
        ) : (
          <PlanSelection
            onSelectPlan={handleSelectPlan}
            language={language}
            onToggleLanguage={handleToggleLanguage}
          />
        )}
      </TooltipProvider>
    </QueryClientProvider>
  );
}

export default App;
