import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Input } from "@/components/ui/input";
import { Zap, Rocket, Timer, Copy, Check, Calculator, FileText, Plus, Trash2, RefreshCw, Mail } from "lucide-react";
import { useState, useEffect } from "react";
import type { PlanType } from "@shared/schema";
import { recommendPlan, type PlanRecommendation } from "@/lib/recommendPlan";
import { getPlanAccessEmail, paymentEmail } from "@/lib/emailTemplates";

interface CustomerToken {
  token: string;
  planType: string;
  used: boolean;
  createdAt: string;
  usedAt: string | null;
}

const plans: { id: PlanType; name: string; icon: typeof Zap; emoji: string; description: string }[] = [
  { id: "1:30", name: "1:30", icon: Zap, emoji: "⚡️", description: "For experienced runners aiming for a fast finish" },
  { id: "1:45", name: "1:45", icon: Zap, emoji: "⚡️", description: "For intermediate runners looking to improve" },
  { id: "2:00", name: "2:00", icon: Rocket, emoji: "🚀", description: "For beginners or those targeting a steady pace" },
];

const experienceOptions = ["< 6 months", "6–12 months", "1–2 years", "2+ years"];
const weeklyDistanceOptions = ["Up to 10 km", "10–20 km", "20–40 km", "40+ km"];
const paceOptions = ["Slower than 6:30 / km", "5:30–6:30 / km", "4:30–5:30 / km", "Faster than 4:30 / km"];
const longestRunOptions = ["5 km", "10 km", "15 km", "20+ km"];
const goalOptions = ["~2:00 hours", "~1:45 hours", "~1:30 hours"];

