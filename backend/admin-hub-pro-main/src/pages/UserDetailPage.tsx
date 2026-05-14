// import { useEffect, useState } from "react";
// import { useParams, useNavigate } from "react-router-dom";
// import DashboardLayout from "@/components/DashboardLayout";
// import { StatusBadge } from "@/components/UIComponents";
// import { api, User } from "@/services/mockApi";
// import { ArrowLeft, Save } from "lucide-react";
// import { useToast } from "@/hooks/use-toast";

// export default function UserDetailPage() {
//   const { id } = useParams<{ id: string }>();
//   const [user, setUser] = useState<User | null>(null);
//   const [loading, setLoading] = useState(true);
//   const [plan, setPlan] = useState("");
//   const [extraDays, setExtraDays] = useState(0);
//   const [dailyLimit, setDailyLimit] = useState(0);
//   const navigate = useNavigate();
//   const { toast } = useToast();

//   useEffect(() => {
//     if (!id) return;
//     api.getUser(id).then(u => {
//       if (u) { setUser(u); setPlan(u.plan); setDailyLimit(u.dailyLimit); }
//       setLoading(false);
//     });
//   }, [id]);

//   const saveChanges = async () => {
//     if (!user) return;
//     let newExpiry = user.expiryDate;
//     if (extraDays > 0) {
//       const d = new Date(user.expiryDate);
//       d.setDate(d.getDate() + extraDays);
//       newExpiry = d.toISOString().split("T")[0];
//     }
//     const updated = await api.updateUser(user.id, {
//       plan: plan as User["plan"],
//       dailyLimit,
//       expiryDate: newExpiry,
//     });
//     setUser(updated);
//     setExtraDays(0);
//     toast({ title: "User updated successfully" });
//   };

//   const toggleStatus = async () => {
//     if (!user) return;
//     const newStatus = user.status === "Active" ? "Blocked" : "Active";
//     const updated = await api.updateUser(user.id, { status: newStatus });
//     setUser(updated);
//     toast({ title: `User ${newStatus === "Active" ? "activated" : "blocked"}` });
//   };

//   if (loading) {
//     return <DashboardLayout title="User Details"><div className="text-muted-foreground">Loading...</div></DashboardLayout>;
//   }
//   if (!user) {
//     return <DashboardLayout title="User Details"><div className="text-muted-foreground">User not found</div></DashboardLayout>;
//   }

//   return (
//     <DashboardLayout title="User Details">
//       <button onClick={() => navigate("/users")} className="flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground mb-6 transition-colors">
//         <ArrowLeft className="w-4 h-4" /> Back to Users
//       </button>

//       <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
//         {/* Info */}
//         <div className="bg-card rounded-xl p-6 card-shadow border border-border">
//           <h3 className="text-sm font-semibold text-foreground mb-4">User Information</h3>
//           <div className="space-y-4">
//             {[
//               ["Name", user.name],
//               ["Mobile", user.mobile],
//               ["Email", user.email],
//               ["Joined", user.joinDate],
//             ].map(([label, val]) => (
//               <div key={label}>
//                 <p className="text-xs text-muted-foreground">{label}</p>
//                 <p className="text-sm font-medium text-foreground">{val}</p>
//               </div>
//             ))}
//             <div>
//               <p className="text-xs text-muted-foreground mb-1">Status</p>
//               <StatusBadge status={user.status} />
//             </div>
//           </div>
//         </div>

//         {/* Subscription */}
//         <div className="bg-card rounded-xl p-6 card-shadow border border-border">
//           <h3 className="text-sm font-semibold text-foreground mb-4">Subscription</h3>
//           <div className="space-y-4">
//             <div>
//               <p className="text-xs text-muted-foreground mb-1">Current Plan</p>
//               <span className="px-2.5 py-1 rounded text-xs font-semibold bg-primary/10 text-primary">{user.plan}</span>
//             </div>
//             <div>
//               <p className="text-xs text-muted-foreground">Expiry Date</p>
//               <p className="text-sm font-medium text-foreground">{user.expiryDate}</p>
//             </div>
//             <div>
//               <p className="text-xs text-muted-foreground">Daily Limit</p>
//               <p className="text-sm font-medium text-foreground">{user.dailyLimit} transactions</p>
//             </div>
//           </div>
//         </div>

