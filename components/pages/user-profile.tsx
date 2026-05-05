"use client"

import { useState } from "react"
import {
  User,
  Database,
  Volume2,
  Bell,
  Shield,
  ChevronRight,
  LogOut,
  Check,
  Cloud,
  Mic,
} from "lucide-react"
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
import { Switch } from "@/components/ui/switch"
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"

interface UserSettings {
  notifications: boolean
  voiceAlerts: boolean
  autoSync: boolean
  darkMode: boolean
}

export function UserProfile() {
  const [settings, setSettings] = useState<UserSettings>({
    notifications: true,
    voiceAlerts: true,
    autoSync: true,
    darkMode: true,
  })
  const [firebaseDialog, setFirebaseDialog] = useState(false)
  const [voiceDialog, setVoiceDialog] = useState(false)
  const [syncStatus, setSyncStatus] = useState<"synced" | "syncing" | "error">("synced")

  const [firebaseConfig, setFirebaseConfig] = useState({
    projectId: "cureconnect-xxxxx",
    databaseUrl: "https://cureconnect-xxxxx.firebaseio.com",
    apiKey: "AIza...",
  })

  const [voiceSettings, setVoiceSettings] = useState({
    apiKey: "sk-...",
    voiceId: "rachel",
    language: "en-US",
  })

  const handleSync = () => {
    setSyncStatus("syncing")
    setTimeout(() => setSyncStatus("synced"), 2000)
  }

  const updateSetting = (key: keyof UserSettings, value: boolean) => {
    setSettings({ ...settings, [key]: value })
  }

  return (
    <div className="flex flex-col gap-6 pb-32">
      {/* Header */}
      <header>
        <h1 className="text-2xl font-bold text-foreground">Settings</h1>
        <p className="text-sm text-muted-foreground">Manage your profile and preferences</p>
      </header>

      {/* Profile Card */}
      <div className="glass-card p-5">
        <div className="flex items-center gap-4">
          <div className="w-20 h-20 rounded-full bg-gradient-to-br from-[#00D9A5] to-[#00C4D9] flex items-center justify-center text-black font-bold text-2xl">
            MA
          </div>
          <div className="flex-1">
            <h2 className="text-xl font-bold text-foreground">Moamen Abdel-Fattah</h2>
            <p className="text-sm text-muted-foreground">moamen@example.com</p>
            <div className="flex items-center gap-2 mt-2">
              <div className="w-2 h-2 rounded-full bg-[#22C55E]" />
              <span className="text-xs text-[#22C55E]">Active Patient</span>
            </div>
          </div>
          <Button variant="ghost" size="icon" className="text-muted-foreground">
            <ChevronRight className="w-5 h-5" />
          </Button>
        </div>
      </div>

      {/* Firebase Sync Status */}
      <section className="glass-card p-5">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-[#F59E0B]/20 flex items-center justify-center">
              <Cloud className="w-5 h-5 text-[#F59E0B]" />
            </div>
            <div>
              <h3 className="font-semibold text-foreground">Firebase Sync</h3>
              <p className="text-xs text-muted-foreground">Realtime Database</p>
            </div>
          </div>
          <div className={cn(
            "flex items-center gap-2 px-3 py-1 rounded-full text-xs font-medium",
            syncStatus === "synced" && "bg-[#22C55E]/20 text-[#22C55E]",
            syncStatus === "syncing" && "bg-[#007BFF]/20 text-[#007BFF]",
            syncStatus === "error" && "bg-red-500/20 text-red-500"
          )}>
            {syncStatus === "synced" && <Check className="w-3 h-3" />}
            {syncStatus === "syncing" && <div className="w-3 h-3 border-2 border-current border-t-transparent rounded-full animate-spin" />}
            <span className="capitalize">{syncStatus}</span>
          </div>
        </div>

        <div className="flex gap-3">
          <Button
            onClick={handleSync}
            disabled={syncStatus === "syncing"}
            className="flex-1 bg-gradient-to-r from-[#00D9A5] to-[#00C4D9] text-black hover:opacity-90"
          >
            {syncStatus === "syncing" ? "Syncing..." : "Sync Now"}
          </Button>
          <Dialog open={firebaseDialog} onOpenChange={setFirebaseDialog}>
            <DialogTrigger asChild>
              <Button variant="outline" className="border-border text-foreground bg-transparent hover:bg-secondary">
                Configure
              </Button>
            </DialogTrigger>
            <DialogContent className="bg-card border-border">
              <DialogHeader>
                <DialogTitle className="text-foreground">Firebase Configuration</DialogTitle>
              </DialogHeader>
              <div className="flex flex-col gap-4 pt-4">
                <div className="space-y-2">
                  <Label className="text-foreground">Project ID</Label>
                  <Input
                    value={firebaseConfig.projectId}
                    onChange={(e) => setFirebaseConfig({ ...firebaseConfig, projectId: e.target.value })}
                    className="bg-secondary border-border text-foreground"
                  />
                </div>
                <div className="space-y-2">
                  <Label className="text-foreground">Database URL</Label>
                  <Input
                    value={firebaseConfig.databaseUrl}
                    onChange={(e) => setFirebaseConfig({ ...firebaseConfig, databaseUrl: e.target.value })}
                    className="bg-secondary border-border text-foreground"
                  />
                </div>
                <div className="space-y-2">
                  <Label className="text-foreground">API Key</Label>
                  <Input
                    type="password"
                    value={firebaseConfig.apiKey}
                    onChange={(e) => setFirebaseConfig({ ...firebaseConfig, apiKey: e.target.value })}
                    className="bg-secondary border-border text-foreground"
                  />
                </div>
                <Button
                  onClick={() => setFirebaseDialog(false)}
                  className="mt-2 bg-gradient-to-r from-[#00D9A5] to-[#00C4D9] text-black hover:opacity-90"
                >
                  Save Configuration
                </Button>
              </div>
            </DialogContent>
          </Dialog>
        </div>
      </section>

      {/* ElevenLabs Voice Settings */}
      <section className="glass-card p-5">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-[#007BFF]/20 flex items-center justify-center">
              <Mic className="w-5 h-5 text-[#007BFF]" />
            </div>
            <div>
              <h3 className="font-semibold text-foreground">Voice Preferences</h3>
              <p className="text-xs text-muted-foreground">ElevenLabs API</p>
            </div>
          </div>
          <Dialog open={voiceDialog} onOpenChange={setVoiceDialog}>
            <DialogTrigger asChild>
              <Button variant="ghost" size="icon" className="text-muted-foreground">
                <ChevronRight className="w-5 h-5" />
              </Button>
            </DialogTrigger>
            <DialogContent className="bg-card border-border">
              <DialogHeader>
                <DialogTitle className="text-foreground">Voice Settings</DialogTitle>
              </DialogHeader>
              <div className="flex flex-col gap-4 pt-4">
                <div className="space-y-2">
                  <Label className="text-foreground">ElevenLabs API Key</Label>
                  <Input
                    type="password"
                    value={voiceSettings.apiKey}
                    onChange={(e) => setVoiceSettings({ ...voiceSettings, apiKey: e.target.value })}
                    className="bg-secondary border-border text-foreground"
                  />
                </div>
                <div className="space-y-2">
                  <Label className="text-foreground">Voice</Label>
                  <Select
                    value={voiceSettings.voiceId}
                    onValueChange={(value) => setVoiceSettings({ ...voiceSettings, voiceId: value })}
                  >
                    <SelectTrigger className="bg-secondary border-border text-foreground">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent className="bg-card border-border">
                      <SelectItem value="rachel">Rachel (Female)</SelectItem>
                      <SelectItem value="adam">Adam (Male)</SelectItem>
                      <SelectItem value="josh">Josh (Male)</SelectItem>
                      <SelectItem value="bella">Bella (Female)</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label className="text-foreground">Language</Label>
                  <Select
                    value={voiceSettings.language}
                    onValueChange={(value) => setVoiceSettings({ ...voiceSettings, language: value })}
                  >
                    <SelectTrigger className="bg-secondary border-border text-foreground">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent className="bg-card border-border">
                      <SelectItem value="en-US">English (US)</SelectItem>
                      <SelectItem value="en-GB">English (UK)</SelectItem>
                      <SelectItem value="ar-EG">Arabic (Egypt)</SelectItem>
                      <SelectItem value="es-ES">Spanish</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <Button
                  onClick={() => setVoiceDialog(false)}
                  className="mt-2 bg-gradient-to-r from-[#00D9A5] to-[#00C4D9] text-black hover:opacity-90"
                >
                  Save Settings
                </Button>
              </div>
            </DialogContent>
          </Dialog>
        </div>
      </section>

      {/* Quick Settings */}
      <section className="glass-card p-5 space-y-4">
        <h3 className="font-semibold text-foreground">Quick Settings</h3>
        
        {[
          { key: "notifications", icon: Bell, label: "Push Notifications", description: "Medication reminders" },
          { key: "voiceAlerts", icon: Volume2, label: "Voice Alerts", description: "Spoken reminders via ESP32" },
          { key: "autoSync", icon: Database, label: "Auto Sync", description: "Sync data automatically" },
          { key: "darkMode", icon: Shield, label: "Dark Mode", description: "Always enabled" },
        ].map((setting) => {
          const Icon = setting.icon
          return (
            <div key={setting.key} className="flex items-center justify-between py-2">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-2xl bg-secondary flex items-center justify-center">
                  <Icon className="w-5 h-5 text-[#00D9A5]" />
                </div>
                <div>
                  <p className="text-sm font-medium text-foreground">{setting.label}</p>
                  <p className="text-xs text-muted-foreground">{setting.description}</p>
                </div>
              </div>
              <Switch
                checked={settings[setting.key as keyof UserSettings]}
                onCheckedChange={(checked) => updateSetting(setting.key as keyof UserSettings, checked)}
                disabled={setting.key === "darkMode"}
                className="data-[state=checked]:bg-[#00D9A5]"
              />
            </div>
          )
        })}
      </section>

      {/* Account Actions */}
      <section className="space-y-3">
        <Button
          variant="outline"
          className="w-full justify-start gap-3 h-14 border-border text-foreground bg-transparent hover:bg-secondary"
        >
          <User className="w-5 h-5" />
          <span>Edit Profile</span>
          <ChevronRight className="w-4 h-4 ml-auto" />
        </Button>
        <Button
          variant="outline"
          className="w-full justify-start gap-3 h-14 border-border text-foreground bg-transparent hover:bg-secondary"
        >
          <Shield className="w-5 h-5" />
          <span>Privacy & Security</span>
          <ChevronRight className="w-4 h-4 ml-auto" />
        </Button>
        <Button
          variant="outline"
          className="w-full justify-start gap-3 h-14 border-red-500/50 text-red-500 bg-transparent hover:bg-red-500/10"
        >
          <LogOut className="w-5 h-5" />
          <span>Sign Out</span>
        </Button>
      </section>

      {/* App Info */}
      <div className="text-center py-4">
        <p className="text-sm text-muted-foreground">CureConnect v1.0.0</p>
        <p className="text-xs text-muted-foreground">Smart Medication Organizer</p>
      </div>
    </div>
  )
}
