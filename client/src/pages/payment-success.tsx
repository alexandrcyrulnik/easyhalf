import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { CheckCircle, Copy } from "lucide-react";

export default function PaymentSuccessPage() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [orderData, setOrderData] = useState<{ token: string; planType: string; url: string } | null>(null);
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const sessionId = params.get("session_id");
    if (!sessionId) {
      setError("No payment session found. If you just paid, check your email for your plan link.");
      setLoading(false);
      return;
    }
    const fetchOrder = async () => {
      try {
        const res = await fetch(`/api/payment/success/${sessionId}`);
        const data = await res.json();
        if (res.ok) {
          setOrderData(data);
        } else {
          setError(data.error || "Could not find your order. Payment may still be processing.");
        }
      } catch {
        setError("Connection error. Please refresh the page.");
      }
      setLoading(false);
    };
    fetchOrder();
  }, []);

  const handleCopy = async () => {
    if (!orderData?.url) return;
    await navigator.clipboard.writeText(orderData.url);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="animate-pulse text-muted-foreground">Loading...</div>
      </div>
    );
  }

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
          <p className="text-muted-foreground mt-2 text-sm">Payment</p>
        </div>
      </header>
      <main className="flex-1 flex items-center justify-center p-4">
        <Card className="w-full max-w-md">
          <CardContent className="pt-6">
            {error ? (
              <>
                <p className="text-destructive font-medium">{error}</p>
                <p className="mt-2 text-sm text-muted-foreground">
                  Payment success is not configured in this build, or the session was not found. Check your email for your plan link or{" "}
                  <a href="https://easyhalf.tilda.ws/#form" className="underline">contact us</a>.
                </p>
              </>
            ) : orderData ? (
              <>
                <div className="flex items-center gap-2 text-green-600 font-medium">
                  <CheckCircle className="w-5 h-5" />
                  Thank you for your purchase!
                </div>
                <p className="mt-2 text-sm text-muted-foreground">
                  Your plan ({orderData.planType}) is ready. Use the link below to access it.
                </p>
                <div className="mt-4 flex gap-2">
                  <input
                    type="text"
                    readOnly
                    value={orderData.url}
                    className="flex-1 p-2 text-sm bg-muted border rounded font-mono"
                  />
                  <Button variant="outline" size="sm" onClick={handleCopy}>
                    {copied ? <CheckCircle className="w-4 h-4" /> : <Copy className="w-4 h-4" />}
                  </Button>
                </div>
                <Button asChild className="mt-4 w-full bg-[#FFE100] text-black hover:bg-[#FFE100]/90">
                  <a href={orderData.url}>Go to my plan</a>
                </Button>
              </>
            ) : null}
          </CardContent>
        </Card>
      </main>
    </div>
  );
}