export default function AdminPlanSelection() {
  const [copiedToken, setCopiedToken] = useState<string | null>(null);
  const [experience, setExperience] = useState("");
  const [weeklyDistance, setWeeklyDistance] = useState("");
  const [currentPace, setCurrentPace] = useState("");
  const [longestRun, setLongestRun] = useState("");
  const [goal, setGoal] = useState("");
  const [recommendation, setRecommendation] = useState<PlanRecommendation | null>(null);
  const [quickText, setQuickText] = useState("");
  const [tokens, setTokens] = useState<CustomerToken[]>([]);
  const [isLoadingTokens, setIsLoadingTokens] = useState(false);
  const [isGenerating, setIsGenerating] = useState(false);
  const [selectedPlanForToken, setSelectedPlanForToken] = useState<PlanType>("2:00");
  const [lastGeneratedUrl, setLastGeneratedUrl] = useState<string | null>(null);
  const [copiedEmail, setCopiedEmail] = useState<string | null>(null);

  const copyToClipboard = async (text: string): Promise<boolean> => {
    try {
      await navigator.clipboard.writeText(text);
      return true;
    } catch {
      try {
        const textarea = document.createElement("textarea");
        textarea.value = text;
        textarea.style.position = "fixed";
        textarea.style.opacity = "0";
        document.body.appendChild(textarea);
        textarea.select();
        document.execCommand("copy");
        document.body.removeChild(textarea);
        return true;
      } catch {
        return false;
      }
    }
  };

  const copyEmailPart = async (key: string, content: string) => {
    await copyToClipboard(content);
    setCopiedEmail(key);
    setTimeout(() => setCopiedEmail(null), 2000);
  };

  const fetchTokens = async () => {
    setIsLoadingTokens(true);
    try {
      const res = await fetch("/api/tokens");
      if (res.ok) {
        const data = await res.json();
        setTokens(data);
      }
    } catch (error) {
      console.error("Failed to fetch tokens:", error);
    }
    setIsLoadingTokens(false);
  };

  useEffect(() => {
    fetchTokens();
  }, []);

  const generateToken = async (planType: PlanType) => {
    setIsGenerating(true);
    try {
      const res = await fetch("/api/tokens/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ planType }),
      });
      if (res.ok) {
        const data = await res.json();
        const url = data.url || getFullUrl(data.token);
        setLastGeneratedUrl(url);
        handleCopyLink(data.token);
        fetchTokens();
      }
    } catch (error) {
      console.error("Failed to generate token:", error);
    }
    setIsGenerating(false);
  };

  const deleteToken = async (token: string) => {
    try {
      const res = await fetch(`/api/tokens/${token}`, { method: "DELETE" });
      if (res.ok) fetchTokens();
    } catch (error) {
      console.error("Failed to delete token:", error);
    }
  };

  const cleanupUsedTokens = async () => {
    const usedTokens = tokens.filter((t) => t.used);
    if (usedTokens.length === 0) return;
    setIsLoadingTokens(true);
    try {
      await Promise.all(usedTokens.map((t) => fetch(`/api/tokens/${t.token}`, { method: "DELETE" })));
      fetchTokens();
    } catch (error) {
      console.error("Failed to cleanup tokens:", error);
      setIsLoadingTokens(false);
    }
  };

  const getFullUrl = (token: string) => `${window.location.origin}/?token=${token}`;

  const handleCopyLink = async (token: string) => {
    await copyToClipboard(getFullUrl(token));
    setCopiedToken(token);
    setTimeout(() => setCopiedToken(null), 2000);
  };

  const handleRecommend = () => {
    const result = recommendPlan({
      experience,
      weekly_distance: weeklyDistance,
      current_pace: currentPace,
      longest_run: longestRun,
      goal,
    });
    setRecommendation(result);
  };

  const handleQuickRecommend = () => {
    let parts = quickText.split("\t").map((p) => p.trim()).filter(Boolean);
    if (parts.length < 5) {
      parts = quickText.split(/\s{2,}/).map((p) => p.trim()).filter(Boolean);
    }
    if (parts.length >= 5) {
      const result = recommendPlan({
        experience: parts[0],
        weekly_distance: parts[1],
        current_pace: parts[2],
        longest_run: parts[3],
        goal: parts[4],
      });
      setRecommendation(result);
    }
  };

  const generateRecommendedToken = async () => {
    if (recommendation) {
      await generateToken(recommendation.plan as PlanType);
    }
  };

  const isFormComplete = experience && weeklyDistance && currentPace && longestRun && goal;

  const getPlanEmoji = (planType: string) => {
    switch (planType) {
      case "1:30": return "⚡️";
      case "1:45": return "⚡️";
      case "2:00": return "🚀";
      default: return "";
    }
  };

  return (
    <div className="min-h-screen bg-background flex flex-col">
      <header className="bg-black text-white py-6 px-4">
        <div className="max-w-4xl mx-auto text-center">
          <img
            src="/EH%20new%20logo.jpeg"
            alt="EasyHalf"
            className="h-16 mx-auto object-contain"
            onError={(e) => {
              e.currentTarget.onerror = null;
              e.currentTarget.src = "/favicon/favicon.svg";
            }}
          />
          <p className="text-muted-foreground mt-2 text-sm md:text-base">Admin - Training Plan Links</p>
        </div>
      </header>

      <main className="flex-1 flex flex-col items-center p-4 md:p-8">
        <div className="max-w-4xl w-full space-y-12">
          <Card className="border-2 border-[#FFE100]">
            <CardHeader className="text-center pb-4">
              <div className="mx-auto mb-2 w-12 h-12 rounded-full bg-[#FFE100] flex items-center justify-center">
                <Calculator className="w-6 h-6 text-black" />
              </div>
              <CardTitle className="text-xl font-bold">Plan Recommender</CardTitle>
              <CardDescription>Enter customer answers to get a plan recommendation</CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="space-y-2">
                <label className="text-sm font-medium flex items-center gap-2">
                  <FileText className="w-4 h-4" />
                  Quick Paste (tab-separated)
                </label>
                <div className="flex gap-2">
                  <Input
                    placeholder="Paste: experience ⇥ distance ⇥ pace ⇥ longest run ⇥ goal"
                    value={quickText}
                    onChange={(e) => setQuickText(e.target.value)}
                    className="flex-1"
                  />
                  <Button
                    onClick={handleQuickRecommend}
                    disabled={quickText.trim().length < 10}
                    className="bg-[#FFE100] text-black hover:bg-[#FFE100]/90"
                  >
                    Get Plan
                  </Button>
                </div>
                <p className="text-xs text-muted-foreground">
                  Example: 6–12 months⇥40+ km⇥4:30–5:30/km⇥20+ km⇥~1:30 hours
                </p>
              </div>

              <div className="relative">
                <div className="absolute inset-0 flex items-center">
                  <span className="w-full border-t" />
                </div>
                <div className="relative flex justify-center text-xs uppercase">
                  <span className="bg-background px-2 text-muted-foreground">Or use dropdowns</span>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {[
                  { label: "Experience", value: experience, set: setExperience, options: experienceOptions },
                  { label: "Weekly Distance", value: weeklyDistance, set: setWeeklyDistance, options: weeklyDistanceOptions },
                  { label: "Current Pace", value: currentPace, set: setCurrentPace, options: paceOptions },
                  { label: "Longest Run", value: longestRun, set: setLongestRun, options: longestRunOptions },
                  { label: "Goal Time", value: goal, set: setGoal, options: goalOptions },
                ].map(({ label, value, set, options }) => (
                  <div key={label} className="space-y-2">
                    <label className="text-sm font-medium">{label}</label>
                    <Select value={value} onValueChange={set}>
                      <SelectTrigger>
                        <SelectValue placeholder={`Select ${label.toLowerCase()}`} />
                      </SelectTrigger>
                      <SelectContent>
                        {options.map((opt) => (
                          <SelectItem key={opt} value={opt}>{opt}</SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>
                ))}
                <div className="flex items-end">
                  <Button
                    onClick={handleRecommend}
                    disabled={!isFormComplete}
                    className="w-full bg-[#FFE100] text-black hover:bg-[#FFE100]/90"
                  >
                    Get Recommendation
                  </Button>
                </div>
              </div>

              {recommendation && (
                <div className="mt-6 p-4 bg-green-50 border border-green-200 rounded-lg">
                  <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                    <div>
                      <div className="flex items-center gap-3">
                        <p className="text-lg font-bold text-green-800">Recommended Plan: {recommendation.plan}</p>
                        <span
                          className={`text-xs font-medium px-2 py-1 rounded ${
                            recommendation.calculationType === "Automatic" ? "bg-blue-100 text-blue-700" : "bg-orange-100 text-orange-700"
                          }`}
                        >
                          {recommendation.calculationType} calculation
                        </span>
                      </div>
                      <p className="text-sm text-green-600">
                        Level {recommendation.level} (Scores: A={recommendation.scores.A}, B={recommendation.scores.B}, C={recommendation.scores.C})
                      </p>
                    </div>
                    <Button
                      onClick={generateRecommendedToken}
                      disabled={isGenerating}
                      className="bg-green-600 text-white hover:bg-green-700"
                    >
                      {isGenerating ? (
                        <>
                          <RefreshCw className="w-4 h-4 mr-2 animate-spin" />
                          Generating...
                        </>
                      ) : (
                        <>
                          <Plus className="w-4 h-4 mr-2" />
                          Generate Link for {recommendation.plan}
                        </>
                      )}
                    </Button>
                  </div>
                </div>
              )}
            </CardContent>
          </Card>

          <Card className="border-2 border-[#FFE100]">
            <CardHeader className="text-center pb-4">
              <div className="mx-auto mb-2 w-12 h-12 rounded-full bg-[#FFE100] flex items-center justify-center">
                <Plus className="w-6 h-6 text-black" />
              </div>
              <CardTitle className="text-xl font-bold">Generate Customer Link</CardTitle>
              <CardDescription>Create a unique one-time link for a customer</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="flex flex-col sm:flex-row gap-4 items-center justify-center">
                <Select value={selectedPlanForToken} onValueChange={(v) => setSelectedPlanForToken(v as PlanType)}>
                  <SelectTrigger className="w-48">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {plans.map((plan) => (
                      <SelectItem key={plan.id} value={plan.id}>
                        {plan.name} {plan.emoji}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                <Button
                  onClick={() => generateToken(selectedPlanForToken)}
                  disabled={isGenerating}
                  className="bg-[#FFE100] text-black hover:bg-[#FFE100]/90"
                >
                  {isGenerating ? (
                    <>
                      <RefreshCw className="w-4 h-4 mr-2 animate-spin" />
                      Generating...
                    </>
                  ) : (
                    <>
                      <Plus className="w-4 h-4 mr-2" />
                      Generate & Copy Link
                    </>
                  )}
                </Button>
              </div>
              {lastGeneratedUrl && (
                <div className="mt-4 p-3 bg-green-50 border border-green-200 rounded-lg">
                  <p className="text-sm text-green-800 font-medium mb-2">Link generated and copied to clipboard!</p>
                  <div className="flex items-center gap-2">
                    <input
                      type="text"
                      readOnly
                      value={lastGeneratedUrl}
                      className="flex-1 p-2 text-sm bg-white border rounded font-mono"
                      onClick={(e) => (e.target as HTMLInputElement).select()}
                    />
                    <Button
                      size="sm"
                      variant="outline"
                      onClick={() => handleCopyLink(lastGeneratedUrl.split("?token=")[1] || "")}
                    >
                      {copiedToken === lastGeneratedUrl.split("?token=")[1] ? <Check className="w-4 h-4" /> : <Copy className="w-4 h-4" />}
                    </Button>
                  </div>
                </div>
              )}
            </CardContent>
          </Card>
        </div>

        <div className="text-center mb-12 mt-16 max-w-4xl w-full">
          <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-[#FFE100] mb-4">
            <Mail className="w-8 h-8 text-black" />
          </div>
          <h2 className="text-2xl md:text-3xl font-bold text-foreground mb-2">Email Templates</h2>
          <p className="text-muted-foreground max-w-md mx-auto mb-6">Copy email subject and body to send to customers</p>
          <div className="grid gap-4 max-w-2xl mx-auto">
            <Card className="border-2 border-[#FFE100]">
              <CardContent className="p-4">
                <div className="flex items-center justify-between flex-wrap gap-3">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-[#FFE100] flex items-center justify-center">
                      <Rocket className="w-5 h-5 text-black" />
                    </div>
                    <div className="text-left">
                      <p className="font-medium">Plan Access Email</p>
                      <p className="text-sm text-muted-foreground">
                        {lastGeneratedUrl ? `Link: ${lastGeneratedUrl.split("?token=")[1]}` : "Uses last generated link"}
                      </p>
                    </div>
                  </div>
                  <div className="flex gap-2">
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => copyEmailPart("plan-subject", getPlanAccessEmail(selectedPlanForToken).subject)}
                    >
                      {copiedEmail === "plan-subject" ? <><Check className="w-4 h-4 mr-1" /> Copied</> : <><Copy className="w-4 h-4 mr-1" /> Subject</>}
                    </Button>
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() =>
                        copyEmailPart(
                          "plan-body",
                          getPlanAccessEmail(selectedPlanForToken).getBody(lastGeneratedUrl || `${window.location.origin}/?token=YOUR_TOKEN`)
                        )
                      }
                    >
                      {copiedEmail === "plan-body" ? <><Check className="w-4 h-4 mr-1" /> Copied</> : <><Copy className="w-4 h-4 mr-1" /> Body</>}
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
            <Card className="border border-orange-200 bg-orange-50">
              <CardContent className="p-4">
                <div className="flex items-center justify-between flex-wrap gap-3">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-orange-400 flex items-center justify-center text-white font-bold text-xs">$</div>
                    <div className="text-left">
                      <p className="font-medium">Payment Link Email</p>
                      <p className="text-sm text-muted-foreground">When plan was not identified</p>
                    </div>
                  </div>
                  <div className="flex gap-2">
                    <Button variant="outline" size="sm" onClick={() => copyEmailPart("payment-subject", paymentEmail.subject)}>
                      {copiedEmail === "payment-subject" ? <><Check className="w-4 h-4 mr-1" /> Copied</> : <><Copy className="w-4 h-4 mr-1" /> Subject</>}
                    </Button>
                    <Button variant="outline" size="sm" onClick={() => copyEmailPart("payment-body", paymentEmail.getBody())}>
                      {copiedEmail === "payment-body" ? <><Check className="w-4 h-4 mr-1" /> Copied</> : <><Copy className="w-4 h-4 mr-1" /> Body</>}
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>

        <div className="space-y-8 max-w-4xl w-full">
          <div className="text-center space-y-4">
            <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-[#FFE100] mb-4">
              <Timer className="w-8 h-8 text-black" />
            </div>
            <div className="flex items-center justify-center gap-4">
              <h2 className="text-2xl md:text-3xl font-bold text-foreground">Customer Links</h2>
              <Button
                variant="outline"
                size="sm"
                onClick={cleanupUsedTokens}
                disabled={isLoadingTokens || tokens.filter((t) => t.used).length === 0}
                title="Remove used links"
              >
                <Trash2 className="w-4 h-4" />
              </Button>
            </div>
            <p className="text-muted-foreground max-w-md mx-auto">
              {tokens.length} link{tokens.length !== 1 ? "s" : ""} generated. Each link can only be used once.
            </p>
          </div>
          {tokens.length === 0 ? (
            <Card className="p-8 text-center text-muted-foreground">No customer links generated yet. Use the form above to create one.</Card>
          ) : (
            <div className="space-y-3">
              {tokens.map((token) => (
                <Card
                  key={token.token}
                  className={`transition-all duration-200 ${token.used ? "opacity-60" : "hover:border-[#FFE100]"}`}
                >
                  <CardContent className="p-4">
                    <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                      <div className="flex-1">
                        <div className="flex items-center gap-3 flex-wrap">
                          <span className="text-lg font-bold">
                            {token.planType} {getPlanEmoji(token.planType)}
                          </span>
                          <code className="text-xs bg-muted px-2 py-1 rounded font-mono">{token.token}</code>
                          {token.used && (
                            <span className="text-xs bg-red-100 text-red-700 px-2 py-1 rounded">Used</span>
                          )}
                        </div>
                        <p className="text-xs text-muted-foreground mt-1">
                          Created: {new Date(token.createdAt).toLocaleDateString()}
                          {token.usedAt && ` • Used: ${new Date(token.usedAt).toLocaleDateString()}`}
                        </p>
                      </div>
                      <div className="flex gap-2">
                        <Button variant="outline" size="sm" onClick={() => handleCopyLink(token.token)}>
                          {copiedToken === token.token ? <><Check className="w-4 h-4 mr-1" /> Copied</> : <><Copy className="w-4 h-4 mr-1" /> Copy Link</>}
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => deleteToken(token.token)}
                          className="text-red-600 hover:text-red-700 hover:bg-red-50"
                        >
                          <Trash2 className="w-4 h-4" />
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          )}
        </div>
      </main>

      <footer className="bg-black text-white py-4 px-4">
        <div className="max-w-4xl mx-auto text-center">
          <a
            href="https://easyhalf.tilda.ws/#form"
            target="_blank"
            rel="noopener noreferrer"
            className="text-sm text-white/70 hover:text-[#FFE100] transition-colors"
          >
            Send Feedback
          </a>
        </div>
      </footer>
    </div>
  );
}
