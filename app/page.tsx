"use client"

import { useEffect, useMemo, useRef, useState } from "react"
import type { ReactNode } from "react"
import {
  AlertTriangle,
  Apple,
  AudioLines,
  BadgeCheck,
  BellRing,
  Check,
  ChevronRight,
  Clock3,
  Cpu,
  Cross,
  Globe,
  HeartHandshake,
  Languages,
  LoaderCircle,
  LocateFixed,
  Mail,
  MapPinned,
  Mic2,
  MoonStar,
  Pill,
  Play,
  RefreshCw,
  ShieldAlert,
  SunMedium,
  Wifi,
} from "lucide-react"

type Language = "en" | "ar"
type Theme = "light" | "dark"
type AuthView = "login" | "signup" | "forgot"
type TabKey = "locator" | "organizer" | "emergency"

type DrawerConfig = {
  id: number
  medicine: string
  time: string
  pillCount: number
  voiceText: string
  enabled: boolean
}

type Guardian = {
  name: string
  relation: string
  phone: string
}

type Esp32Status = {
  connected: boolean
  wifiStrength: number
  syncState: "live" | "degraded" | "offline"
  irDetected: boolean
  lastSeen: string
  lastIrDetection: string | null
  firmware: string
}

type Pharmacy = {
  name: string
  address: string
  phone: string
  eta: string
  lat: number
  lng: number
}

declare global {
  interface Window {
    google?: any
  }
}

const DRAWERS: DrawerConfig[] = Array.from({ length: 10 }, (_, index) => ({
  id: index + 1,
  medicine: index === 0 ? "Metformin XR" : index === 1 ? "Vitamin D3" : "",
  time: index === 0 ? "08:00" : index === 1 ? "20:30" : "09:00",
  pillCount: index === 0 ? 24 : index === 1 ? 12 : 30,
  voiceText:
    index === 0
      ? "Good morning. Please take one Metformin tablet from drawer one."
      : "Your scheduled medicine is ready.",
  enabled: index < 3,
}))

const FALLBACK_PHARMACIES: Pharmacy[] = [
  {
    name: "Al Noor Pharmacy",
    address: "24 Smart Health Ave",
    phone: "+20 100 420 8800",
    eta: "4 min",
    lat: 30.0444,
    lng: 31.2357,
  },
  {
    name: "Care Point Pharmacy",
    address: "18 Nile Medical Plaza",
    phone: "+20 100 777 1900",
    eta: "6 min",
    lat: 30.0471,
    lng: 31.2385,
  },
  {
    name: "Seha 24/7 Pharmacy",
    address: "5 CureConnect Boulevard",
    phone: "+20 100 520 5544",
    eta: "8 min",
    lat: 30.041,
    lng: 31.23,
  },
]

