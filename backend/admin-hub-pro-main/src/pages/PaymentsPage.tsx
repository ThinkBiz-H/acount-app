import { useEffect, useState } from "react";
import DashboardLayout from "@/components/DashboardLayout";
import { StatusBadge, EmptyState } from "@/components/UIComponents";
import API from "@/services/api";
import { CreditCard } from "lucide-react";

export default function PaymentsPage() {
  const [payments, setPayments] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [statusFilter, setStatusFilter] = useState("all");
  const [dateFilter, setDateFilter] = useState("");

  useEffect(() => {
    const fetchPayments = async () => {
      try {
        const res = await API.get("/admin/payments");
        setPayments(res.data.data || []);
      } catch (e) {
        console.log("Payments error", e);
      } finally {
        setLoading(false);
      }
    };

    fetchPayments();
  }, []);

  const filtered = payments.filter((p) => {
    const matchStatus =
      statusFilter === "all" ||
      (p.status && p.status.toLowerCase() === statusFilter);

    const matchDate =
      !dateFilter ||
      (p.date && new Date(p.date).toISOString().slice(0, 10) === dateFilter);

    return matchStatus && matchDate;
  });

  return (
    <DashboardLayout title="Payment Logs">
      {/* FILTER */}
      <div className="flex flex-col sm:flex-row gap-3 mb-6">
        <input
          type="date"
          value={dateFilter}
          onChange={(e) => setDateFilter(e.target.value)}
          className="px-4 py-2.5 rounded-lg border border-input bg-card text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
        />

        <div className="flex gap-2">
          {["all", "success", "failed"].map((f) => (
            <button
              key={f}
              onClick={() => setStatusFilter(f)}
              className={`px-3 py-1.5 rounded-lg text-xs font-semibold capitalize transition-colors ${
                statusFilter === f
                  ? "bg-primary text-primary-foreground"
                  : "bg-secondary text-secondary-foreground hover:bg-muted"
              }`}
            >
              {f}
            </button>
          ))}
        </div>
      </div>

      {/* TABLE */}
      <div className="bg-card rounded-xl card-shadow border border-border overflow-hidden">
        {loading ? (
          <div className="p-8 text-center text-muted-foreground text-sm">
            Loading...
          </div>
        ) : filtered.length === 0 ? (
          <EmptyState
            message="No payments found"
            icon={<CreditCard className="w-6 h-6" />}
          />
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-border bg-muted/50">
                  <th className="text-left px-5 py-3 font-semibold text-muted-foreground">
                    User
                  </th>
                  <th className="text-left px-5 py-3 font-semibold text-muted-foreground">
                    Mobile
                  </th>
                  <th className="text-left px-5 py-3 font-semibold text-muted-foreground">
                    Amount
                  </th>
                  <th className="text-left px-5 py-3 font-semibold text-muted-foreground">
                    Date
                  </th>
                  <th className="text-left px-5 py-3 font-semibold text-muted-foreground">
                    Status
                  </th>
                </tr>
              </thead>

              <tbody>
                {filtered.map((p) => (
                  <tr
                    key={p.id}
                    className="border-b border-border last:border-0 hover:bg-muted/30 transition-colors"
                  >
                    {/* USER */}
                    <td className="px-5 py-3.5 font-medium text-foreground">
                      {p.userName || "User"}
                    </td>

                    {/* MOBILE */}
                    <td className="px-5 py-3.5 font-mono text-muted-foreground">
                      {p.userMobile}
                    </td>

                    {/* AMOUNT */}
                    <td className="px-5 py-3.5 font-semibold text-foreground">
                      ₹{p.amount?.toLocaleString()}
                    </td>

                    {/* DATE */}
                    <td className="px-5 py-3.5 text-muted-foreground">
                      {p.date ? new Date(p.date).toLocaleDateString() : "-"}
                    </td>

                    {/* STATUS */}
                    <td className="px-5 py-3.5">
                      <StatusBadge status={p.status || "unknown"} />
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
