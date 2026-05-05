"use client"

import { Heart, Thermometer, Wifi, AlertTriangle } from "lucide-react"
import { cn } from "@/lib/utils"
import { useState } from "react"

export function Dashboard() {
  const [sosPressed, setSosPressed] = useState(false)

  const handleSOS = () => {
    setSosPressed(true)
    // Simulate SOS action
    setTimeout(() => setSosPressed(false), 3000)
  }

  return (
    <div className="flex flex-col gap-6 pb-32">
      {/* Header */}
      <header className="flex items-center justify-between">
        <div>
          <p className="text-muted-foreground text-sm">Good Morning</p>
          <h1 className="text-2xl font-bold text-foreground">Welcome, Moamen</h1>
        </div>
        <div className="w-12 h-12 rounded-full bg-gradient-to-br from-[#00D9A5] to-[#00C4D9] flex items-center justify-center text-black font-bold text-lg">
          M
        </div>
      </header>

      {/* Connection Status */}
      <div className="glass-card p-4 flex items-center gap-3">
        <div className="w-3 h-3 rounded-full bg-[#22C55E] animate-pulse" />
        <Wifi className="w-5 h-5 text-[#22C55E]" />
        <span className="text-sm font-medium text-foreground">ESP32 Connected</span>
        <span className="ml-auto text-xs text-muted-foreground">Last sync: Just now</span>
      </div>

      {/* Real-time Vitals */}
      <section>
        <h2 className="text-lg font-semibold mb-4 text-foreground">Real-time Vitals</h2>
        <div className="grid grid-cols-2 gap-4">
          {/* Heart Rate Card */}
          <div className="glass-card p-5 flex flex-col gap-3">
            <div className="flex items-center gap-2">
              <div className="w-10 h-10 rounded-2xl bg-red-500/20 flex items-center justify-center">
                <Heart className="w-5 h-5 text-red-500" />
              </div>
              <span className="text-sm text-muted-foreground">Heart Rate</span>
            </div>
            <div className="flex items-baseline gap-1">
              <span className="text-4xl font-bold gradient-text">75</span>
              <span className="text-sm text-muted-foreground">bpm</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 rounded-full bg-[#22C55E]" />
              <span className="text-xs text-[#22C55E]">Normal</span>
            </div>
          </div>

          {/* Body Temperature Card */}
          <div className="glass-card p-5 flex flex-col gap-3">
            <div className="flex items-center gap-2">
              <div className="w-10 h-10 rounded-2xl bg-orange-500/20 flex items-center justify-center">
                <Thermometer className="w-5 h-5 text-orange-500" />
              </div>
              <span className="text-sm text-muted-foreground">Body Temp</span>
            </div>
            <div className="flex items-baseline gap-1">
              <span className="text-4xl font-bold gradient-text">37</span>
              <span className="text-sm text-muted-foreground">°C</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 rounded-full bg-[#22C55E]" />
              <span className="text-xs text-[#22C55E]">Normal</span>
            </div>
          </div>
        </div>
      </section>

      {/* Emergency Zone */}
      <section className="flex flex-col items-center gap-4 py-8">
        <h2 className="text-lg font-semibold text-foreground flex items-center gap-2">
          <AlertTriangle className="w-5 h-5 text-red-500" />
          Emergency Zone
        </h2>
        <p className="text-sm text-muted-foreground text-center max-w-xs">
          Press and hold the SOS button to alert emergency contacts and medical services
        </p>
        
        {/* SOS Button */}
        <button
          onClick={handleSOS}
          className={cn(
            "relative w-32 h-32 rounded-full bg-gradient-to-br from-red-500 to-red-600",
            "flex items-center justify-center text-white font-bold text-2xl",
            "transition-transform active:scale-95 sos-button ripple-effect",
            sosPressed && "scale-110"
          )}
        >
          <span className="z-10">SOS</span>
        </button>
        
        {sosPressed && (
          <div className="flex items-center gap-2 text-red-500 animate-pulse">
            <AlertTriangle className="w-4 h-4" />
            <span className="text-sm font-medium">Emergency Alert Triggered!</span>
          </div>
        )}
      </section>

      {/* Quick Stats */}
      <section className="glass-card p-5">
        <h3 className="text-sm font-medium text-muted-foreground mb-4">Today&apos;s Summary</h3>
        <div className="grid grid-cols-3 gap-4">
          <div className="text-center">
            <p className="text-2xl font-bold text-[#00D9A5]">3/4</p>
            <p className="text-xs text-muted-foreground">Doses Taken</p>
          </div>
          <div className="text-center">
            <p className="text-2xl font-bold text-[#007BFF]">0</p>
            <p className="text-xs text-muted-foreground">Alerts Today</p>
          </div>
          <div className="text-center">
            <p className="text-2xl font-bold text-[#F59E0B]">1</p>
            <p className="text-xs text-muted-foreground">Pending</p>
          </div>
        </div>
      </section>
    </div>
  )
}
