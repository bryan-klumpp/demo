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

  async testAlarm(alarm: Alarm): Promise<void> {
    if (!alarm.audioData) return;
    await this.playAudio(alarm.audioData);
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
    const ctx = new AudioContext();
    try {
      const buffer = await ctx.decodeAudioData(audioData.slice(0));
      const source = ctx.createBufferSource();
      source.buffer = buffer;
      source.connect(ctx.destination);
      source.start();
      source.onended = () => ctx.close();
    } catch (error) {
      ctx.close();
      console.error('AlarmService: error playing audio', error);
    }
  }
}
