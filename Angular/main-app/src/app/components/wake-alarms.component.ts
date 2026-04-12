import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { DatabaseService } from '../services/database.service';
import { AlarmService } from '../services/alarm.service';
import { Alarm, DAY_NAMES } from '../models/alarm.model';

@Component({
  selector: 'app-wake-alarms',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="alarms-container">
      <header class="alarms-header">
        <h1>⏰ Wake Alarms</h1>
        <p>Set wake-up alarms with custom audio files</p>
      </header>

      <!-- Add New Alarm Form -->
      <div class="alarm-card add-alarm-card">
        <h2>➕ Add New Alarm</h2>

        <div class="form-grid">
          <div class="form-group">
            <label for="alarm-time">Time</label>
            <input
              id="alarm-time"
              type="time"
              [(ngModel)]="newAlarm.time"
              class="form-input"
            />
          </div>

          <div class="form-group">
            <label for="alarm-label">Label</label>
            <input
              id="alarm-label"
              type="text"
              [(ngModel)]="newAlarm.label"
              placeholder="e.g. Morning wake-up"
              class="form-input"
            />
          </div>
        </div>

        <div class="form-group">
          <label>Repeat Days <span class="hint">(none selected = every day)</span></label>
          <div class="day-buttons">
            <button
              *ngFor="let day of dayNames; let i = index"
              (click)="toggleDay(i)"
              [class.selected]="newAlarm.days.includes(i)"
              class="day-btn"
            >{{ day }}</button>
          </div>
        </div>

        <div class="form-group">
          <label>Audio File <span class="hint">(MP3, WAV, or OGG)</span></label>
          <div class="audio-input-row">
            <span class="audio-path">{{ newAlarm.audioFileName || 'No file selected' }}</span>
            <label class="browse-btn">
              📂 Browse...
              <input
                type="file"
                accept=".mp3,.wav,.ogg,audio/*"
                (change)="onAudioFileSelected($event)"
                style="display:none"
              />
            </label>
            <button
              *ngIf="newAlarm.audioData"
              (click)="testNewAlarm()"
              class="test-btn"
              title="Test audio"
            >▶ Test</button>
          </div>
        </div>

        <button
          (click)="addAlarm()"
          [disabled]="!newAlarm.time || isSaving"
          class="btn btn-primary"
        >
          {{ isSaving ? 'Saving...' : '✓ Save Alarm' }}
        </button>

        <div *ngIf="addError" class="error-msg">{{ addError }}</div>
      </div>

      <!-- Existing Alarms -->
      <div class="alarms-list-section">
        <h2>🔔 Your Alarms</h2>

        <div *ngIf="alarms.length === 0" class="no-alarms">
          <p>No alarms set yet. Add one above to get started!</p>
        </div>

        <div *ngFor="let alarm of alarms" class="alarm-item" [class.disabled]="!alarm.enabled">
          <div class="alarm-main">
            <div class="alarm-time">{{ alarm.time }}</div>
            <div class="alarm-details">
              <div class="alarm-label">{{ alarm.label || 'Alarm' }}</div>
              <div class="alarm-meta">
                <span class="alarm-days">{{ formatDays(alarm.days) }}</span>
                <span *ngIf="alarm.audioFileName" class="alarm-file" title="{{ alarm.audioFileName }}">
                  🎵 {{ alarm.audioFileName }}
                </span>
                <span *ngIf="!alarm.audioFileName" class="alarm-no-file">🔇 No audio file</span>
              </div>
            </div>
          </div>

          <div class="alarm-actions">
            <button
              *ngIf="alarm.audioData"
              (click)="testAlarm(alarm)"
              class="action-btn test"
              title="Test audio"
            >▶</button>

            <label class="toggle-switch" title="{{ alarm.enabled ? 'Disable' : 'Enable' }}">
              <input
                type="checkbox"
                [checked]="alarm.enabled"
                (change)="toggleAlarm(alarm)"
              />
              <span class="toggle-slider"></span>
            </label>

            <button
              (click)="deleteAlarm(alarm)"
              class="action-btn delete"
              title="Delete alarm"
            >🗑</button>
          </div>
        </div>
      </div>

      <div *ngIf="statusMsg" class="status-msg" [class.error]="statusIsError">{{ statusMsg }}</div>
    </div>
  `,
  styles: [`
    .alarms-container {
      max-width: 800px;
      margin: 0 auto;
      padding: 2rem;
    }

    .alarms-header {
      text-align: center;
      margin-bottom: 2rem;
    }

    .alarms-header h1 {
      font-size: 2.5rem;
      color: #333;
      margin-bottom: 0.5rem;
    }

    .alarms-header p {
      color: #666;
      font-size: 1.1rem;
    }

    .alarm-card {
      background: white;
      border: 1px solid #e5e7eb;
      border-radius: 12px;
      padding: 1.75rem;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
      margin-bottom: 2rem;
    }

    .alarm-card h2 {
      margin: 0 0 1.5rem 0;
      color: #333;
      font-size: 1.25rem;
    }

    .form-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1rem;
      margin-bottom: 1rem;
    }

    @media (max-width: 600px) {
      .form-grid {
        grid-template-columns: 1fr;
      }
    }

    .form-group {
      margin-bottom: 1rem;
    }

    .form-group label {
      display: block;
      font-weight: 500;
      color: #374151;
      margin-bottom: 0.4rem;
      font-size: 0.9rem;
    }

    .hint {
      font-weight: 400;
      color: #9ca3af;
      font-size: 0.8rem;
    }

    .form-input {
      width: 100%;
      padding: 0.6rem 0.75rem;
      border: 1px solid #d1d5db;
      border-radius: 6px;
      font-size: 1rem;
      box-sizing: border-box;
      transition: border-color 0.2s;
    }

    .form-input:focus {
      outline: none;
      border-color: #0891b2;
      box-shadow: 0 0 0 3px rgba(8, 145, 178, 0.1);
    }

    .day-buttons {
      display: flex;
      gap: 0.5rem;
      flex-wrap: wrap;
    }

    .day-btn {
      padding: 0.4rem 0.75rem;
      border: 2px solid #d1d5db;
      border-radius: 20px;
      background: white;
      color: #374151;
      font-size: 0.85rem;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.2s;
    }

    .day-btn:hover {
      border-color: #0891b2;
      color: #0891b2;
    }

    .day-btn.selected {
      background: #0891b2;
      border-color: #0891b2;
      color: white;
    }

    .audio-input-row {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      flex-wrap: wrap;
    }

    .audio-path {
      flex: 1;
      min-width: 0;
      padding: 0.6rem 0.75rem;
      background: #f9fafb;
      border: 1px solid #d1d5db;
      border-radius: 6px;
      font-size: 0.9rem;
      color: #374151;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .browse-btn {
      padding: 0.6rem 1rem;
      background: #f3f4f6;
      border: 1px solid #d1d5db;
      border-radius: 6px;
      cursor: pointer;
      font-size: 0.9rem;
      font-weight: 500;
      white-space: nowrap;
      transition: background 0.2s;
    }

    .browse-btn:hover {
      background: #e5e7eb;
    }

    .test-btn {
      padding: 0.6rem 0.9rem;
      background: #ecfdf5;
      border: 1px solid #6ee7b7;
      border-radius: 6px;
      color: #065f46;
      cursor: pointer;
      font-size: 0.9rem;
      font-weight: 500;
      transition: background 0.2s;
    }

    .test-btn:hover {
      background: #d1fae5;
    }

    .btn {
      padding: 0.75rem 1.5rem;
      border: none;
      border-radius: 8px;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      margin-top: 0.5rem;
    }

    .btn:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }

    .btn-primary {
      background: #0891b2;
      color: white;
    }

    .btn-primary:hover:not(:disabled) {
      background: #0e7490;
    }

    .error-msg {
      margin-top: 0.75rem;
      color: #dc2626;
      font-size: 0.9rem;
    }

    /* Alarm list */
    .alarms-list-section h2 {
      font-size: 1.25rem;
      color: #333;
      margin-bottom: 1rem;
    }

    .no-alarms {
      text-align: center;
      color: #9ca3af;
      font-style: italic;
      padding: 3rem;
      background: white;
      border: 1px dashed #d1d5db;
      border-radius: 12px;
    }

    .alarm-item {
      background: white;
      border: 1px solid #e5e7eb;
      border-radius: 10px;
      padding: 1rem 1.25rem;
      margin-bottom: 0.75rem;
      display: flex;
      align-items: center;
      gap: 1rem;
      box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
      transition: opacity 0.2s;
    }

    .alarm-item.disabled {
      opacity: 0.5;
    }

    .alarm-main {
      display: flex;
      align-items: center;
      gap: 1rem;
      flex: 1;
      min-width: 0;
    }

    .alarm-time {
      font-size: 2rem;
      font-weight: 700;
      color: #0891b2;
      white-space: nowrap;
      min-width: 5rem;
    }

    .alarm-item.disabled .alarm-time {
      color: #9ca3af;
    }

    .alarm-details {
      flex: 1;
      min-width: 0;
    }

    .alarm-label {
      font-weight: 600;
      color: #1f2937;
      font-size: 1rem;
      margin-bottom: 0.25rem;
    }

    .alarm-meta {
      display: flex;
      gap: 1rem;
      flex-wrap: wrap;
      align-items: center;
    }

    .alarm-days {
      font-size: 0.8rem;
      color: #6b7280;
    }

    .alarm-file {
      font-size: 0.8rem;
      color: #6b7280;
      max-width: 200px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .alarm-no-file {
      font-size: 0.8rem;
      color: #d1d5db;
    }

    .alarm-actions {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      flex-shrink: 0;
    }

    .action-btn {
      width: 36px;
      height: 36px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 1rem;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: background 0.2s;
    }

    .action-btn.test {
      background: #ecfdf5;
      color: #065f46;
    }

    .action-btn.test:hover {
      background: #d1fae5;
    }

    .action-btn.delete {
      background: #fef2f2;
      color: #dc2626;
    }

    .action-btn.delete:hover {
      background: #fee2e2;
    }

    /* Toggle switch */
    .toggle-switch {
      position: relative;
      display: inline-block;
      width: 46px;
      height: 26px;
      cursor: pointer;
    }

    .toggle-switch input {
      opacity: 0;
      width: 0;
      height: 0;
      position: absolute;
    }

    .toggle-slider {
      position: absolute;
      inset: 0;
      background: #d1d5db;
      border-radius: 26px;
      transition: background 0.2s;
    }

    .toggle-slider::before {
      content: '';
      position: absolute;
      width: 20px;
      height: 20px;
      background: white;
      border-radius: 50%;
      top: 3px;
      left: 3px;
      transition: transform 0.2s;
      box-shadow: 0 1px 3px rgba(0,0,0,0.2);
    }

    .toggle-switch input:checked + .toggle-slider {
      background: #0891b2;
    }

    .toggle-switch input:checked + .toggle-slider::before {
      transform: translateX(20px);
    }

    .status-msg {
      position: fixed;
      bottom: 1.5rem;
      right: 1.5rem;
      background: #065f46;
      color: white;
      padding: 0.75rem 1.25rem;
      border-radius: 8px;
      font-size: 0.9rem;
      font-weight: 500;
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
      z-index: 9999;
    }

    .status-msg.error {
      background: #dc2626;
    }
  `]
})
export class WakeAlarmsComponent implements OnInit {
  readonly dayNames = DAY_NAMES;
  alarms: Alarm[] = [];
  isSaving = false;
  addError = '';
  statusMsg = '';
  statusIsError = false;
  private statusTimer: any;

  newAlarm: {
    time: string;
    label: string;
    days: number[];
    audioFileName: string;
    audioData?: ArrayBuffer;
  } = this.emptyAlarmForm();

  constructor(
    private db: DatabaseService,
    private alarmService: AlarmService,
    private cdr: ChangeDetectorRef
  ) {}

  async ngOnInit(): Promise<void> {
    await this.loadAlarms();
  }

  private async loadAlarms(): Promise<void> {
    try {
      this.alarms = await this.db.getAllAlarms();
      this.cdr.markForCheck();
    } catch (error) {
      console.error('Error loading alarms:', error);
    }
  }

  private emptyAlarmForm() {
    return { time: '07:00', label: '', days: [] as number[], audioFileName: '', audioData: undefined as ArrayBuffer | undefined };
  }

  toggleDay(dayIndex: number): void {
    const idx = this.newAlarm.days.indexOf(dayIndex);
    if (idx >= 0) {
      this.newAlarm.days = this.newAlarm.days.filter(d => d !== dayIndex);
    } else {
      this.newAlarm.days = [...this.newAlarm.days, dayIndex].sort();
    }
  }

  onAudioFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    const file = input.files?.[0];
    if (!file) return;

    this.newAlarm.audioFileName = file.name;
    const reader = new FileReader();
    reader.onload = (e) => {
      this.newAlarm.audioData = e.target?.result as ArrayBuffer;
      this.cdr.markForCheck();
    };
    reader.readAsArrayBuffer(file);
  }

  async testNewAlarm(): Promise<void> {
    if (!this.newAlarm.audioData) return;
    await this.alarmService.testAlarm({
      label: '',
      time: '',
      days: [],
      enabled: true,
      audioData: this.newAlarm.audioData,
      createdAt: new Date(),
      updatedAt: new Date()
    });
  }

  async addAlarm(): Promise<void> {
    if (!this.newAlarm.time || this.isSaving) return;
    this.isSaving = true;
    this.addError = '';
    try {
      await this.db.addAlarm({
        label: this.newAlarm.label || 'Alarm',
        time: this.newAlarm.time,
        days: [...this.newAlarm.days],
        enabled: true,
        audioFileName: this.newAlarm.audioFileName || undefined,
        audioData: this.newAlarm.audioData,
        createdAt: new Date(),
        updatedAt: new Date()
      });
      this.newAlarm = this.emptyAlarmForm();
      await this.loadAlarms();
      this.showStatus('Alarm saved!');
    } catch (error) {
      this.addError = `Failed to save alarm: ${error}`;
    } finally {
      this.isSaving = false;
      this.cdr.markForCheck();
    }
  }

  async toggleAlarm(alarm: Alarm): Promise<void> {
    try {
      await this.db.updateAlarm(alarm.id!, { enabled: !alarm.enabled });
      await this.loadAlarms();
    } catch (error) {
      this.showStatus('Failed to update alarm', true);
    }
  }

  async deleteAlarm(alarm: Alarm): Promise<void> {
    if (!confirm(`Delete alarm "${alarm.label || alarm.time}"?`)) return;
    try {
      await this.db.deleteAlarm(alarm.id!);
      await this.loadAlarms();
      this.showStatus('Alarm deleted');
    } catch (error) {
      this.showStatus('Failed to delete alarm', true);
    }
  }

  async testAlarm(alarm: Alarm): Promise<void> {
    await this.alarmService.testAlarm(alarm);
  }

  formatDays(days: number[]): string {
    if (days.length === 0) return 'Every day';
    if (days.length === 7) return 'Every day';
    if (days.length === 5 && !days.includes(0) && !days.includes(6)) return 'Weekdays';
    if (days.length === 2 && days.includes(0) && days.includes(6)) return 'Weekends';
    return days.map(d => DAY_NAMES[d]).join(', ');
  }

  private showStatus(msg: string, isError = false): void {
    this.statusMsg = msg;
    this.statusIsError = isError;
    this.cdr.markForCheck();
    clearTimeout(this.statusTimer);
    this.statusTimer = setTimeout(() => {
      this.statusMsg = '';
      this.cdr.markForCheck();
    }, 3000);
  }
}
