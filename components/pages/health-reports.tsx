"use client"

import { useState } from "react"
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Area,
  AreaChart,
} from "recharts"
import { Heart, Thermometer, AlertTriangle, TrendingUp, TrendingDown, Calendar } from "lucide-react"
import { cn } from "@/lib/utils"

// Mock data for charts
const heartRateData = [
  { time: "00:00", value: 68 },
  { time: "04:00", value: 62 },
  { time: "08:00", value: 75 },
  { time: "12:00", value: 82 },
  { time: "16:00", value: 78 },
  { time: "20:00", value: 70 },
  { time: "Now", value: 75 },
]

const temperatureData = [
  { time: "00:00", value: 36.5 },
  { time: "04:00", value: 36.3 },
  { time: "08:00", value: 36.8 },
  { time: "12:00", value: 37.1 },
  { time: "16:00", value: 37.0 },
  { time: "20:00", value: 36.7 },
  { time: "Now", value: 37.0 },
]

const emergencyAlerts = [
  { id: 1, type: "High Heart Rate", value: "120 bpm", date: "May 3, 2026", time: "14:32", resolved: true },
  { id: 2, type: "Missed Medication", value: "Metformin", date: "May 2, 2026", time: "09:15", resolved: true },
  { id: 3, type: "Low Temperature", value: "35.2°C", date: "Apr 30, 2026", time: "06:45", resolved: true },
]

const weeklyStats = [
  { day: "Mon", heartRate: 72, temp: 36.8 },
  { day: "Tue", heartRate: 75, temp: 36.9 },
  { day: "Wed", heartRate: 70, temp: 37.0 },
  { day: "Thu", heartRate: 78, temp: 36.7 },
  { day: "Fri", heartRate: 74, temp: 36.8 },
  { day: "Sat", heartRate: 71, temp: 36.6 },
  { day: "Sun", heartRate: 75, temp: 37.0 },
]

type TimeRange = "today" | "week" | "month"

