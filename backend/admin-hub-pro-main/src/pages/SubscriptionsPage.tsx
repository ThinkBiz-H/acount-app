// import { useEffect, useState } from "react";
// import DashboardLayout from "@/components/DashboardLayout";
// import API from "@/services/api";
// import { useToast } from "@/hooks/use-toast";

// export default function SubscriptionsPage() {
//   const [users, setUsers] = useState<any[]>([]);
//   const [selectedId, setSelectedId] = useState("");
//   const [plan, setPlan] = useState<"Free" | "Basic" | "Premium">("Basic");
//   const [days, setDays] = useState(30);
//   const [dailyLimit, setDailyLimit] = useState(50);
//   const [loading, setLoading] = useState(true);
//   const { toast } = useToast();

//   useEffect(() => {
//     const fetchUsers = async () => {
//       try {
//         const res = await API.get("/admin/users");
//         setUsers(res.data.data);
//       } catch (e) {
//         console.log("Users error", e);
//       } finally {
//         setLoading(false);
//       }
//     };

//     fetchUsers();
//   }, []);

//   const applyChanges = async () => {
//     if (!selectedId) {
//       toast({ title: "Select a user first", variant: "destructive" });
//       return;
//     }

//     try {
//       await API.post("/admin/update-plan", {
//         userId: selectedId,
//         plan,
//         days,
//         dailyLimit,
//       });

//       toast({ title: "Subscription updated ✅" });
//     } catch (e) {
//       console.log("Update plan error", e);
//       toast({ title: "Failed to update plan", variant: "destructive" });
//     }
//   };
//   return (
//     <DashboardLayout title="Subscription Control">
//       <div className="max-w-xl">
//         <div className="bg-card rounded-xl p-8 card-shadow border border-border space-y-6">
//           <h3 className="text-lg font-semibold text-foreground">
//             Apply Subscription Changes
//           </h3>

//           <div>
//             <label className="text-sm font-medium text-foreground block mb-1.5">
//               Select User
//             </label>
//             <select
//               value={selectedId}
//               onChange={(e) => setSelectedId(e.target.value)}
//               className="w-full px-4 py-2.5 rounded-lg border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
//             >
//               <option value="">-- Choose user --</option>
//               {users.map((u) => (
//                 <option key={u._id} value={u._id}>
//                   {u.name || "User"} ({u.mobile})
//                 </option>
//               ))}
//             </select>
//           </div>

//           <div>
//             <label className="text-sm font-medium text-foreground block mb-1.5">
//               Plan
//             </label>
//             <div className="grid grid-cols-3 gap-3">
//               {(["Free", "Basic", "Premium"] as const).map((p) => (
//                 <button
//                   key={p}
//                   onClick={() => setPlan(p)}
//                   className={`py-2.5 rounded-lg text-sm font-semibold transition-colors border ${
//                     plan === p
//                       ? "bg-primary text-primary-foreground border-primary"
//                       : "bg-background text-foreground border-input hover:bg-muted"
//                   }`}
//                 >
//                   {p}
//                 </button>
//               ))}
//             </div>
//           </div>

//           <div className="grid grid-cols-2 gap-4">
//             <div>
//               <label className="text-sm font-medium text-foreground block mb-1.5">
//                 Days to Add
//               </label>
//               <input
//                 type="number"
//                 min={1}
//                 value={days}
//                 onChange={(e) => setDays(Number(e.target.value))}
//                 className="w-full px-4 py-2.5 rounded-lg border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
//               />
//             </div>
//             <div>
//               <label className="text-sm font-medium text-foreground block mb-1.5">
//                 Daily Limit
//               </label>
//               <input
//                 type="number"
//                 min={1}
//                 value={dailyLimit}
//                 onChange={(e) => setDailyLimit(Number(e.target.value))}
//                 className="w-full px-4 py-2.5 rounded-lg border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
//               />
//             </div>
//           </div>

//           <button
//             onClick={applyChanges}
//             disabled={loading}
//             className="w-full py-2.5 rounded-lg bg-primary text-primary-foreground font-semibold text-sm hover:opacity-90 transition-opacity"
//           >
//             Apply Changes
//           </button>
//         </div>
//       </div>
//     </DashboardLayout>
//   );
// }

