import { NextResponse } from "next/server"

export async function POST(request: Request) {
  try {
    const { text, voiceId, voiceName } = (await request.json()) as {
      text?: string
      voiceId?: string
      voiceName?: string
    }

    if (!text) {
      return NextResponse.json({ error: "Text is required" }, { status: 400 })
    }

    const apiKey = process.env.ELEVENLABS_API_KEY
    const activeVoice = voiceId || process.env.ELEVENLABS_VOICE_ID

    if (!apiKey || !activeVoice) {
      return NextResponse.json({
        message: `Demo mode: add ELEVENLABS_API_KEY and ELEVENLABS_VOICE_ID to enable live synthesis for ${voiceName ?? "this drawer"}.`,
        audioUrl: "",
      })
    }

    const response = await fetch(`https://api.elevenlabs.io/v1/text-to-speech/${activeVoice}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "xi-api-key": apiKey,
      },
      body: JSON.stringify({
        text,
        model_id: "eleven_multilingual_v2",
        voice_settings: {
          stability: 0.45,
          similarity_boost: 0.8,
        },
      }),
    })

    if (!response.ok) {
      const errorText = await response.text()
      return NextResponse.json(
        { error: `ElevenLabs request failed: ${errorText.slice(0, 180)}` },
        { status: response.status },
      )
    }

    const audioBuffer = await response.arrayBuffer()
    const audioBase64 = Buffer.from(audioBuffer).toString("base64")

    return NextResponse.json({
      message: "Voice prompt generated via ElevenLabs.",
      audioUrl: `data:audio/mpeg;base64,${audioBase64}`,
    })
  } catch (error) {
    return NextResponse.json(
      { error: error instanceof Error ? error.message : "Unexpected server error" },
      { status: 500 },
    )
  }
}