const COPY = {
  en: {
    appName: "CureConnect",
    tagline: "Smart medicine organizer synced with your ESP32 ecosystem.",
    signIn: "Sign In",
    signUp: "Sign Up",
    forgotPassword: "Forgot Password",
    email: "Email",
    password: "Password",
    confirmPassword: "Confirm Password",
    fullName: "Full Name",
    macAddress: "Link to ESP32 Device (MAC Address)",
    continue: "Continue",
    sendReset: "Send Reset Link",
    useGoogle: "Sign in with Google",
    useApple: "Sign in with Apple",
    useEmail: "Sign in with Email / Password",
    nearbyPharmacies: "Nearby Pharmacies",
    locationPermission: "Enable Location",
    refreshLocation: "Refresh Location",
    smartLocator: "Smart Pharmacy Locator",
    organizer: "Smart Drawer Organizer",
    emergency: "Emergency Smart Hub",
    drawer: "Drawer",
    medicineName: "Medicine Name",
    pillCount: "Pill Count",
    wifiConnection: "Wi-Fi Connection",
    espSync: "ESP32 Sync",
    generateAudio: "Generate & Test Audio",
    voiceSample: "Voice Sample",
    manualConfirm: "Confirm Pill Taken",
    guardian: "Emergency Guardian",
    testAlert: "Test Alert",
    pillTaken: "Pill Taken",
    hardwareError: "Hardware error alert ready",
  },
  ar: {
    appName: "كيور كونيكت",
    tagline: "منظم دواء ذكي متصل مباشرة بجهاز ESP32 عبر الشبكة.",
    signIn: "تسجيل الدخول",
    signUp: "إنشاء حساب",
    forgotPassword: "نسيت كلمة المرور",
    email: "البريد الإلكتروني",
    password: "كلمة المرور",
    confirmPassword: "تأكيد كلمة المرور",
    fullName: "الاسم الكامل",
    macAddress: "ربط جهاز ESP32 بعنوان MAC",
    continue: "متابعة",
    sendReset: "إرسال رابط الاستعادة",
    useGoogle: "الدخول باستخدام Google",
    useApple: "الدخول باستخدام Apple",
    useEmail: "الدخول بالبريد وكلمة المرور",
    nearbyPharmacies: "الصيدليات القريبة",
    locationPermission: "تفعيل الموقع",
    refreshLocation: "تحديث الموقع",
    smartLocator: "محدد الصيدليات الذكي",
    organizer: "منظم الأدراج الذكي",
    emergency: "مركز الطوارئ الذكي",
    drawer: "الدرج",
    medicineName: "اسم الدواء",
    pillCount: "عدد الحبات",
    wifiConnection: "اتصال الواي فاي",
    espSync: "مزامنة ESP32",
    generateAudio: "إنشاء واختبار الصوت",
    voiceSample: "عينة صوتية",
    manualConfirm: "تأكيد تناول الدواء",
    guardian: "جهة اتصال الطوارئ",
    testAlert: "اختبار التنبيه",
    pillTaken: "تم تناول الدواء",
    hardwareError: "تنبيه خطأ الجهاز جاهز",
  },
} as const

