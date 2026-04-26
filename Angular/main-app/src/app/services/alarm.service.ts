import { Injectable } from '@angular/core';
import { DatabaseService } from './database.service';
import { Alarm } from '../models/alarm.model';

@Injectable({
  providedIn: 'root'
})
export class AlarmService {
  private intervalId: ReturnType<typeof setInterval> | null = null;
  /** Tracks alarms that have already fired to prevent duplicate plays within the same minute */
  private readonly firedAlarms = new Map<string, string>(); // key -> dateString
  private audioCtx: AudioContext | null = null;

  constructor(private db: DatabaseService) {}

  start(): void {
    if (this.intervalId !== null) return;
    this.checkAlarms();
    this.intervalId = setInterval(() => this.checkAlarms(), 30_000);
  }

  stop(): void {
    if (this.intervalId !== null) {
      clearInterval(this.intervalId);
      this.intervalId = null;
    }
  }

  /** Call on any user interaction to satisfy the browser autoplay policy. */
  unlockAudioContext(): void {
    if (!this.audioCtx) {
      this.audioCtx = new AudioContext();
    } else if (this.audioCtx.state === 'suspended') {
      this.audioCtx.resume();
    }
  }

  async testAlarm(alarm: Alarm): Promise<void> {
    if (alarm.audioData) {
      await this.playAudio(alarm.audioData);
    } else {
      await this.playBeep();
    }
  }

  private getAudioContext(): AudioContext {
    if (!this.audioCtx) {
      this.audioCtx = new AudioContext();
    }
    return this.audioCtx;
  }

  private async checkAlarms(): Promise<void> {
    const now = new Date();
    const currentTime = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`;
    const currentDay = now.getDay();
    const dateStr = now.toDateString();

    try {
      const alarms = await this.db.getEnabledAlarms();
      for (const alarm of alarms) {
        if (alarm.time !== currentTime) continue;
        const daysMatch = alarm.days.length === 0 || alarm.days.includes(currentDay);
        if (!daysMatch) continue;

        const fireKey = `${alarm.id}-${dateStr}-${currentTime}`;
        if (this.firedAlarms.has(fireKey)) continue;
        this.firedAlarms.set(fireKey, dateStr);

        if (alarm.audioData) {
          await this.playAudio(alarm.audioData);
        } else {
          await this.playBeep();
        }
      }

      // Clean up fire keys from previous days
      for (const [key, ds] of this.firedAlarms.entries()) {
        if (ds !== dateStr) this.firedAlarms.delete(key);
      }
    } catch (error) {
      console.error('AlarmService: error checking alarms', error);
    }
  }

  private async playAudio(audioData: ArrayBuffer): Promise<void> {
    const ctx = this.getAudioContext();
    try {
      if (ctx.state === 'suspended') await ctx.resume();
      const buffer = await ctx.decodeAudioData(audioData.slice(0));
      const source = ctx.createBufferSource();
      source.buffer = buffer;
      source.connect(ctx.destination);
      source.start();
      await new Promise<void>(resolve => { source.onended = () => resolve(); });
    } catch (error) {
      console.error('AlarmService: error playing audio, falling back to beep', error);
      await this.playBeep();
    }
  }

  /** Plays three short tones as a system-beep fallback. */
  private async playBeep(): Promise<void> {
    const ctx = this.getAudioContext();
    try { if (ctx.state === 'suspended') await ctx.resume(); } catch { /* no user gesture yet */ }

    const beep = (startTime: number) => {
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.connect(gain);
      gain.connect(ctx.destination);
      osc.type = 'sine';
      osc.frequency.value = 880;
      gain.gain.setValueAtTime(0.3, startTime);
      gain.gain.exponentialRampToValueAtTime(0.001, startTime + 0.35);
      osc.start(startTime);
      osc.stop(startTime + 0.35);
    };

    const t = ctx.currentTime;
    beep(t);
    beep(t + 0.45);
    beep(t + 0.9);
    await new Promise<void>(resolve => setTimeout(resolve, 1400));
  }
}
