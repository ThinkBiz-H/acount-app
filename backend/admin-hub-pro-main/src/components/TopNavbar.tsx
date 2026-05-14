import { useAuth } from "@/contexts/AuthContext";
import { useTheme } from "@/contexts/ThemeContext";
import { Moon, Sun, Bell } from "lucide-react";

export default function TopNavbar({ title }: { title: string }) {
  const { admin } = useAuth();
  const { isDark, toggle } = useTheme();

  return (
    <header className="h-16 border-b border-border bg-card flex items-center justify-between px-6 sticky top-0 z-30">
      <h1 className="text-lg font-semibold text-foreground">{title}</h1>

      <div className="flex items-center gap-3">
        <button
          onClick={toggle}
          className="p-2 rounded-lg hover:bg-secondary transition-colors text-muted-foreground hover:text-foreground"
        >
          {isDark ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
        </button>

        <button className="p-2 rounded-lg hover:bg-secondary transition-colors text-muted-foreground hover:text-foreground relative">
          <Bell className="w-5 h-5" />
          <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-destructive rounded-full" />
        </button>

        <div className="flex items-center gap-3 ml-2 pl-4 border-l border-border">
          <div className="w-8 h-8 rounded-full stat-gradient-1 flex items-center justify-center text-primary-foreground text-sm font-semibold">
            {admin?.name?.charAt(0) || "A"}
          </div>
          <div className="hidden sm:block">
            <p className="text-sm font-medium text-foreground leading-none">{admin?.name || "Admin"}</p>
            <p className="text-xs text-muted-foreground">{admin?.email || ""}</p>
          </div>
        </div>
      </div>
    </header>
  );
}