export function HealthReports() {
  const [timeRange, setTimeRange] = useState<TimeRange>("today")

  const CustomTooltip = ({ active, payload, label }: { active?: boolean; payload?: { value: number }[]; label?: string }) => {
    if (active && payload && payload.length) {
      return (
        <div className="glass-card px-3 py-2 text-sm">
          <p className="text-muted-foreground">{label}</p>
          <p className="font-medium gradient-text">{payload[0].value}</p>
        </div>
      )
    }
    return null
  }

  return (
    <div className="flex flex-col gap-6 pb-32">
      {/* Header */}
      <header>
        <h1 className="text-2xl font-bold text-foreground">Health Reports</h1>
        <p className="text-sm text-muted-foreground">Monitor your vitals history</p>
      </header>

      {/* Time Range Selector */}
      <div className="glass-card p-1 flex">
        {(["today", "week", "month"] as const).map((range) => (
          <button
            key={range}
            onClick={() => setTimeRange(range)}
            className={cn(
              "flex-1 py-2 px-4 rounded-xl text-sm font-medium transition-all capitalize",
              timeRange === range
                ? "bg-gradient-to-r from-[#00D9A5] to-[#00C4D9] text-black"
                : "text-muted-foreground hover:text-foreground"
            )}
          >
            {range}
          </button>
        ))}
      </div>

      {/* Summary Cards */}
      <div className="grid grid-cols-2 gap-4">
        <div className="glass-card p-4">
          <div className="flex items-center gap-2 mb-2">
            <Heart className="w-4 h-4 text-red-500" />
            <span className="text-xs text-muted-foreground">Avg Heart Rate</span>
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold gradient-text">74</span>
            <span className="text-xs text-muted-foreground">bpm</span>
          </div>
          <div className="flex items-center gap-1 mt-2 text-[#22C55E]">
            <TrendingDown className="w-3 h-3" />
            <span className="text-xs">-3% from last week</span>
          </div>
        </div>
        <div className="glass-card p-4">
          <div className="flex items-center gap-2 mb-2">
            <Thermometer className="w-4 h-4 text-orange-500" />
            <span className="text-xs text-muted-foreground">Avg Temperature</span>
          </div>
          <div className="flex items-baseline gap-2">
            <span className="text-2xl font-bold gradient-text">36.8</span>
            <span className="text-xs text-muted-foreground">°C</span>
          </div>
          <div className="flex items-center gap-1 mt-2 text-[#22C55E]">
            <TrendingUp className="w-3 h-3" />
            <span className="text-xs">Normal range</span>
          </div>
        </div>
      </div>

      {/* Heart Rate Chart */}
      <section className="glass-card p-5">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-red-500/20 flex items-center justify-center">
              <Heart className="w-5 h-5 text-red-500" />
            </div>
            <div>
              <h3 className="font-semibold text-foreground">Heart Rate</h3>
              <p className="text-xs text-muted-foreground">Beats per minute</p>
            </div>
          </div>
          <span className="text-2xl font-bold gradient-text">75 bpm</span>
        </div>

        <div className="h-48 w-full">
          <ResponsiveContainer width="100%" height="100%">
            <AreaChart data={heartRateData}>
              <defs>
                <linearGradient id="heartGradient" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#EF4444" stopOpacity={0.3} />
                  <stop offset="95%" stopColor="#EF4444" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
              <XAxis dataKey="time" stroke="rgba(255,255,255,0.5)" fontSize={10} />
              <YAxis stroke="rgba(255,255,255,0.5)" fontSize={10} domain={[50, 100]} />
              <Tooltip content={<CustomTooltip />} />
              <Area
                type="monotone"
                dataKey="value"
                stroke="#EF4444"
                strokeWidth={2}
                fill="url(#heartGradient)"
              />
            </AreaChart>
          </ResponsiveContainer>
        </div>
      </section>

      {/* Temperature Chart */}
      <section className="glass-card p-5">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-orange-500/20 flex items-center justify-center">
              <Thermometer className="w-5 h-5 text-orange-500" />
            </div>
            <div>
              <h3 className="font-semibold text-foreground">Body Temperature</h3>
              <p className="text-xs text-muted-foreground">Degrees Celsius</p>
            </div>
          </div>
          <span className="text-2xl font-bold gradient-text">37°C</span>
        </div>

        <div className="h-48 w-full">
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={temperatureData}>
              <defs>
                <linearGradient id="tempGradient" x1="0" y1="0" x2="1" y2="0">
                  <stop offset="0%" stopColor="#00D9A5" />
                  <stop offset="100%" stopColor="#00C4D9" />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" />
              <XAxis dataKey="time" stroke="rgba(255,255,255,0.5)" fontSize={10} />
              <YAxis stroke="rgba(255,255,255,0.5)" fontSize={10} domain={[35, 38]} />
              <Tooltip content={<CustomTooltip />} />
              <Line
                type="monotone"
                dataKey="value"
                stroke="url(#tempGradient)"
                strokeWidth={3}
                dot={{ fill: "#00D9A5", strokeWidth: 0, r: 4 }}
                activeDot={{ r: 6, fill: "#00C4D9" }}
              />
            </LineChart>
          </ResponsiveContainer>
        </div>
      </section>

      {/* Weekly Overview */}
      <section className="glass-card p-5">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 rounded-2xl bg-[#007BFF]/20 flex items-center justify-center">
            <Calendar className="w-5 h-5 text-[#007BFF]" />
          </div>
          <div>
            <h3 className="font-semibold text-foreground">Weekly Overview</h3>
            <p className="text-xs text-muted-foreground">Last 7 days summary</p>
          </div>
        </div>

        <div className="grid grid-cols-7 gap-2">
          {weeklyStats.map((day) => (
            <div key={day.day} className="text-center">
              <p className="text-xs text-muted-foreground mb-2">{day.day}</p>
              <div className="space-y-1">
                <div className="h-16 bg-secondary/50 rounded-lg relative overflow-hidden">
                  <div
                    className="absolute bottom-0 w-full bg-gradient-to-t from-red-500/50 to-red-500/20 transition-all"
                    style={{ height: `${((day.heartRate - 60) / 30) * 100}%` }}
                  />
                </div>
                <p className="text-xs text-foreground font-medium">{day.heartRate}</p>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* Emergency Alerts */}
      <section className="glass-card p-5">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-red-500/20 flex items-center justify-center">
              <AlertTriangle className="w-5 h-5 text-red-500" />
            </div>
            <div>
              <h3 className="font-semibold text-foreground">Emergency Alerts</h3>
              <p className="text-xs text-muted-foreground">Past week</p>
            </div>
          </div>
          <span className="px-3 py-1 rounded-full bg-[#22C55E]/20 text-[#22C55E] text-xs font-medium">
            All Resolved
          </span>
        </div>

        <div className="space-y-3">
          {emergencyAlerts.map((alert) => (
            <div
              key={alert.id}
              className="flex items-center justify-between p-3 rounded-2xl bg-secondary/50"
            >
              <div className="flex items-center gap-3">
                <div className="w-2 h-2 rounded-full bg-[#22C55E]" />
                <div>
                  <p className="text-sm font-medium text-foreground">{alert.type}</p>
                  <p className="text-xs text-muted-foreground">{alert.value}</p>
                </div>
              </div>
              <div className="text-right">
                <p className="text-xs text-foreground">{alert.date}</p>
                <p className="text-xs text-muted-foreground">{alert.time}</p>
              </div>
            </div>
          ))}
        </div>
      </section>
    </div>
  )
}
