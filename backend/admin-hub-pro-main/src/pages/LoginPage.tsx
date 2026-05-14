import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import API from "@/services/api";
import { Zap, Eye, EyeOff } from "lucide-react";
import { useToast } from "@/hooks/use-toast";

export default function LoginPage() {
  const [email, setEmail] = useState("admin@admin.com");
  const [password, setPassword] = useState("admin123");
  const [showPw, setShowPw] = useState(false);
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();

  const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault();

  if (!email || !password) {
    toast({ title: "Please fill in all fields", variant: "destructive" });
    return;
  }

  setLoading(true);

  try {
    const res = await API.post("/admin/login", {
      email,
      password,
    });

    console.log("LOGIN RES:", res.data); // debug

    login(res.data.token, res.data.admin);
    toast({ title: "Welcome back!" });
    navigate("/dashboard");
  } catch (err: any) {
    console.error("LOGIN ERROR:", err?.response || err);
    toast({
      title: err?.response?.data?.message || "Login failed",
      variant: "destructive",
    });
  } finally {
    setLoading(false);
  }
};

  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <div className="w-14 h-14 rounded-2xl stat-gradient-1 flex items-center justify-center mx-auto mb-4">
            <Zap className="w-7 h-7 text-primary-foreground" />
          </div>
          <h1 className="text-2xl font-bold text-foreground">Welcome back</h1>
          <p className="text-muted-foreground text-sm mt-1">
            Sign in to AdminPro dashboard
          </p>
        </div>

        <form
          onSubmit={handleSubmit}
          className="bg-card rounded-2xl p-8 card-shadow-lg border border-border space-y-5"
        >
          <div>
            <label className="text-sm font-medium text-foreground block mb-1.5">
              Email
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full px-4 py-2.5 rounded-lg border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring transition-shadow"
              placeholder="admin@admin.com"
            />
          </div>

          <div>
            <label className="text-sm font-medium text-foreground block mb-1.5">
              Password
            </label>
            <div className="relative">
              <input
                type={showPw ? "text" : "password"}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full px-4 py-2.5 rounded-lg border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring transition-shadow pr-10"
                placeholder="••••••••"
              />
              <button
                type="button"
                onClick={() => setShowPw((v) => !v)}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
              >
                {showPw ? (
                  <EyeOff className="w-4 h-4" />
                ) : (
                  <Eye className="w-4 h-4" />
                )}
              </button>
            </div>
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full py-2.5 rounded-lg bg-primary text-primary-foreground font-semibold text-sm hover:opacity-90 transition-opacity disabled:opacity-50"
          >
            {loading ? "Signing in..." : "Sign in"}
          </button>

          <p className="text-xs text-center text-muted-foreground">
            Demo: admin@admin.com / admin123
          </p>
        </form>
      </div>
    </div>
  );
}
