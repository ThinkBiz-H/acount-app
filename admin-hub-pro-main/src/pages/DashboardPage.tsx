import { useEffect, useState } from "react";
import DashboardLayout from "@/components/DashboardLayout";
import { StatCard, SkeletonCard } from "@/components/UIComponents";
import API from "@/services/api";
import {
  Users,
  CreditCard,
  FileText,
  DollarSign,
  Activity,
} from "lucide-react";
import {
  LineChart,
  Line,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

export default function DashboardPage() {
  const [data, setData] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchDashboard = async () => {
      try {
        const res = await API.get("/admin/dashboard");
        setData(res.data.data);
      } catch (e) {
        console.log("Dashboard error", e);
      } finally {
        setLoading(false);
      }
    };

    fetchDashboard();
  }, []);
  if (loading || !data) {
    return (
      <DashboardLayout title="Dashboard">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 mb-8">
          {[1, 2, 3, 4].map((i) => (
            <SkeletonCard key={i} />
          ))}
        </div>
      </DashboardLayout>
    );
  }

  return (
    <DashboardLayout title="Dashboard">
      {/* Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5 mb-8">
        <StatCard
          title="Total Users"
          value={data.totalUsers.toLocaleString()}
          icon={<Users className="w-5 h-5 text-primary-foreground" />}
          gradient="stat-gradient-1"
          change="+12.5%"
        />
        <StatCard
          title="Active Subscriptions"
          value={data.activeSubscriptions.toLocaleString()}
          icon={<CreditCard className="w-5 h-5 text-primary-foreground" />}
          gradient="stat-gradient-2"
          change="+8.3%"
        />
        <StatCard
          title="Total Bills"
          value={data.totalBills.toLocaleString()}
          icon={<FileText className="w-5 h-5 text-primary-foreground" />}
          gradient="stat-gradient-3"
          change="+15.7%"
        />
        <StatCard
          title="Today Revenue"
          value={`₹${data.todayRevenue.toLocaleString()}`}
          icon={<DollarSign className="w-5 h-5 text-primary-foreground" />}
          gradient="stat-gradient-4"
          change="+22.1%"
        />
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
        <div className="bg-card rounded-xl p-6 card-shadow border border-border">
          <h3 className="text-sm font-semibold text-foreground mb-4">
            User Growth
          </h3>
          <ResponsiveContainer width="100%" height={260}>
            <LineChart data={data.userGrowth}>
              <CartesianGrid
                strokeDasharray="3 3"
                stroke="hsl(var(--border))"
              />
              <XAxis
                dataKey="month"
                tick={{ fontSize: 12, fill: "hsl(var(--muted-foreground))" }}
              />
              <YAxis
                tick={{ fontSize: 12, fill: "hsl(var(--muted-foreground))" }}
              />
              <Tooltip
                contentStyle={{
                  background: "hsl(var(--card))",
                  border: "1px solid hsl(var(--border))",
                  borderRadius: 8,
                  fontSize: 13,
                }}
              />
              <Line
                type="monotone"
                dataKey="users"
                stroke="hsl(var(--primary))"
                strokeWidth={2.5}
                dot={{ r: 4, fill: "hsl(var(--primary))" }}
              />
            </LineChart>
          </ResponsiveContainer>
        </div>

        <div className="bg-card rounded-xl p-6 card-shadow border border-border">
          <h3 className="text-sm font-semibold text-foreground mb-4">
            Daily Bills
          </h3>
          <ResponsiveContainer width="100%" height={260}>
            <BarChart data={data.dailyBills}>
              <CartesianGrid
                strokeDasharray="3 3"
                stroke="hsl(var(--border))"
              />
              <XAxis
                dataKey="day"
                tick={{ fontSize: 12, fill: "hsl(var(--muted-foreground))" }}
              />
              <YAxis
                tick={{ fontSize: 12, fill: "hsl(var(--muted-foreground))" }}
              />
              <Tooltip
                contentStyle={{
                  background: "hsl(var(--card))",
                  border: "1px solid hsl(var(--border))",
                  borderRadius: 8,
                  fontSize: 13,
                }}
              />
              <Bar
                dataKey="bills"
                fill="hsl(var(--accent))"
                radius={[6, 6, 0, 0]}
              />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Recent Activity */}
      <div className="bg-card rounded-xl p-6 card-shadow border border-border">
        <h3 className="text-sm font-semibold text-foreground mb-4">
          Recent Activity
        </h3>
        <div className="space-y-3">
          {data.recentActivity.map((a) => (
            <div key={a.id} className="flex items-center gap-3 py-2">
              <div className="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center flex-shrink-0">
                <Activity className="w-4 h-4 text-primary" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm text-foreground">{a.action}</p>
                <p className="text-xs text-muted-foreground">{a.user}</p>
              </div>
              <span className="text-xs text-muted-foreground whitespace-nowrap">
                {a.time}
              </span>
            </div>
          ))}
        </div>
      </div>
    </DashboardLayout>
  );
}