import { useEffect, useState } from "react";
import DashboardLayout from "@/components/DashboardLayout";
import API from "@/services/api";
import { useToast } from "@/hooks/use-toast";

export default function SubscriptionsPage() {
  const [users, setUsers] = useState<any[]>([]);
  const [selectedId, setSelectedId] = useState("");
  const [plan, setPlan] = useState<"Free" | "Basic" | "Premium">("Basic");
  const [days, setDays] = useState(30);
  const [dailyLimit, setDailyLimit] = useState(50);
  const [loading, setLoading] = useState(true);
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

  // 🔥 PLAN AUTO LOGIC
  const handlePlanChange = (p: "Free" | "Basic" | "Premium") => {
    setPlan(p);

    if (p === "Free") {
      setDailyLimit(5);
      setDays(0);
    }

    if (p === "Basic") {
      setDailyLimit(50);
      setDays(30);
    }

    if (p === "Premium") {
      setDailyLimit(-1); // unlimited
      setDays(30);
    }
  };

  const applyChanges = async () => {
    if (!selectedId) {
      toast({ title: "Select a user first", variant: "destructive" });
      return;
    }

    try {
      await API.post("/admin/update-plan", {
        userId: selectedId,
        plan,
        days,
        dailyLimit: plan === "Free" ? 5 : dailyLimit, // 🔥 safety
      });

      toast({ title: "Subscription updated ✅" });

      // 🔥 reset form (optional but pro)
      setSelectedId("");
    } catch (e) {
      console.log("Update plan error", e);
      toast({ title: "Failed to update plan", variant: "destructive" });
    }
  };

  return (
    <DashboardLayout title="Subscription Control">
      <div className="max-w-xl">
        <div className="bg-card rounded-xl p-8 card-shadow border border-border space-y-6">
          <h3 className="text-lg font-semibold text-foreground">
            Apply Subscription Changes
          </h3>

          {/* USER SELECT */}
          <div>
            <label className="text-sm font-medium text-foreground block mb-1.5">
              Select User
            </label>
            <select
              value={selectedId}
              onChange={(e) => setSelectedId(e.target.value)}
              className="w-full px-4 py-2.5 rounded-lg border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
            >
              <option value="">-- Choose user --</option>
              {users.map((u) => (
                <option key={u._id} value={u._id}>
                  {u.name || "User"} ({u.mobile})
                </option>
              ))}
            </select>
          </div>

          {/* PLAN SELECT */}
          <div>
            <label className="text-sm font-medium text-foreground block mb-1.5">
              Plan
            </label>
            <div className="grid grid-cols-3 gap-3">
              {(["Free", "Basic", "Premium"] as const).map((p) => (
                <button
                  key={p}
                  onClick={() => handlePlanChange(p)} // 🔥 FIXED
                  className={`py-2.5 rounded-lg text-sm font-semibold transition-colors border ${
                    plan === p
                      ? "bg-primary text-primary-foreground border-primary"
                      : "bg-background text-foreground border-input hover:bg-muted"
                  }`}
                >
                  {p}
                </button>
              ))}
            </div>
          </div>

          {/* INPUTS */}
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="text-sm font-medium text-foreground block mb-1.5">
                Days to Add
              </label>
              <input
                type="number"
                min={0}
                value={days}
                onChange={(e) => setDays(Number(e.target.value))}
                disabled={plan === "Free"} // 🔥 optional lock
                className="w-full px-4 py-2.5 rounded-lg border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
              />
            </div>
            <div>
              <label className="text-sm font-medium text-foreground block mb-1.5">
                Daily Limit
              </label>
              <input
                type="number"
                min={-1}
                value={dailyLimit}
                onChange={(e) => setDailyLimit(Number(e.target.value))}
                className="w-full px-4 py-2.5 rounded-lg border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring"
              />
            </div>
          </div>

          {/* BUTTON */}
          <button
            onClick={applyChanges}
            disabled={loading}
            className="w-full py-2.5 rounded-lg bg-primary text-primary-foreground font-semibold text-sm hover:opacity-90 transition-opacity"
          >
            Apply Changes
          </button>
        </div>
      </div>
    </DashboardLayout>
  );
}
