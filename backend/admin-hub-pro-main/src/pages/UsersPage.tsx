import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import DashboardLayout from "@/components/DashboardLayout";
import { StatusBadge, EmptyState } from "@/components/UIComponents";
import API from "@/services/api";
import { Search, Users as UsersIcon, Eye } from "lucide-react";
import { useToast } from "@/hooks/use-toast";

export default function UsersPage() {
  const [users, setUsers] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [filter, setFilter] = useState<string>("all");
  const navigate = useNavigate();
  const { toast } = useToast();

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const res = await API.get("/admin/users");
        setUsers(res.data.data);
      } catch (e) {
        console.log("Users error", e);
      } finally {
        setLoading(false);
      }
    };

    fetchUsers();
  }, []);
  const toggleBlock = async (user: any) => {
    try {
      await API.post("/admin/toggle-user-status", {
        userId: user._id,
      });

      const newStatus = user.status === "Blocked" ? "Active" : "Blocked";

      setUsers((prev) =>
        prev.map((u) => (u._id === user._id ? { ...u, status: newStatus } : u)),
      );

      toast({
        title: `User ${newStatus === "Blocked" ? "blocked" : "unblocked"} ✅`,
      });
    } catch (e) {
      console.log("Toggle error", e);
    }
  };

  const filtered = users.filter((u) => {
    const matchSearch =
      u.mobile.includes(search) ||
      u.name.toLowerCase().includes(search.toLowerCase());
    const matchFilter =
      filter === "all" ||
      (filter === "active" && u.status === "Active") ||
      (filter === "blocked" && u.status === "Blocked") ||
      (filter === "expired" &&
        u.subscription?.endDate &&
        new Date(u.subscription.endDate) < new Date());
    return matchSearch && matchFilter;
  });

  return (
    <DashboardLayout title="User Management">
      {/* Toolbar */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center gap-3 mb-6">
        <div className="relative flex-1 w-full sm:max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search by name or mobile..."
            className="w-full pl-10 pr-4 py-2.5 rounded-lg border border-input bg-card text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
          />
        </div>
        <div className="flex gap-2">
          {["all", "active", "expired", "blocked"].map((f) => (
            <button
              key={f}
              onClick={() => setFilter(f)}
              className={`px-3 py-1.5 rounded-lg text-xs font-semibold capitalize transition-colors ${
                filter === f
                  ? "bg-primary text-primary-foreground"
                  : "bg-secondary text-secondary-foreground hover:bg-muted"
              }`}
            >
              {f}
            </button>
          ))}
        </div>
      </div>

      {/* Table */}
      <div className="bg-card rounded-xl card-shadow border border-border overflow-hidden">
        {loading ? (
          <div className="p-8 text-center text-muted-foreground text-sm">
            Loading...
          </div>
        ) : filtered.length === 0 ? (
          <EmptyState
            message="No users found"
            icon={<UsersIcon className="w-6 h-6" />}
          />
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-border bg-muted/50">
                  <th className="text-left px-5 py-3 font-semibold text-muted-foreground">
                    Name
                  </th>
                  <th className="text-left px-5 py-3 font-semibold text-muted-foreground">
                    Mobile
                  </th>
                  <th className="text-left px-5 py-3 font-semibold text-muted-foreground">
                    Plan
                  </th>
                  <th className="text-left px-5 py-3 font-semibold text-muted-foreground">
                    Expiry
                  </th>
                  <th className="text-left px-5 py-3 font-semibold text-muted-foreground">
                    Status
                  </th>
                  <th className="text-left px-5 py-3 font-semibold text-muted-foreground">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody>
                {filtered.map((user) => (
                  <tr
                    key={user._id}
                    className="border-b border-border last:border-0 hover:bg-muted/30 transition-colors"
                  >
                    <td className="px-5 py-3.5 font-medium text-foreground">
                      {user.name || user.mobile}
                    </td>
                    <td className="px-5 py-3.5 font-mono text-muted-foreground">
                      {user.mobile}
                    </td>
                    <td className="px-5 py-3.5">
                      <span className="px-2 py-0.5 rounded text-xs font-semibold bg-primary/10 text-primary">
                        {user.subscription?.plan || "Free"}
                      </span>
                    </td>
                    <td className="px-5 py-3.5 text-muted-foreground">
                      {user.subscription?.endDate
                        ? new Date(
                            user.subscription.endDate,
                          ).toLocaleDateString()
                        : "-"}
                    </td>
                    <td className="px-5 py-3.5">
                      <StatusBadge status={user.status} />
                    </td>
                    <td className="px-5 py-3.5">
                      <div className="flex gap-2">
                        <button
                          onClick={() => navigate(`/users/${user._id}`)}
                          className="p-1.5 rounded-md hover:bg-secondary transition-colors text-muted-foreground hover:text-foreground"
                        >
                          <Eye className="w-4 h-4" />
                        </button>
                        <button
                          onClick={() => toggleBlock(user)}
                          className={`px-2.5 py-1 rounded-md text-xs font-semibold transition-colors ${
                            user.status === "Blocked"
                              ? "bg-success/10 text-success hover:bg-success/20"
                              : "bg-destructive/10 text-destructive hover:bg-destructive/20"
                          }`}
                        >
                          {user.status === "Blocked" ? "Unblock" : "Block"}
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </DashboardLayout>
  );
}
