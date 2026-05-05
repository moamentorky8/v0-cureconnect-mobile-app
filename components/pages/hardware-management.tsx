"use client"

import { useState } from "react"
import { Cpu, Wifi, Sun, Bell, Settings2, RefreshCw, Activity, Lightbulb } from "lucide-react"
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
import { Slider } from "@/components/ui/slider"
import { Switch } from "@/components/ui/switch"

interface SensorData {
  ldrValue: number
  ldrStatus: "bright" | "dim" | "dark"
  alarmActive: boolean
  lastPing: string
}

export function HardwareManagement() {
  const [sensorData, setSensorData] = useState<SensorData>({
    ldrValue: 720,
    ldrStatus: "bright",
    alarmActive: false,
    lastPing: "2 seconds ago",
  })
  const [pwmIntensity, setPwmIntensity] = useState([75])
  const [autoMode, setAutoMode] = useState(true)
  const [isRefreshing, setIsRefreshing] = useState(false)
  const [alarmTriggered, setAlarmTriggered] = useState(false)

  const handleRefresh = () => {
    setIsRefreshing(true)
    setTimeout(() => {
      setSensorData({
        ...sensorData,
        ldrValue: Math.floor(Math.random() * 1024),
        lastPing: "Just now",
      })
      setIsRefreshing(false)
    }, 1000)
  }

  const handleTriggerAlarm = () => {
    setAlarmTriggered(true)
    setSensorData({ ...sensorData, alarmActive: true })
    setTimeout(() => {
      setAlarmTriggered(false)
      setSensorData({ ...sensorData, alarmActive: false })
    }, 3000)
  }

  const getLdrStatusColor = (status: string) => {
    switch (status) {
      case "bright":
        return "text-[#F59E0B]"
      case "dim":
        return "text-[#00D9A5]"
      case "dark":
        return "text-[#007BFF]"
      default:
        return "text-muted-foreground"
    }
  }

  return (
    <div className="flex flex-col gap-6 pb-32">
      {/* Header */}
      <header>
        <h1 className="text-2xl font-bold text-foreground">Hardware Management</h1>
        <p className="text-sm text-muted-foreground">ESP32 Smart Medication Organizer</p>
      </header>

      {/* Device Status Card */}
      <div className="glass-card p-5">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 rounded-2xl bg-[#007BFF]/20 flex items-center justify-center">
              <Cpu className="w-6 h-6 text-[#007BFF]" />
            </div>
            <div>
              <h2 className="font-semibold text-foreground">ESP32-WROOM-32</h2>
              <p className="text-xs text-muted-foreground">Medication Organizer v1.2</p>
            </div>
          </div>
          <button
            onClick={handleRefresh}
            className={cn(
              "w-10 h-10 rounded-full bg-secondary flex items-center justify-center",
              "hover:bg-secondary/80 transition-colors",
              isRefreshing && "animate-spin"
            )}
          >
            <RefreshCw className="w-5 h-5 text-muted-foreground" />
          </button>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div className="flex items-center gap-3 p-3 rounded-2xl bg-secondary/50">
            <Wifi className="w-5 h-5 text-[#22C55E]" />
            <div>
              <p className="text-xs text-muted-foreground">Connection</p>
              <p className="text-sm font-medium text-[#22C55E]">Online</p>
            </div>
          </div>
          <div className="flex items-center gap-3 p-3 rounded-2xl bg-secondary/50">
            <Activity className="w-5 h-5 text-[#00D9A5]" />
            <div>
              <p className="text-xs text-muted-foreground">Last Ping</p>
              <p className="text-sm font-medium text-foreground">{sensorData.lastPing}</p>
            </div>
          </div>
        </div>
      </div>

      {/* LDR Sensor Status */}
      <section className="glass-card p-5">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 rounded-2xl bg-[#F59E0B]/20 flex items-center justify-center">
            <Sun className="w-5 h-5 text-[#F59E0B]" />
          </div>
          <div>
            <h3 className="font-semibold text-foreground">LDR Light Sensor</h3>
            <p className="text-xs text-muted-foreground">Ambient light detection</p>
          </div>
        </div>

        <div className="space-y-4">
          {/* Sensor Value */}
          <div className="flex items-center justify-between p-4 rounded-2xl bg-secondary/50">
            <div>
              <p className="text-sm text-muted-foreground">Current Reading</p>
              <div className="flex items-baseline gap-2">
                <span className="text-3xl font-bold gradient-text">{sensorData.ldrValue}</span>
                <span className="text-sm text-muted-foreground">/ 1024</span>
              </div>
            </div>
            <div className={cn("text-right", getLdrStatusColor(sensorData.ldrStatus))}>
              <Lightbulb className="w-8 h-8 mb-1" />
              <p className="text-xs font-medium capitalize">{sensorData.ldrStatus}</p>
            </div>
          </div>

          {/* Visual Indicator */}
          <div className="h-3 bg-secondary rounded-full overflow-hidden">
            <div
              className="h-full bg-gradient-to-r from-[#007BFF] via-[#00D9A5] to-[#F59E0B] transition-all duration-500"
              style={{ width: `${(sensorData.ldrValue / 1024) * 100}%` }}
            />
          </div>
          <div className="flex justify-between text-xs text-muted-foreground">
            <span>Dark</span>
            <span>Dim</span>
            <span>Bright</span>
          </div>
        </div>
      </section>

      {/* PWM LED Control */}
      <section className="glass-card p-5">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-[#00D9A5]/20 flex items-center justify-center">
              <Settings2 className="w-5 h-5 text-[#00D9A5]" />
            </div>
            <div>
              <h3 className="font-semibold text-foreground">PWM LED Control</h3>
              <p className="text-xs text-muted-foreground">Indicator brightness</p>
            </div>
          </div>
          <div className="flex items-center gap-2">
            <span className="text-xs text-muted-foreground">Auto</span>
            <Switch
              checked={autoMode}
              onCheckedChange={setAutoMode}
              className="data-[state=checked]:bg-[#00D9A5]"
            />
          </div>
        </div>

        <div className={cn("space-y-4 transition-opacity", autoMode && "opacity-50 pointer-events-none")}>
          <div className="flex items-center justify-between">
            <span className="text-sm text-muted-foreground">Intensity</span>
            <span className="text-sm font-medium gradient-text">{pwmIntensity[0]}%</span>
          </div>
          <Slider
            value={pwmIntensity}
            onValueChange={setPwmIntensity}
            max={100}
            step={1}
            className="[&_[role=slider]]:bg-gradient-to-r [&_[role=slider]]:from-[#00D9A5] [&_[role=slider]]:to-[#00C4D9]"
          />
          <div className="flex justify-between text-xs text-muted-foreground">
            <span>Off</span>
            <span>50%</span>
            <span>Max</span>
          </div>
        </div>
      </section>

      {/* Manual Alarm Trigger */}
      <section className="glass-card p-5">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 rounded-2xl bg-red-500/20 flex items-center justify-center">
            <Bell className="w-5 h-5 text-red-500" />
          </div>
          <div>
            <h3 className="font-semibold text-foreground">Manual Alarm</h3>
            <p className="text-xs text-muted-foreground">Test medication reminder</p>
          </div>
        </div>

        <div className="flex items-center justify-between p-4 rounded-2xl bg-secondary/50 mb-4">
          <div>
            <p className="text-sm text-muted-foreground">Alarm Status</p>
            <p className={cn("text-sm font-medium", sensorData.alarmActive ? "text-red-500" : "text-[#22C55E]")}>
              {sensorData.alarmActive ? "Active" : "Inactive"}
            </p>
          </div>
          <div className={cn(
            "w-4 h-4 rounded-full transition-colors",
            sensorData.alarmActive ? "bg-red-500 animate-pulse" : "bg-[#22C55E]"
          )} />
        </div>

        <Button
          onClick={handleTriggerAlarm}
          disabled={alarmTriggered}
          className={cn(
            "w-full bg-red-500 hover:bg-red-600 text-white font-medium",
            alarmTriggered && "animate-pulse"
          )}
        >
          <Bell className="w-4 h-4 mr-2" />
          {alarmTriggered ? "Alarm Triggered!" : "Trigger Manual Alarm"}
        </Button>
      </section>

      {/* Device Info */}
      <section className="glass-card p-5">
        <h3 className="font-semibold text-foreground mb-4">Device Information</h3>
        <div className="space-y-3">
          {[
            { label: "Firmware Version", value: "v1.2.3" },
            { label: "MAC Address", value: "A4:CF:12:XX:XX:XX" },
            { label: "IP Address", value: "192.168.1.105" },
            { label: "Uptime", value: "5 days, 12 hours" },
          ].map((item) => (
            <div key={item.label} className="flex items-center justify-between py-2 border-b border-border last:border-0">
              <span className="text-sm text-muted-foreground">{item.label}</span>
              <span className="text-sm font-medium text-foreground">{item.value}</span>
            </div>
          ))}
        </div>
      </section>
    </div>
  )
}
