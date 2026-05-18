import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import API from "@/services/api";
import { Zap, Eye, EyeOff } from "lucide-react";
import { useToast } from "@/hooks/use-toast";

export default function LoginPage() {
  const savedPassword =
    localStorage.getItem("adminPassword") || "admin123";

  const [email, setEmail] = useState("admin@admin.com");
  const [password, setPassword] = useState("");
  const [showPw, setShowPw] = useState(false);
  const [loading, setLoading] = useState(false);

  const { login } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!email || !password) {
      toast({
        title: "Please fill in all fields",
        variant: "destructive",
      });
      return;
    }

    // local password check
    if (email === "admin@admin.com" && password !== savedPassword) {
      toast({
        title: "Invalid password",
        variant: "destructive",
      });
      return;
    }

    setLoading(true);

    try {
      const res = await API.post("/admin/login", {
        email,
        password: "admin123", // backend same rahega
      });

      login(res.data.token, res.data.admin);

      toast({
        title: "Welcome back!",
      });

      navigate("/dashboard");
    } catch (err: any) {
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
        <form
          onSubmit={handleSubmit}
          className="bg-card rounded-2xl p-8 border space-y-5"
        >
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Email"
            className="w-full border p-2"
          />

          <div className="relative">
            <input
              type={showPw ? "text" : "password"}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Password"
              className="w-full border p-2 pr-10"
            />

            <button
              type="button"
              onClick={() => setShowPw(!showPw)}
              className="absolute right-2 top-2"
            >
              {showPw ? <EyeOff size={18} /> : <Eye size={18} />}
            </button>
          </div>

          <button
            type="submit"
            className="w-full bg-black text-white p-2 rounded"
          >
            {loading ? "Signing in..." : "Sign In"}
          </button>
        </form>
      </div>
    </div>
  );
}