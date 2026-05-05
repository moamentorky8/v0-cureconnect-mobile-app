"use client"

import { useState } from "react"
import { Plus, Check, X, Clock, Pill, Sun, Sunset, Moon } from "lucide-react"
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
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

type DoseStatus = "taken" | "missed" | "pending"

interface Medication {
  id: string
  name: string
  dosage: string
  time: string
  period: "morning" | "afternoon" | "evening"
  status: DoseStatus
}

const initialMedications: Medication[] = [
  { id: "1", name: "Metformin", dosage: "500mg", time: "08:00 AM", period: "morning", status: "taken" },
  { id: "2", name: "Vitamin D", dosage: "1000 IU", time: "08:30 AM", period: "morning", status: "taken" },
  { id: "3", name: "Lisinopril", dosage: "10mg", time: "01:00 PM", period: "afternoon", status: "taken" },
  { id: "4", name: "Aspirin", dosage: "81mg", time: "06:00 PM", period: "evening", status: "pending" },
  { id: "5", name: "Atorvastatin", dosage: "20mg", time: "09:00 PM", period: "evening", status: "pending" },
]

const periodIcons = {
  morning: Sun,
  afternoon: Sunset,
  evening: Moon,
}

const periodLabels = {
  morning: "Morning",
  afternoon: "Afternoon",
  evening: "Evening",
}

const statusConfig = {
  taken: { color: "bg-[#22C55E]", textColor: "text-[#22C55E]", label: "Taken" },
  missed: { color: "bg-red-500", textColor: "text-red-500", label: "Missed" },
  pending: { color: "bg-[#F59E0B]", textColor: "text-[#F59E0B]", label: "Pending" },
}

