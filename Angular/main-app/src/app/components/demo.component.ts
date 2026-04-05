import { Component, signal, effect, untracked, ViewChild, ElementRef, AfterViewInit, OnDestroy, Inject, PLATFORM_ID, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AudioPlayerService } from '../audio-player.service';
import { isPlatformBrowser } from '@angular/common';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { RouterModule } from '@angular/router';
import { IconsModule } from '../icons';
import { IconDemoComponent } from '../icons/icon-demo.component';

@Component({
  selector: 'app-demo',
  standalone: true,
  imports: [CommonModule, RouterModule, IconsModule, IconDemoComponent],
  template: `
    <div class="demo-container">
      <div class="demo-header">
        <h1>Angular Demo Features</h1>
        <p>Demonstration of various Angular features and components</p>
        <button routerLink="/" class="back-btn">← Back to Main</button>
      </div>

      <!-- SignalA demo -->
      <div class="demo-section">
        <h2>Signal Demo</h2>
        <div class="signal-demo">
          <div class="signal-display">
            <div>SignalA: {{ SignalA() }}</div>
            <div>SignalB: {{ SignalB() }}</div>
          </div>
          <button (click)="incrementSignalA()" class="demo-btn">
            Increment SignalA
          </button>
        </div>
      </div>

      <!-- Icons Demo Section -->
      <div class="demo-section">
        <h2>Icons Demo</h2>
        <app-icon-demo></app-icon-demo>
      </div>
      
      <!-- Audio Controls -->
      <div class="demo-section">
        <h2>Audio Player Demo</h2>
        <div class="audio-controls">
          <button (click)="playAudio()" class="audio-btn">
            <app-play-icon size="16" color="#4f46e5"></app-play-icon>
            Play Sample Audio
          </button>
          <div class="player-status">
            <app-volume-icon size="16" color="#6b7280"></app-volume-icon>
            {{ playerStatus() }}
          </div>
        </div>
      </div>

      <!-- iFrame Demo -->
      <div class="demo-section">
        <h2>iFrame Communication Demo</h2>
        <div class="iframe-demo" [style.gridTemplateColumns]="leftRailWidthCss + ' 1fr'">
          <iframe
            #leftIframe
            class="left-rail"
            [src]="leftRailSrc"
            [title]="'Left navigation iframe (' + leftRailWidthCss + ' wide, full height)'">
          </iframe>
          <iframe
            #mainIframe
            class="main-frame"
            [src]="mainIframeSrc"
            title="Main content iframe">
          </iframe>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .demo-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 2rem;
    }

    .demo-header {
      text-align: center;
      margin-bottom: 3rem;
    }

    .demo-header h1 {
      font-size: 2.5rem;
      color: #333;
      margin-bottom: 0.5rem;
    }

    .demo-header p {
      color: #666;
      font-size: 1.1rem;
      margin-bottom: 2rem;
    }

    .back-btn {
      background: #4f46e5;
      color: white;
      border: none;
      padding: 0.75rem 1.5rem;
      border-radius: 8px;
      cursor: pointer;
      font-size: 1rem;
      text-decoration: none;
      display: inline-block;
    }

    .back-btn:hover {
      background: #4338ca;
    }

    .demo-section {
      background: white;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      padding: 2rem;
      margin-bottom: 2rem;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }

    .demo-section h2 {
      margin: 0 0 1.5rem 0;
      color: #333;
      border-bottom: 2px solid #f3f4f6;
      padding-bottom: 0.5rem;
    }

    .signal-demo {
      display: flex;
      align-items: center;
      gap: 2rem;
      flex-wrap: wrap;
    }

    .signal-display {
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
      font-weight: 500;
      font-size: 1.1rem;
    }

    .demo-btn, .audio-btn {
      padding: 0.75rem 1.5rem;
      border-radius: 8px;
      background: #4f46e5;
      color: white;
      border: none;
      cursor: pointer;
      font-size: 1rem;
      transition: background 0.3s ease;
    }

    .demo-btn:hover, .audio-btn:hover {
      background: #4338ca;
    }

    .audio-controls {
      display: flex;
      align-items: center;
      gap: 2rem;
      flex-wrap: wrap;
    }

    .audio-btn {
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .player-status {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      font-weight: 500;
      color: #374151;
    }

    .iframe-demo {
      display: grid;
      height: 400px;
      gap: 1rem;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      overflow: hidden;
    }

    .iframe-demo iframe {
      width: 100%;
      height: 100%;
      border: none;
    }

    .left-rail {
      background: #f3f4f6;
    }

    .main-frame {
      background: #ffffff;
    }

    @media (max-width: 768px) {
      .demo-container {
        padding: 1rem;
      }

      .signal-demo, .audio-controls {
        flex-direction: column;
        align-items: stretch;
        gap: 1rem;
      }

      .iframe-demo {
        grid-template-columns: 1fr !important;
        height: 600px;
      }
    }
  `]
})
export class DemoComponent implements AfterViewInit, OnDestroy {
  playerStatus = signal('Player');
  leftRailWidth = '15%';

  // Numeric signal initialized to 0
  SignalA = signal(0);
  SignalB = signal(0);

  leftRailSrc: SafeResourceUrl;
  mainIframeSrc: SafeResourceUrl;

  @ViewChild('leftIframe') leftIframe?: ElementRef<HTMLIFrameElement>;
  @ViewChild('mainIframe') mainIframe?: ElementRef<HTMLIFrameElement>;

  private readonly isBrowser: boolean;

  constructor(
    private sanitizer: DomSanitizer,
    @Inject(PLATFORM_ID) platformId: Object,
    private audioPlayer: AudioPlayerService,
    private cdr: ChangeDetectorRef
  ) {
    this.isBrowser = isPlatformBrowser(platformId);
    const v = Date.now().toString(); // cache-busting version
    this.leftRailSrc = this.sanitizer.bypassSecurityTrustResourceUrl(`/left-rail.html?v=${v}`);
    this.mainIframeSrc = this.sanitizer.bypassSecurityTrustResourceUrl(`/main-iframe.html?v=${v}`);
    
    // Create effects in constructor to ensure proper timing
    effect(() => {
      this.getSignalA();
      untracked(() => {this.SignalB.set(this.SignalB() + 1); });
    });

    effect(() => {
      console.log('SignalB value:', this.SignalB());
    });
  }

  // Method to increment SignalA
  incrementSignalA() {
     this.SignalA.set(this.SignalA() + 1);
  }

  // Extract SignalA value getter
  getSignalA() {
      console.log('SignalA value:', this.SignalA());
  }

  playAudio() {
    this.audioPlayer.play(
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      () => { this.playerStatus.set('Playing...'); },
      () => { this.playerStatus.set('Player'); }
    );
  }

  get leftRailWidthCss(): string {
    return this.leftRailWidth;
  }

  private onMessage = (event: MessageEvent) => {
    const data = (event as any).data;
    if (!data || data.type !== 'sync-text') return;
    const leftWin = this.leftIframe?.nativeElement?.contentWindow;
    const mainWin = this.mainIframe?.nativeElement?.contentWindow;
    if (data.source !== 'left' && leftWin) {
      leftWin.postMessage(data, '*');
    }
    if (data.source !== 'main' && mainWin) {
      mainWin.postMessage(data, '*');
    }
  };

  ngAfterViewInit(): void {
    if (!this.isBrowser) return;
    window.addEventListener('message', this.onMessage);
  }

  ngOnDestroy(): void {
    if (!this.isBrowser) return;
    window.removeEventListener('message', this.onMessage);
  }
}