export default function Page() {
  const [language, setLanguage] = useState<Language>("en")
  const [theme, setTheme] = useState<Theme>("dark")
  const [authView, setAuthView] = useState<AuthView>("login")
  const [isAuthenticated, setIsAuthenticated] = useState(false)
  const [activeTab, setActiveTab] = useState<TabKey>("locator")
  const [drawers, setDrawers] = useState<DrawerConfig[]>(DRAWERS)
  const [selectedDrawerId, setSelectedDrawerId] = useState<number>(1)
  const [voiceText, setVoiceText] = useState(DRAWERS[0].voiceText)
  const [deviceEndpoint, setDeviceEndpoint] = useState(process.env.NEXT_PUBLIC_ESP32_BASE_URL ?? "http://192.168.4.1")
  const [elevenLabsMessage, setElevenLabsMessage] = useState("Audio generation ready")
  const [audioUrl, setAudioUrl] = useState("")
  const [isGeneratingAudio, setIsGeneratingAudio] = useState(false)
  const [pharmacies, setPharmacies] = useState<Pharmacy[]>(FALLBACK_PHARMACIES)
  const [locationState, setLocationState] = useState("Waiting for permission")
  const [status, setStatus] = useState<Esp32Status>({
    connected: true,
    wifiStrength: 92,
    syncState: "live",
    irDetected: false,
    lastSeen: new Date().toISOString(),
    lastIrDetection: null,
    firmware: "v2.8.4",
  })
  const [logs, setLogs] = useState<string[]>([
    "08:00 AM - Drawer 1 reminder armed",
    "08:02 AM - ESP32 heartbeat synced over Wi-Fi",
  ])
  const [countdown, setCountdown] = useState<number | null>(null)
  const [guardian, setGuardian] = useState<Guardian>({
    name: "Lina Hassan",
    relation: "Sister",
    phone: "+20 100 111 2233",
  })
  const [mapReady, setMapReady] = useState(false)
  const mapRef = useRef<HTMLDivElement | null>(null)
  const mapInstanceRef = useRef<any>(null)
  const t = COPY[language]
  const selectedDrawer = useMemo(
    () => drawers.find((drawer) => drawer.id === selectedDrawerId) ?? drawers[0],
    [drawers, selectedDrawerId],
  )

  useEffect(() => {
    document.documentElement.lang = language
    document.documentElement.dir = language === "ar" ? "rtl" : "ltr"
  }, [language])

  useEffect(() => {
    document.documentElement.classList.toggle("dark", theme === "dark")
    document.documentElement.classList.toggle("light", theme === "light")
  }, [theme])

  useEffect(() => {
    setVoiceText(selectedDrawer.voiceText)
  }, [selectedDrawer])

  useEffect(() => {
    if (countdown === null) {
      return
    }
    if (countdown === 0) {
      setLogs((current) => [
        `${formatTime(new Date())} - Test guardian alert sent to ${guardian.name}`,
        ...current,
      ])
      setCountdown(null)
      return
    }
    const timer = window.setTimeout(() => setCountdown((value) => (value ?? 1) - 1), 1000)
    return () => window.clearTimeout(timer)
  }, [countdown, guardian.name])

  useEffect(() => {
    const interval = window.setInterval(async () => {
      try {
        const response = await fetch(`${deviceEndpoint}/status`, { cache: "no-store" })
        if (!response.ok) {
          throw new Error("Device offline")
        }
        const data = (await response.json()) as Partial<Esp32Status>
        const nextStatus: Esp32Status = {
          connected: Boolean(data.connected ?? true),
          wifiStrength: Number(data.wifiStrength ?? 91),
          syncState: (data.syncState as Esp32Status["syncState"]) ?? "live",
          irDetected: Boolean(data.irDetected ?? false),
          lastSeen: data.lastSeen ?? new Date().toISOString(),
          lastIrDetection: data.lastIrDetection ?? null,
          firmware: data.firmware ?? "v2.8.4",
        }
        setStatus(nextStatus)
        if (nextStatus.irDetected && nextStatus.lastIrDetection) {
          maybeLogIrConfirmation(nextStatus.lastIrDetection)
        }
      } catch {
        setStatus((current) => ({
          ...current,
          connected: false,
          syncState: "degraded",
          lastSeen: new Date().toISOString(),
        }))
      }
    }, 5000)

    return () => window.clearInterval(interval)
  }, [deviceEndpoint, drawers])

  useEffect(() => {
    if (!isAuthenticated) {
      return
    }
    const apiKey = process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY
    if (!apiKey || !mapRef.current) {
      return
    }

    const existing = document.querySelector<HTMLScriptElement>('script[data-google-maps="true"]')
    const initMap = () => {
      if (!window.google || !mapRef.current || mapInstanceRef.current) {
        return
      }
      const map = new window.google.maps.Map(mapRef.current, {
        center: { lat: pharmacies[0].lat, lng: pharmacies[0].lng },
        zoom: 14,
        disableDefaultUI: true,
        styles: theme === "dark" ? darkMapStyles : lightMapStyles,
      })
      mapInstanceRef.current = map
      pharmacies.forEach((pharmacy) => {
        new window.google.maps.Marker({
          position: { lat: pharmacy.lat, lng: pharmacy.lng },
          map,
          title: pharmacy.name,
        })
      })
      setMapReady(true)
    }

    if (existing) {
      existing.addEventListener("load", initMap)
      initMap()
      return () => existing.removeEventListener("load", initMap)
    }

    const script = document.createElement("script")
    script.src = `https://maps.googleapis.com/maps/api/js?key=${apiKey}`
    script.async = true
    script.defer = true
    script.dataset.googleMaps = "true"
    script.addEventListener("load", initMap)
    document.body.appendChild(script)

    return () => script.removeEventListener("load", initMap)
  }, [isAuthenticated, pharmacies, theme])

  const maybeLogIrConfirmation = (isoTime: string) => {
    const now = new Date(isoTime)
    const withinWindow = drawers.some((drawer) => {
      const [hours, minutes] = drawer.time.split(":").map(Number)
      const alarm = new Date(now)
      alarm.setHours(hours, minutes, 0, 0)
      return Math.abs(now.getTime() - alarm.getTime()) <= 5 * 60 * 1000
    })

    if (!withinWindow) {
      return
    }

    const entry = `${formatTime(now)} - ${t.pillTaken} via IR sensor proximity`
    setLogs((current) => (current.includes(entry) ? current : [entry, ...current]))
  }

  const handleAuth = () => {
    setIsAuthenticated(true)
  }

  const handleDrawerUpdate = (field: keyof DrawerConfig, value: string | number | boolean) => {
    setDrawers((current) =>
      current.map((drawer) =>
        drawer.id === selectedDrawerId
          ? {
              ...drawer,
              [field]: value,
              ...(field === "voiceText" ? { voiceText: String(value) } : {}),
            }
          : drawer,
      ),
    )
  }

  const requestLocation = () => {
    if (!navigator.geolocation) {
      setLocationState("Location services unavailable in this browser")
      return
    }
    setLocationState("Requesting precise location...")
    navigator.geolocation.getCurrentPosition(
      (position) => {
        const { latitude, longitude } = position.coords
        setPharmacies(
          FALLBACK_PHARMACIES.map((pharmacy, index) => ({
            ...pharmacy,
            lat: latitude + index * 0.004,
            lng: longitude + index * 0.004,
          })),
        )
        setLocationState(`Live location synced at ${formatTime(new Date())}`)
      },
      () => setLocationState("Permission denied. Showing curated pharmacy network."),
      { enableHighAccuracy: true, timeout: 10000 },
    )
  }

  const handleGenerateAudio = async () => {
    setIsGeneratingAudio(true)
    setElevenLabsMessage("Generating voice prompt...")
    setAudioUrl("")
    try {
      const response = await fetch("/api/elevenlabs/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          text: voiceText,
          voiceName: selectedDrawer.medicine || `Drawer ${selectedDrawer.id} Voice`,
        }),
      })
      const data = await response.json()
      if (!response.ok) {
        throw new Error(data.error || "Unable to generate audio")
      }
      setAudioUrl(data.audioUrl)
      setElevenLabsMessage(data.message || "Voice prompt generated successfully")
    } catch (error) {
      setElevenLabsMessage(error instanceof Error ? error.message : "Audio generation failed")
    } finally {
      setIsGeneratingAudio(false)
    }
  }

  const connectContacts = async () => {
    const contactsApi = (navigator as Navigator & { contacts?: unknown }).contacts as
      | {
          select: (
            properties: string[],
            options: { multiple: boolean },
          ) => Promise<Array<{ name?: string[]; tel?: string[] }>>
        }
      | undefined

    if (!contactsApi?.select) {
      setLogs((current) => [
        `${formatTime(new Date())} - Contacts API unavailable, using manual guardian card`,
        ...current,
      ])
      return
    }

    try {
      const results = await contactsApi.select(["name", "tel"], { multiple: false })
      const first = results[0]
      if (!first) {
        return
      }
      setGuardian({
        name: first.name?.[0] ?? guardian.name,
        relation: guardian.relation,
        phone: first.tel?.[0] ?? guardian.phone,
      })
    } catch {
      setLogs((current) => [`${formatTime(new Date())} - Contact selection canceled`, ...current])
    }
  }

  if (!isAuthenticated) {
    return (
      <main className="app-shell">
        <div className="mobile-frame">
          <TopUtilities
            language={language}
            onLanguageToggle={() => setLanguage((current) => (current === "en" ? "ar" : "en"))}
            theme={theme}
            onThemeToggle={() => setTheme((current) => (current === "dark" ? "light" : "dark"))}
          />
          <section className="hero-panel">
            <div className="hero-badge">
              <Cross className="h-4 w-4" />
              <span>{t.appName}</span>
            </div>
            <h1>{t.appName}</h1>
            <p>{t.tagline}</p>
            <div className="hero-grid">
              <FeatureChip icon={<Wifi className="h-4 w-4" />} label="ESP32 Wi-Fi Sync" />
              <FeatureChip icon={<AudioLines className="h-4 w-4" />} label="ElevenLabs Voice AI" />
              <FeatureChip icon={<MapPinned className="h-4 w-4" />} label="Google Maps Locator" />
            </div>
          </section>
          <AuthCard
            authView={authView}
            setAuthView={setAuthView}
            onSubmit={handleAuth}
            labels={t}
            language={language}
            deviceEndpoint={deviceEndpoint}
            setDeviceEndpoint={setDeviceEndpoint}
          />
        </div>
      </main>
    )
  }

  return (
    <main className="app-shell">
      <div className="mobile-frame">
        <TopUtilities
          language={language}
          onLanguageToggle={() => setLanguage((current) => (current === "en" ? "ar" : "en"))}
          theme={theme}
          onThemeToggle={() => setTheme((current) => (current === "dark" ? "light" : "dark"))}
        />

        <section className="overview-card">
          <div>
            <span className="eyebrow">{t.appName}</span>
            <h1>{activeTab === "locator" ? t.smartLocator : activeTab === "organizer" ? t.organizer : t.emergency}</h1>
            <p>Live medication orchestration, hardware-aware reminders, and guardian safety workflows.</p>
          </div>
          <div className="status-orb">
            <BadgeCheck className="h-6 w-6" />
          </div>
        </section>

        <section className="segment-tabs">
          {[
            { key: "locator", label: t.smartLocator, icon: <MapPinned className="h-4 w-4" /> },
            { key: "organizer", label: t.organizer, icon: <Pill className="h-4 w-4" /> },
            { key: "emergency", label: t.emergency, icon: <ShieldAlert className="h-4 w-4" /> },
          ].map((tab) => (
            <button
              key={tab.key}
              className={`segment-tab ${activeTab === tab.key ? "active" : ""}`}
              onClick={() => setActiveTab(tab.key as TabKey)}
            >
              {tab.icon}
              <span>{tab.label}</span>
            </button>
          ))}
        </section>

        {activeTab === "locator" && (
          <section className="page-stack">
            <InfoCard
              title={t.nearbyPharmacies}
              subtitle={locationState}
              action={
                <button className="chip-button" onClick={requestLocation}>
                  <LocateFixed className="h-4 w-4" />
                  {t.locationPermission}
                </button>
              }
            />
            <div className="map-card">
              <div className="map-header">
                <div>
                  <h2>{t.smartLocator}</h2>
                  <p>Google Maps API ready{mapReady ? " and rendering live markers." : ". Add an API key for live map canvas."}</p>
                </div>
                <button className="fab-button" onClick={requestLocation}>
                  <RefreshCw className="h-4 w-4" />
                  {t.refreshLocation}
                </button>
              </div>
              {process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY ? (
                <div className="map-surface" ref={mapRef} />
              ) : (
                <div className="map-fallback">
                  <MapPinned className="h-8 w-8" />
                  <p>Set `NEXT_PUBLIC_GOOGLE_MAPS_API_KEY` to render the interactive Google map.</p>
                </div>
              )}
            </div>
            <div className="list-stack">
              {pharmacies.map((pharmacy) => (
                <article key={pharmacy.name} className="glass-card entry-card">
                  <div>
                    <h3>{pharmacy.name}</h3>
                    <p>{pharmacy.address}</p>
                    <span>{pharmacy.phone}</span>
                  </div>
                  <div className="entry-meta">
                    <span>{pharmacy.eta}</span>
                    <ChevronRight className="h-4 w-4" />
                  </div>
                </article>
              ))}
            </div>
          </section>
        )}

        {activeTab === "organizer" && (
          <section className="page-stack">
            <div className="status-grid">
              <StatusPill icon={<Wifi className="h-4 w-4" />} label={t.wifiConnection} value={status.connected ? "Connected" : "Disconnected"} />
              <StatusPill icon={<Cpu className="h-4 w-4" />} label={t.espSync} value={status.syncState} />
              <StatusPill icon={<Clock3 className="h-4 w-4" />} label="Firmware" value={status.firmware} />
            </div>

            <div className="drawer-grid">
              {drawers.map((drawer) => (
                <button
                  key={drawer.id}
                  className={`glass-card drawer-card ${selectedDrawerId === drawer.id ? "selected" : ""}`}
                  onClick={() => setSelectedDrawerId(drawer.id)}
                >
                  <div className="drawer-topline">
                    <span>{t.drawer} {drawer.id}</span>
                    <span className={`drawer-toggle ${drawer.enabled ? "on" : "off"}`}>{drawer.enabled ? "ON" : "OFF"}</span>
                  </div>
                  <strong>{drawer.medicine || "Unassigned"}</strong>
                  <p>{drawer.time}</p>
                </button>
              ))}
            </div>

            <div className="glass-card detail-card">
              <div className="detail-header">
                <div>
                  <h2>{t.drawer} {selectedDrawer.id}</h2>
                  <p>Configure alarms, audio prompts, and hardware-aware confirmation logic.</p>
                </div>
                <button
                  className={`mini-switch ${selectedDrawer.enabled ? "enabled" : ""}`}
                  onClick={() => handleDrawerUpdate("enabled", !selectedDrawer.enabled)}
                >
                  <span />
                </button>
              </div>

              <label className="field">
                <span>{t.medicineName}</span>
                <input
                  value={selectedDrawer.medicine}
                  onChange={(event) => handleDrawerUpdate("medicine", event.target.value)}
                  placeholder="Aspirin 100mg"
                />
              </label>

              <div className="two-col">
                <label className="field">
                  <span>Alarm Time</span>
                  <input
                    type="time"
                    value={selectedDrawer.time}
                    onChange={(event) => handleDrawerUpdate("time", event.target.value)}
                  />
                </label>
                <label className="field">
                  <span>{t.pillCount}</span>
                  <input
                    type="number"
                    value={selectedDrawer.pillCount}
                    onChange={(event) => handleDrawerUpdate("pillCount", Number(event.target.value))}
                  />
                </label>
              </div>

              <label className="field">
                <span>Voice AI Script</span>
                <textarea
                  value={voiceText}
                  onChange={(event) => {
                    setVoiceText(event.target.value)
                    handleDrawerUpdate("voiceText", event.target.value)
                  }}
                  rows={4}
                />
              </label>

              <label className="upload-zone">
                <Mic2 className="h-5 w-5" />
                <span>{t.voiceSample}</span>
                <small>Drop a sample or tap to select. ElevenLabs route uses your server-side API key.</small>
                <input type="file" accept="audio/*" />
              </label>

              <button className="primary-button" onClick={handleGenerateAudio} disabled={isGeneratingAudio}>
                {isGeneratingAudio ? <LoaderCircle className="h-4 w-4 animate-spin" /> : <Play className="h-4 w-4" />}
                {t.generateAudio}
              </button>

              <div className="inline-status">
                <AudioLines className="h-4 w-4" />
                <span>{elevenLabsMessage}</span>
              </div>

              {audioUrl ? <audio controls className="audio-player" src={audioUrl} /> : null}

              <div className="hardware-strip">
                <div>
                  <span>IR Sensor</span>
                  <strong>{status.irDetected ? "Proximity detected" : "Awaiting event"}</strong>
                </div>
                <div>
                  <span>Last sync</span>
                  <strong>{formatTime(new Date(status.lastSeen))}</strong>
                </div>
              </div>

              <button
                className="confirm-button"
                onClick={() =>
                  setLogs((current) => [
                    `${formatTime(new Date())} - Manual checkmark confirmation for drawer ${selectedDrawer.id}`,
                    ...current,
                  ])
                }
              >
                <Check className="h-7 w-7" />
                {t.manualConfirm}
              </button>
            </div>

            <div className="glass-card log-card">
              <div className="detail-header">
                <div>
                  <h2>IR Confirmation Log</h2>
                  <p>{t.pillTaken} is recorded automatically when ESP32 proximity arrives within five minutes of the alarm.</p>
                </div>
              </div>
              <div className="log-list">
                {logs.map((entry) => (
                  <div key={entry} className="log-entry">
                    <BadgeCheck className="h-4 w-4" />
                    <span>{entry}</span>
                  </div>
                ))}
              </div>
            </div>
          </section>
        )}

        {activeTab === "emergency" && (
          <section className="page-stack">
            <InfoCard
              title={t.guardian}
              subtitle={`${guardian.name} · ${guardian.relation} · ${guardian.phone}`}
              action={
                <button className="chip-button" onClick={connectContacts}>
                  <HeartHandshake className="h-4 w-4" />
                  Access Contacts
                </button>
              }
            />
            <div className="glass-card emergency-card">
              <div className="emergency-core">
                <div className="emergency-icon">
                  <BellRing className="h-7 w-7" />
                </div>
                <div>
                  <h2>{t.hardwareError}</h2>
                  <p>When the ESP32 reports drawer jam, offline power, or sensor failure, the guardian receives an app and SMS escalation flow.</p>
                </div>
              </div>
              <div className="alert-preview">
                <span>Auto message preview</span>
                <p>
                  CureConnect Alert: Drawer hardware issue detected. Please check on the patient and app status immediately.
                </p>
              </div>
              <button className="danger-button" onClick={() => setCountdown(5)}>
                <AlertTriangle className="h-4 w-4" />
                {countdown === null ? t.testAlert : `Sending in ${countdown}s`}
              </button>
            </div>

            <div className="glass-card checklist-card">
              <h2>Guardian Workflow</h2>
              <div className="check-row">
                <BadgeCheck className="h-4 w-4" />
                <span>ESP32 heartbeat monitor every 5 seconds over local Wi-Fi</span>
              </div>
              <div className="check-row">
                <BadgeCheck className="h-4 w-4" />
                <span>Failsafe notification chain for hardware error, missed dose, or low inventory</span>
              </div>
              <div className="check-row">
                <BadgeCheck className="h-4 w-4" />
                <span>Manual guardian test countdown for confidence before deployment</span>
              </div>
            </div>
          </section>
        )}

        <nav className="bottom-nav">
          {[
            { key: "locator", label: "Map", icon: <Globe className="h-5 w-5" /> },
            { key: "organizer", label: "Drawers", icon: <Pill className="h-5 w-5" /> },
            { key: "emergency", label: "Alert", icon: <ShieldAlert className="h-5 w-5" /> },
          ].map((item) => (
            <button
              key={item.key}
              className={`nav-item ${activeTab === item.key ? "active" : ""}`}
              onClick={() => setActiveTab(item.key as TabKey)}
            >
              {item.icon}
              <span>{item.label}</span>
            </button>
          ))}
        </nav>
      </div>
    </main>
  )
}

