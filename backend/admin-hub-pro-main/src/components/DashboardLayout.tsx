import { ReactNode } from "react";
import AppSidebar from "./AppSidebar";
import TopNavbar from "./TopNavbar";

export default function DashboardLayout({ children, title }: { children: ReactNode; title: string }) {
  return (
    <div className="min-h-screen bg-background">
      <AppSidebar />
      <div className="ml-[68px] lg:ml-[250px] transition-all duration-300">
        <TopNavbar title={title} />
        <main className="p-6 animate-fade-in">{children}</main>
      </div>
    </div>
  );
}
