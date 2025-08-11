import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class AudioPlayerService {
  private audio: HTMLAudioElement | null = null;

  play(url: string, onStart?: () => void, onEnd?: () => void) {
    if (this.audio) {
      this.audio.pause();
      this.audio = null;
    }
    this.audio = new Audio(url);
    if (onStart) this.audio.addEventListener('play', onStart, { once: true });
    if (onEnd) this.audio.addEventListener('ended', onEnd, { once: true });
    this.audio.play();
  }
}