function AuthCard({
  authView,
  setAuthView,
  onSubmit,
  labels,
  language,
  deviceEndpoint,
  setDeviceEndpoint,
}: {
  authView: AuthView
  setAuthView: (view: AuthView) => void
  onSubmit: () => void
  labels: (typeof COPY)["en"]
  language: Language
  deviceEndpoint: string
  setDeviceEndpoint: (value: string) => void
}) {
  return (
    <section className="auth-card glass-card">
      <div className="auth-tabs">
        {(["login", "signup", "forgot"] as AuthView[]).map((view) => (
          <button
            key={view}
            className={authView === view ? "active" : ""}
            onClick={() => setAuthView(view)}
          >
            {view === "login" ? labels.signIn : view === "signup" ? labels.signUp : labels.forgotPassword}
          </button>
        ))}
      </div>

      {authView === "login" && (
        <>
          <button className="social-button google" onClick={onSubmit}>
            <span className="social-glyph">G</span>
            {labels.useGoogle}
          </button>
          <button className="social-button apple" onClick={onSubmit}>
            <Apple className="h-4 w-4" />
            {labels.useApple}
          </button>
          <button className="social-button email" onClick={onSubmit}>
            <Mail className="h-4 w-4" />
            {labels.useEmail}
          </button>
          <label className="field">
            <span>{labels.email}</span>
            <input placeholder={language === "ar" ? "name@example.com" : "you@cureconnect.com"} />
          </label>
          <label className="field">
            <span>{labels.password}</span>
            <input type="password" placeholder="••••••••" />
          </label>
          <button className="primary-button" onClick={onSubmit}>
            {labels.signIn}
          </button>
        </>
      )}

      {authView === "signup" && (
        <>
          <label className="field">
            <span>{labels.fullName}</span>
            <input placeholder={language === "ar" ? "الاسم الكامل" : "Amina Farid"} />
          </label>
          <label className="field">
            <span>{labels.email}</span>
            <input placeholder="hello@cureconnect.com" />
          </label>
          <label className="field">
            <span>{labels.password}</span>
            <input type="password" placeholder="••••••••" />
          </label>
          <label className="field">
            <span>{labels.confirmPassword}</span>
            <input type="password" placeholder="••••••••" />
          </label>
          <label className="field">
            <span>{labels.macAddress}</span>
            <input placeholder="AA:BB:CC:DD:EE:FF" />
          </label>
          <label className="field">
            <span>ESP32 Endpoint</span>
            <input value={deviceEndpoint} onChange={(event) => setDeviceEndpoint(event.target.value)} />
          </label>
          <button className="primary-button" onClick={onSubmit}>
            {labels.signUp}
          </button>
        </>
      )}

      {authView === "forgot" && (
        <>
          <label className="field">
            <span>{labels.email}</span>
            <input placeholder="hello@cureconnect.com" />
          </label>
          <button className="primary-button" onClick={() => setAuthView("login")}>
            {labels.sendReset}
          </button>
        </>
      )}
    </section>
  )
}

