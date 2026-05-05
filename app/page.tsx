"use client"

import { useState } from "react"
import { BottomNavigation } from "@/components/bottom-navigation"
import { Dashboard } from "@/components/pages/dashboard"
import { MedicationSchedule } from "@/components/pages/medication-schedule"
import { HardwareManagement } from "@/components/pages/hardware-management"
import { HealthReports } from "@/components/pages/health-reports"
import { UserProfile } from "@/components/pages/user-profile"

export default function CureConnectApp() {
  const [activeTab, setActiveTab] = useState("home")

  const renderPage = () => {
    switch (activeTab) {
      case "home":
        return <Dashboard />
      case "schedule":
        return <MedicationSchedule />
      case "hardware":
        return <HardwareManagement />
      case "reports":
        return <HealthReports />
      case "settings":
        return <UserProfile />
      default:
        return <Dashboard />
    }
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Mobile Container */}
      <div className="max-w-md mx-auto px-4 py-6">
        {renderPage()}
      </div>

      {/* Bottom Navigation */}
      <BottomNavigation activeTab={activeTab} onTabChange={setActiveTab} />
    </div>
  )
}
