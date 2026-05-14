import { createContext, useContext, useState, useEffect, ReactNode } from "react";

interface Admin {
  name: string;
  email: string;
}

interface AuthContextType {
  isAuthenticated: boolean;
  admin: Admin | null;
  login: (token: string, admin: Admin) => void;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [admin, setAdmin] = useState<Admin | null>(null);

  useEffect(() => {
    const token = localStorage.getItem("admin_token");
    const stored = localStorage.getItem("admin_info");
    if (token && stored) {
      setIsAuthenticated(true);
      setAdmin(JSON.parse(stored));
    }
  }, []);

  const login = (token: string, adminInfo: Admin) => {
    localStorage.setItem("admin_token", token);
    localStorage.setItem("admin_info", JSON.stringify(adminInfo));
    setIsAuthenticated(true);
    setAdmin(adminInfo);
  };

  const logout = () => {
    localStorage.removeItem("admin_token");
    localStorage.removeItem("admin_info");
    setIsAuthenticated(false);
    setAdmin(null);
  };

  return (
    <AuthContext.Provider value={{ isAuthenticated, admin, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
};