//         {/* Actions */}
//         <div className="bg-card rounded-xl p-6 card-shadow border border-border space-y-5">
//           <h3 className="text-sm font-semibold text-foreground">Manage User</h3>

//           <div>
//             <label className="text-xs text-muted-foreground block mb-1">Change Plan</label>
//             <select
//               value={plan}
//               onChange={e => setPlan(e.target.value)}
//               className="w-full px-3 py-2 rounded-lg border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
//             >
//               <option value="Free">Free</option>
//               <option value="Basic">Basic</option>
//               <option value="Premium">Premium</option>
//             </select>
//           </div>

//           <div>
//             <label className="text-xs text-muted-foreground block mb-1">Extend Plan (days)</label>
//             <input
//               type="number"
//               min={0}
//               value={extraDays}
//               onChange={e => setExtraDays(Number(e.target.value))}
//               className="w-full px-3 py-2 rounded-lg border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
//             />
//           </div>

//           <div>
//             <label className="text-xs text-muted-foreground block mb-1">Daily Limit</label>
//             <input
//               type="number"
//               min={1}
//               value={dailyLimit}
//               onChange={e => setDailyLimit(Number(e.target.value))}
//               className="w-full px-3 py-2 rounded-lg border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
//             />
//           </div>

//           <div className="flex gap-3 pt-2">
//             <button
//               onClick={saveChanges}
//               className="flex-1 flex items-center justify-center gap-2 py-2.5 rounded-lg bg-primary text-primary-foreground text-sm font-semibold hover:opacity-90 transition-opacity"
//             >
//               <Save className="w-4 h-4" /> Save
//             </button>
//             <button
//               onClick={toggleStatus}
//               className={`flex-1 py-2.5 rounded-lg text-sm font-semibold transition-opacity hover:opacity-90 ${
//                 user.status === "Active"
//                   ? "bg-destructive text-destructive-foreground"
//                   : "bg-success text-success-foreground"
//               }`}
//             >
//               {user.status === "Active" ? "Block" : "Activate"}
//             </button>
//           </div>
//         </div>
//       </div>
//     </DashboardLayout>
//   );
// }

import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import DashboardLayout from "@/components/DashboardLayout";
import { StatusBadge } from "@/components/UIComponents";
import API from "@/services/api";
import { ArrowLeft, Save } from "lucide-react";
import { useToast } from "@/hooks/use-toast";

