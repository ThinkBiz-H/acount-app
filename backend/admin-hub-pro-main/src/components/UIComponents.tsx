import { cn } from "@/lib/utils";

export function StatCard({
  title, value, icon, gradient, change,
}: {
  title: string;
  value: string | number;
  icon: React.ReactNode;
  gradient: string;
  change?: string;
}) {
  return (
    <div className="bg-card rounded-xl p-5 card-shadow border border-border hover:card-shadow-lg transition-shadow">
      <div className="flex items-start justify-between">
        <div>
          <p className="text-sm text-muted-foreground font-medium">{title}</p>
          <p className="text-2xl font-bold text-foreground mt-1">{value}</p>
          {change && (
            <p className="text-xs text-success font-medium mt-1">{change}</p>
          )}
        </div>
        <div className={cn("w-11 h-11 rounded-xl flex items-center justify-center", gradient)}>
          {icon}
        </div>
      </div>
    </div>
  );
}

export function StatusBadge({ status }: { status: string }) {
  const styles: Record<string, string> = {
    Active: "bg-success/10 text-success",
    Expired: "bg-warning/10 text-warning",
    Blocked: "bg-destructive/10 text-destructive",
    Success: "bg-success/10 text-success",
    Failed: "bg-destructive/10 text-destructive",
  };
  return (
    <span className={cn("px-2.5 py-1 rounded-full text-xs font-semibold", styles[status] || "bg-muted text-muted-foreground")}>
      {status}
    </span>
  );
}

export function SkeletonCard() {
  return (
    <div className="bg-card rounded-xl p-5 card-shadow border border-border animate-pulse">
      <div className="h-4 w-24 bg-muted rounded mb-3" />
      <div className="h-8 w-32 bg-muted rounded mb-2" />
      <div className="h-3 w-16 bg-muted rounded" />
    </div>
  );
}

export function EmptyState({ message, icon }: { message: string; icon: React.ReactNode }) {
  return (
    <div className="flex flex-col items-center justify-center py-16 text-muted-foreground">
      <div className="w-16 h-16 rounded-2xl bg-muted flex items-center justify-center mb-4">
        {icon}
      </div>
      <p className="text-sm font-medium">{message}</p>
    </div>
  );
}
