// Mock API service - ready to replace with real endpoints

export interface User {
  id: string;
  name: string;
  mobile: string;
  email: string;
  plan: "Free" | "Basic" | "Premium";
  expiryDate: string;
  status: "Active" | "Expired" | "Blocked";
  dailyLimit: number;
  joinDate: string;
}

export interface Payment {
  id: string;
  userMobile: string;
  userName: string;
  amount: number;
  date: string;
  status: "Success" | "Failed";
}

export interface DashboardStats {
  totalUsers: number;
  activeSubscriptions: number;
  totalBills: number;
  todayRevenue: number;
  userGrowth: { month: string; users: number }[];
  dailyBills: { day: string; bills: number }[];
  recentActivity: { id: string; action: string; user: string; time: string }[];
}

const mockUsers: User[] = [
  { id: "1", name: "Aarav Sharma", mobile: "9876543210", email: "aarav@email.com", plan: "Premium", expiryDate: "2026-06-15", status: "Active", dailyLimit: 100, joinDate: "2025-01-10" },
  { id: "2", name: "Priya Patel", mobile: "9876543211", email: "priya@email.com", plan: "Basic", expiryDate: "2026-04-20", status: "Active", dailyLimit: 50, joinDate: "2025-02-14" },
  { id: "3", name: "Rohit Kumar", mobile: "9876543212", email: "rohit@email.com", plan: "Free", expiryDate: "2026-03-01", status: "Expired", dailyLimit: 10, joinDate: "2025-03-05" },
  { id: "4", name: "Sneha Gupta", mobile: "9876543213", email: "sneha@email.com", plan: "Premium", expiryDate: "2026-08-30", status: "Active", dailyLimit: 100, joinDate: "2025-01-22" },
  { id: "5", name: "Vikram Singh", mobile: "9876543214", email: "vikram@email.com", plan: "Basic", expiryDate: "2026-02-10", status: "Blocked", dailyLimit: 50, joinDate: "2025-04-01" },
  { id: "6", name: "Anita Desai", mobile: "9876543215", email: "anita@email.com", plan: "Free", expiryDate: "2026-05-12", status: "Active", dailyLimit: 10, joinDate: "2025-05-18" },
  { id: "7", name: "Karan Mehta", mobile: "9876543216", email: "karan@email.com", plan: "Premium", expiryDate: "2026-07-25", status: "Active", dailyLimit: 100, joinDate: "2025-02-28" },
  { id: "8", name: "Deepa Nair", mobile: "9876543217", email: "deepa@email.com", plan: "Basic", expiryDate: "2026-03-18", status: "Expired", dailyLimit: 50, joinDate: "2025-06-10" },
];

const mockPayments: Payment[] = [
  { id: "p1", userMobile: "9876543210", userName: "Aarav Sharma", amount: 999, date: "2026-03-24", status: "Success" },
  { id: "p2", userMobile: "9876543211", userName: "Priya Patel", amount: 499, date: "2026-03-24", status: "Success" },
  { id: "p3", userMobile: "9876543212", userName: "Rohit Kumar", amount: 0, date: "2026-03-23", status: "Failed" },
  { id: "p4", userMobile: "9876543213", userName: "Sneha Gupta", amount: 999, date: "2026-03-23", status: "Success" },
  { id: "p5", userMobile: "9876543214", userName: "Vikram Singh", amount: 499, date: "2026-03-22", status: "Failed" },
  { id: "p6", userMobile: "9876543216", userName: "Karan Mehta", amount: 999, date: "2026-03-22", status: "Success" },
  { id: "p7", userMobile: "9876543210", userName: "Aarav Sharma", amount: 999, date: "2026-03-21", status: "Success" },
  { id: "p8", userMobile: "9876543215", userName: "Anita Desai", amount: 0, date: "2026-03-20", status: "Success" },
];

const mockDashboard: DashboardStats = {
  totalUsers: 1248,
  activeSubscriptions: 843,
  totalBills: 15672,
  todayRevenue: 24580,
  userGrowth: [
    { month: "Oct", users: 820 }, { month: "Nov", users: 932 },
    { month: "Dec", users: 1010 }, { month: "Jan", users: 1098 },
    { month: "Feb", users: 1175 }, { month: "Mar", users: 1248 },
  ],
  dailyBills: [
    { day: "Mon", bills: 120 }, { day: "Tue", bills: 145 },
    { day: "Wed", bills: 132 }, { day: "Thu", bills: 168 },
    { day: "Fri", bills: 155 }, { day: "Sat", bills: 89 },
    { day: "Sun", bills: 76 },
  ],
  recentActivity: [
    { id: "a1", action: "New user registered", user: "Karan Mehta", time: "2 min ago" },
    { id: "a2", action: "Plan upgraded to Premium", user: "Priya Patel", time: "15 min ago" },
    { id: "a3", action: "Payment received ₹999", user: "Aarav Sharma", time: "1 hour ago" },
    { id: "a4", action: "Account blocked", user: "Vikram Singh", time: "3 hours ago" },
    { id: "a5", action: "Plan expired", user: "Rohit Kumar", time: "5 hours ago" },
  ],
};

// Simulate API delay
const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

let users = [...mockUsers];

interface SystemSettings {
  freeTrialDays: number;
  freeDailyLimit: number;
  defaultPlanDays: number;
  defaultDailyLimit: number;
}

let systemSettings: SystemSettings = {
  freeTrialDays: 7,
  freeDailyLimit: 2,
  defaultPlanDays: 30,
  defaultDailyLimit: 10,
};

export const api = {
  getDashboard: async (): Promise<DashboardStats> => {
    await delay(600);
    return { ...mockDashboard };
  },

  getUsers: async (): Promise<User[]> => {
    await delay(500);
    return [...users];
  },

  getUser: async (id: string): Promise<User | undefined> => {
    await delay(400);
    return users.find(u => u.id === id);
  },

  updateUser: async (id: string, updates: Partial<User>): Promise<User> => {
    await delay(400);
    const idx = users.findIndex(u => u.id === id);
    if (idx === -1) throw new Error("User not found");
    users[idx] = { ...users[idx], ...updates };
    return users[idx];
  },

  getPayments: async (): Promise<Payment[]> => {
    await delay(500);
    return [...mockPayments];
  },

  login: async (email: string, password: string): Promise<{ token: string; admin: { name: string; email: string } }> => {
    await delay(800);
    if (email === "admin@admin.com" && password === "admin123") {
      return { token: "mock-jwt-token-xyz", admin: { name: "Super Admin", email } };
    }
    throw new Error("Invalid credentials");
  },

  getSettings: async (): Promise<SystemSettings> => {
    await delay(500);
    return { ...systemSettings };
  },

  updateSettings: async (settings: SystemSettings): Promise<SystemSettings> => {
    await delay(600);
    systemSettings = { ...settings };
    return { ...systemSettings };
  },
};
