export interface Alarm {
  id?: number;
  label: string;
  time: string; // "HH:mm" 24-hour format
  days: number[]; // 0=Sun, 1=Mon, ..., 6=Sat; empty array = every day
  enabled: boolean;
  audioFileName?: string; // display name / reference path shown to user
  audioData?: ArrayBuffer; // actual binary data stored in IndexedDB
  createdAt: Date;
  updatedAt: Date;
}

export const DAY_NAMES = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
