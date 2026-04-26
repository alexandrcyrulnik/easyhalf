import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent } from "@/components/ui/card";

export default function TrialPage() {
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setMessage("");
    try {
      const res = await fetch("/api/trial/access", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email: email.trim().toLowerCase() }),
      });
      const data = await res.json();
      if (res.ok) {
        setMessage("Trial access is not configured in this build. Contact support for your plan link.");
      } else {
        setMessage(data.error || "Trial not found. Complete the quiz on the main site first.");
      }
    } catch {
      setMessage("Trial access is not configured. Contact support for your plan link.");
    }
  };

  return (
    <div className="min-h-screen bg-background flex flex-col">
      <header className="bg-black text-white py-6 px-4">
        <div className="max-w-4xl mx-auto text-center">
          <img
            src="/EH%20new%20logo.jpeg"
            alt="EasyHalf"
            className="h-12 mx-auto object-contain"
            onError={(e) => {
              e.currentTarget.onerror = null;
              e.currentTarget.src = "/favicon/favicon.svg";
            }}
          />
          <p className="text-muted-foreground mt-2 text-sm">Trial access</p>
        </div>
      </header>
      <main className="flex-1 flex items-center justify-center p-4">
        <Card className="w-full max-w-md">
          <CardContent className="pt-6">
            <form onSubmit={handleSubmit} className="space-y-4">
              <label className="text-sm font-medium">Email</label>
              <Input
                type="email"
                placeholder="Your email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
              <Button type="submit" className="w-full bg-[#FFE100] text-black hover:bg-[#FFE100]/90">
                Get trial access
              </Button>
            </form>
            {message && <p className="mt-4 text-sm text-muted-foreground">{message}</p>}
            <p className="mt-4 text-xs text-muted-foreground">
              <a href="https://easyhalf.tilda.ws/#form" className="underline hover:text-foreground">Contact us</a> if you need help.
            </p>
          </CardContent>
        </Card>
      </main>
    </div>
  );
}