export default function UserDetailPage() {
  const { id } = useParams<{ id: string }>();
  const [user, setUser] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [plan, setPlan] = useState("");
  const [extraDays, setExtraDays] = useState(0);
  const [dailyLimit, setDailyLimit] = useState(0);
  const navigate = useNavigate();
  const { toast } = useToast();

  // ✅ GET USER
  useEffect(() => {
    if (!id) return;

    const fetchUser = async () => {
      try {
        const res = await API.get(`/admin/user/${id}`);
        const u = res.data.data;

        setUser(u);
        setPlan(u.subscription?.plan || "Free");
        setDailyLimit(u.subscription?.dailyLimit || 0);
      } catch (e) {
        console.log("User fetch error", e);
      } finally {
        setLoading(false);
      }
    };

    fetchUser();
  }, [id]);

  // ✅ SAVE CHANGES
  const saveChanges = async () => {
    if (!user) return;

    try {
      await API.post("/admin/update-plan", {
        userId: user._id,
        plan,
        days: extraDays,
        dailyLimit,
      });

      toast({ title: "User updated successfully ✅" });
      setExtraDays(0);
    } catch (e) {
      console.log("Update error", e);
      toast({ title: "Update failed ❌", variant: "destructive" });
    }
  };

  // ✅ TOGGLE STATUS
  const toggleStatus = async () => {
    if (!user) return;

    try {
      await API.post("/admin/toggle-user-status", {
        userId: user._id,
      });

      toast({
        title: `User ${user.status === "Active" ? "blocked" : "activated"} ✅`,
      });
    } catch (e) {
      console.log("Status error", e);
      toast({ title: "Action failed ❌", variant: "destructive" });
    }
  };

  if (loading) {
    return (
      <DashboardLayout title="User Details">
        <div className="text-muted-foreground">Loading...</div>
      </DashboardLayout>
    );
  }

  if (!user) {
    return (
      <DashboardLayout title="User Details">
        <div className="text-muted-foreground">User not found</div>
      </DashboardLayout>
    );
  }

  return (
    <DashboardLayout title="User Details">
      <button
        onClick={() => navigate("/users")}
        className="flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground mb-6 transition-colors"
      >
        <ArrowLeft className="w-4 h-4" /> Back to Users
      </button>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Info */}
        <div className="bg-card rounded-xl p-6 card-shadow border border-border">
          <h3 className="text-sm font-semibold text-foreground mb-4">
            User Information
          </h3>

          <div className="space-y-4">
            {[
              ["Name", user.name],
              ["Mobile", user.mobile],
              ["Email", user.email],
            ].map(([label, val]) => (
              <div key={label}>
                <p className="text-xs text-muted-foreground">{label}</p>
                <p className="text-sm font-medium text-foreground">{val}</p>
              </div>
            ))}

            <div>
              <p className="text-xs text-muted-foreground mb-1">Status</p>
              <StatusBadge status={user.status} />
            </div>
          </div>
        </div>

        {/* Subscription */}
        <div className="bg-card rounded-xl p-6 card-shadow border border-border">
          <h3 className="text-sm font-semibold text-foreground mb-4">
            Subscription
          </h3>

          <div className="space-y-4">
            <div>
              <p className="text-xs text-muted-foreground mb-1">Current Plan</p>
              <span className="px-2.5 py-1 rounded text-xs font-semibold bg-primary/10 text-primary">
                {user.subscription?.plan}
              </span>
            </div>

            <div>
              <p className="text-xs text-muted-foreground">Expiry Date</p>
              <p className="text-sm font-medium text-foreground">
                {user.subscription?.endDate}
              </p>
            </div>

            <div>
              <p className="text-xs text-muted-foreground">Daily Limit</p>
              <p className="text-sm font-medium text-foreground">
                {user.subscription?.dailyLimit} transactions
              </p>
            </div>
          </div>
        </div>

        {/* Actions */}
        <div className="bg-card rounded-xl p-6 card-shadow border border-border space-y-5">
          <h3 className="text-sm font-semibold text-foreground">Manage User</h3>

          <select
            value={plan}
            onChange={(e) => setPlan(e.target.value)}
            className="w-full px-3 py-2 rounded-lg border border-input"
          >
            <option value="Free">Free</option>
            <option value="Basic">Basic</option>
            <option value="Premium">Premium</option>
          </select>

          <input
            type="number"
            value={extraDays}
            onChange={(e) => setExtraDays(Number(e.target.value))}
            className="w-full px-3 py-2 rounded-lg border border-input"
            placeholder="Extra days"
          />

          <input
            type="number"
            value={dailyLimit}
            onChange={(e) => setDailyLimit(Number(e.target.value))}
            className="w-full px-3 py-2 rounded-lg border border-input"
            placeholder="Daily limit"
          />

          <div className="flex gap-3">
            <button
              onClick={saveChanges}
              className="flex-1 py-2 bg-primary text-white rounded-lg"
            >
              Save
            </button>

            <button
              onClick={toggleStatus}
              className="flex-1 py-2 bg-red-500 text-white rounded-lg"
            >
              {user.status === "Active" ? "Block" : "Activate"}
            </button>
          </div>
        </div>
      </div>
    </DashboardLayout>
  );
}