function TopUtilities({
  language,
  onLanguageToggle,
  theme,
  onThemeToggle,
}: {
  language: Language
  onLanguageToggle: () => void
  theme: Theme
  onThemeToggle: () => void
}) {
  return (
    <div className="top-utilities">
      <button className="utility-button" onClick={onLanguageToggle}>
        <Languages className="h-4 w-4" />
        {language === "en" ? "AR" : "EN"}
      </button>
      <button className="utility-button" onClick={onThemeToggle}>
        {theme === "dark" ? <SunMedium className="h-4 w-4" /> : <MoonStar className="h-4 w-4" />}
        {theme === "dark" ? "Light" : "Dark"}
      </button>
    </div>
  )
}

function FeatureChip({ icon, label }: { icon: ReactNode; label: string }) {
  return (
    <div className="feature-chip">
      {icon}
      <span>{label}</span>
    </div>
  )
}

function InfoCard({
  title,
  subtitle,
  action,
}: {
  title: string
  subtitle: string
  action: ReactNode
}) {
  return (
    <div className="glass-card info-card">
      <div>
        <h2>{title}</h2>
        <p>{subtitle}</p>
      </div>
      {action}
    </div>
  )
}

function StatusPill({ icon, label, value }: { icon: ReactNode; label: string; value: string }) {
  return (
    <div className="glass-card status-card">
      <div className="status-icon">{icon}</div>
      <span>{label}</span>
      <strong>{value}</strong>
    </div>
  )
}

function formatTime(date: Date) {
  return new Intl.DateTimeFormat("en-US", {
    hour: "2-digit",
    minute: "2-digit",
  }).format(date)
}

const darkMapStyles = [
  { elementType: "geometry", stylers: [{ color: "#041315" }] },
  { elementType: "labels.text.stroke", stylers: [{ color: "#041315" }] },
  { elementType: "labels.text.fill", stylers: [{ color: "#7cebe1" }] },
  { featureType: "road", elementType: "geometry", stylers: [{ color: "#12363a" }] },
  { featureType: "water", elementType: "geometry", stylers: [{ color: "#062126" }] },
]

const lightMapStyles = [
  { elementType: "geometry", stylers: [{ color: "#eefefd" }] },
  { elementType: "labels.text.fill", stylers: [{ color: "#1f4f53" }] },
  { featureType: "road", elementType: "geometry", stylers: [{ color: "#ffffff" }] },
  { featureType: "water", elementType: "geometry", stylers: [{ color: "#baf2ec" }] },
]