export function MedicationSchedule() {
  const [medications, setMedications] = useState<Medication[]>(initialMedications)
  const [isDialogOpen, setIsDialogOpen] = useState(false)
  const [newMed, setNewMed] = useState({
    name: "",
    dosage: "",
    time: "",
    period: "morning" as "morning" | "afternoon" | "evening",
  })

  const groupedMedications = {
    morning: medications.filter((m) => m.period === "morning"),
    afternoon: medications.filter((m) => m.period === "afternoon"),
    evening: medications.filter((m) => m.period === "evening"),
  }

  const handleAddMedication = () => {
    if (newMed.name && newMed.dosage && newMed.time) {
      const medication: Medication = {
        id: Date.now().toString(),
        ...newMed,
        status: "pending",
      }
      setMedications([...medications, medication])
      setNewMed({ name: "", dosage: "", time: "", period: "morning" })
      setIsDialogOpen(false)
    }
  }

  const updateStatus = (id: string, status: DoseStatus) => {
    setMedications(medications.map((m) => (m.id === id ? { ...m, status } : m)))
  }

  return (
    <div className="flex flex-col gap-6 pb-32">
      {/* Header */}
      <header className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-foreground">Medication Schedule</h1>
          <p className="text-sm text-muted-foreground">Today, May 5th 2026</p>
        </div>
        <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
          <DialogTrigger asChild>
            <Button
              size="icon"
              className="rounded-full bg-gradient-to-r from-[#00D9A5] to-[#00C4D9] text-black hover:opacity-90"
            >
              <Plus className="w-5 h-5" />
            </Button>
          </DialogTrigger>
          <DialogContent className="bg-card border-border">
            <DialogHeader>
              <DialogTitle className="text-foreground">Add Medication</DialogTitle>
            </DialogHeader>
            <div className="flex flex-col gap-4 pt-4">
              <div className="space-y-2">
                <Label htmlFor="name" className="text-foreground">Medication Name</Label>
                <Input
                  id="name"
                  placeholder="e.g., Metformin"
                  value={newMed.name}
                  onChange={(e) => setNewMed({ ...newMed, name: e.target.value })}
                  className="bg-secondary border-border text-foreground"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="dosage" className="text-foreground">Dosage</Label>
                <Input
                  id="dosage"
                  placeholder="e.g., 500mg"
                  value={newMed.dosage}
                  onChange={(e) => setNewMed({ ...newMed, dosage: e.target.value })}
                  className="bg-secondary border-border text-foreground"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="time" className="text-foreground">Time</Label>
                <Input
                  id="time"
                  placeholder="e.g., 08:00 AM"
                  value={newMed.time}
                  onChange={(e) => setNewMed({ ...newMed, time: e.target.value })}
                  className="bg-secondary border-border text-foreground"
                />
              </div>
              <div className="space-y-2">
                <Label className="text-foreground">Period</Label>
                <Select
                  value={newMed.period}
                  onValueChange={(value: "morning" | "afternoon" | "evening") =>
                    setNewMed({ ...newMed, period: value })
                  }
                >
                  <SelectTrigger className="bg-secondary border-border text-foreground">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent className="bg-card border-border">
                    <SelectItem value="morning">Morning</SelectItem>
                    <SelectItem value="afternoon">Afternoon</SelectItem>
                    <SelectItem value="evening">Evening</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <Button
                onClick={handleAddMedication}
                className="mt-2 bg-gradient-to-r from-[#00D9A5] to-[#00C4D9] text-black hover:opacity-90"
              >
                Add Medication
              </Button>
            </div>
          </DialogContent>
        </Dialog>
      </header>

      {/* Progress */}
      <div className="glass-card p-4">
        <div className="flex items-center justify-between mb-3">
          <span className="text-sm text-muted-foreground">Daily Progress</span>
          <span className="text-sm font-medium gradient-text">
            {medications.filter((m) => m.status === "taken").length}/{medications.length} taken
          </span>
        </div>
        <div className="h-2 bg-secondary rounded-full overflow-hidden">
          <div
            className="h-full bg-gradient-to-r from-[#00D9A5] to-[#00C4D9] transition-all duration-500"
            style={{
              width: `${(medications.filter((m) => m.status === "taken").length / medications.length) * 100}%`,
            }}
          />
        </div>
      </div>

      {/* Timeline */}
      <div className="space-y-6">
        {(["morning", "afternoon", "evening"] as const).map((period) => {
          const PeriodIcon = periodIcons[period]
          const meds = groupedMedications[period]
          if (meds.length === 0) return null

          return (
            <section key={period}>
              <div className="flex items-center gap-3 mb-4">
                <div className="w-10 h-10 rounded-2xl bg-[#007BFF]/20 flex items-center justify-center">
                  <PeriodIcon className="w-5 h-5 text-[#007BFF]" />
                </div>
                <h2 className="text-lg font-semibold text-foreground">{periodLabels[period]}</h2>
              </div>

              <div className="relative ml-5 pl-6 border-l-2 border-border space-y-4">
                {meds.map((med) => {
                  const config = statusConfig[med.status]
                  return (
                    <div
                      key={med.id}
                      className={cn(
                        "glass-card p-4 relative",
                        med.status === "pending" && "border-l-4 border-l-[#F59E0B]"
                      )}
                    >
                      {/* Timeline Dot */}
                      <div
                        className={cn(
                          "absolute -left-[31px] top-1/2 -translate-y-1/2 w-4 h-4 rounded-full border-2 border-background",
                          config.color
                        )}
                      />

                      <div className="flex items-start justify-between">
                        <div className="flex items-start gap-3">
                          <div className="w-10 h-10 rounded-2xl bg-secondary flex items-center justify-center">
                            <Pill className="w-5 h-5 text-[#00D9A5]" />
                          </div>
                          <div>
                            <h3 className="font-medium text-foreground">{med.name}</h3>
                            <p className="text-sm text-muted-foreground">{med.dosage}</p>
                            <div className="flex items-center gap-2 mt-1">
                              <Clock className="w-3 h-3 text-muted-foreground" />
                              <span className="text-xs text-muted-foreground">{med.time}</span>
                            </div>
                          </div>
                        </div>

                        <div className="flex items-center gap-2">
                          {med.status === "pending" ? (
                            <>
                              <button
                                onClick={() => updateStatus(med.id, "taken")}
                                className="w-8 h-8 rounded-full bg-[#22C55E]/20 flex items-center justify-center hover:bg-[#22C55E]/30 transition-colors"
                              >
                                <Check className="w-4 h-4 text-[#22C55E]" />
                              </button>
                              <button
                                onClick={() => updateStatus(med.id, "missed")}
                                className="w-8 h-8 rounded-full bg-red-500/20 flex items-center justify-center hover:bg-red-500/30 transition-colors"
                              >
                                <X className="w-4 h-4 text-red-500" />
                              </button>
                            </>
                          ) : (
                            <span className={cn("text-xs font-medium px-2 py-1 rounded-full", 
                              med.status === "taken" ? "bg-[#22C55E]/20 text-[#22C55E]" : "bg-red-500/20 text-red-500"
                            )}>
                              {config.label}
                            </span>
                          )}
                        </div>
                      </div>
                    </div>
                  )
                })}
              </div>
            </section>
          )
        })}
      </div>
    </div>
  )
}
