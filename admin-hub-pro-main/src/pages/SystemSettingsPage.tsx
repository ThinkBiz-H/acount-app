import { useState, useEffect } from "react";
import DashboardLayout from "@/components/DashboardLayout";
import { useToast } from "@/hooks/use-toast";
import API from "../services/api";
import { Save, RotateCcw, Gift, Calendar } from "lucide-react";

export default function SystemSettingsPage() {
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [settings, setSettings] = useState({
    freeTrialDays: 7,
    freeDailyLimit: 2,
    defaultPlanDays: 30,
    defaultDailyLimit: 10,
  });
  const { toast } = useToast();

  useEffect(() => {
    const fetchSettings = async () => {
      try {
        const res = await API.get("/admin/settings");
        setSettings(res.data.data);
      } catch (e) {
        console.log("Error fetching settings", e);
      } finally {
        setLoading(false);
      }
    };

    fetchSettings();
  }, []);
  const handleChange = (key: keyof typeof settings, value: string) => {
    const num = parseInt(value, 10);
    if (value === "" || (!isNaN(num) && num >= 0)) {
      setSettings((prev) => ({ ...prev, [key]: value === "" ? 0 : num }));
    }
  };

  const handleSave = async () => {
    if (Object.values(settings).some((v) => v < 0)) {
      toast({ title: "Values cannot be negative", variant: "destructive" });
      return;
    }
    setSaving(true);
    try {
      await API.post("/admin/settings/update", settings);
      toast({ title: "Settings saved successfully" });
    } catch {
      toast({ title: "Failed to save settings", variant: "destructive" });
    } finally {
      setSaving(false);
    }
  };

  const handleReset = () => {
    setSettings({
      freeTrialDays: 7,
      freeDailyLimit: 2,
      defaultPlanDays: 30,
      defaultDailyLimit: 10,
    });
    toast({ title: "Settings reset to defaults" });
  };

  if (loading) {
    return (
      <DashboardLayout title="System Settings">
        <div className="max-w-2xl space-y-6">
          {[1, 2].map((i) => (
            <div
              key={i}
              className="bg-card rounded-xl p-8 card-shadow border border-border animate-pulse"
            >
              <div className="h-5 w-40 bg-muted rounded mb-6" />
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
                <div>
                  <div className="h-4 w-32 bg-muted rounded mb-2" />
                  <div className="h-10 bg-muted rounded" />
                </div>
                <div>
                  <div className="h-4 w-32 bg-muted rounded mb-2" />
                  <div className="h-10 bg-muted rounded" />
                </div>
              </div>
            </div>
          ))}
        </div>
      </DashboardLayout>
    );
  }

  return (
    <DashboardLayout title="System Settings">
      <div className="max-w-2xl space-y-6">
        {/* Free Plan Settings */}
        <div className="bg-card rounded-xl p-8 card-shadow border border-border">
          <div className="flex items-center gap-3 mb-6">
            <div className="w-9 h-9 rounded-lg stat-gradient-2 flex items-center justify-center">
              <Gift className="w-4.5 h-4.5 text-accent-foreground" />
            </div>
            <div>
              <h3 className="text-base font-semibold text-foreground">
                Free Plan Settings
              </h3>
              <p className="text-xs text-muted-foreground">
                Configure limits for free-tier users
              </p>
            </div>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
            <SettingField
              label="Free Trial Days"
              value={settings.freeTrialDays}
              onChange={(v) => handleChange("freeTrialDays", v)}
              hint="Number of trial days for new users"
            />
            <SettingField
              label="Free Daily Transaction Limit"
              value={settings.freeDailyLimit}
              onChange={(v) => handleChange("freeDailyLimit", v)}
              hint="Max transactions per day on free plan"
            />
          </div>
        </div>

        {/* Default Plan Settings */}
        <div className="bg-card rounded-xl p-8 card-shadow border border-border">
          <div className="flex items-center gap-3 mb-6">
            <div className="w-9 h-9 rounded-lg stat-gradient-1 flex items-center justify-center">
              <Calendar className="w-4.5 h-4.5 text-primary-foreground" />
            </div>
            <div>
              <h3 className="text-base font-semibold text-foreground">
                Default Plan Settings
              </h3>
              <p className="text-xs text-muted-foreground">
                Set defaults for new paid subscriptions
              </p>
            </div>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
            <SettingField
              label="Default Plan Duration (days)"
              value={settings.defaultPlanDays}
              onChange={(v) => handleChange("defaultPlanDays", v)}
              hint="Default subscription length in days"
            />
            <SettingField
              label="Default Daily Limit"
              value={settings.defaultDailyLimit}
              onChange={(v) => handleChange("defaultDailyLimit", v)}
              hint="Default transaction limit per day"
            />
          </div>
        </div>

        {/* Actions */}
        <div className="flex flex-col-reverse sm:flex-row gap-3 sm:justify-end">
          <button
            onClick={handleReset}
            className="flex items-center justify-center gap-2 px-5 py-2.5 rounded-lg border border-input bg-background text-foreground text-sm font-semibold hover:bg-muted transition-colors"
          >
            <RotateCcw className="w-4 h-4" /> Reset to Defaults
          </button>
          <button
            onClick={handleSave}
            disabled={saving}
            className="flex items-center justify-center gap-2 px-6 py-2.5 rounded-lg bg-primary text-primary-foreground text-sm font-semibold hover:opacity-90 transition-opacity disabled:opacity-50"
          >
            <Save className="w-4 h-4" /> {saving ? "Saving..." : "Save Changes"}
          </button>
        </div>
      </div>
    </DashboardLayout>
  );
}

function SettingField({
  label,
  value,
  onChange,
  hint,
}: {
  label: string;
  value: number;
  onChange: (v: string) => void;
  hint: string;
}) {
  return (
    <div>
      <label className="text-sm font-medium text-foreground block mb-1.5">
        {label}
      </label>
      <input
        type="number"
        min={0}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="w-full px-4 py-2.5 rounded-lg border border-input bg-background text-foreground text-sm focus:outline-none focus:ring-2 focus:ring-ring transition-shadow"
      />
      <p className="text-xs text-muted-foreground mt-1">{hint}</p>
    </div>
  );
}
