import { Component, signal, effect, untracked, ViewChild, ElementRef, AfterViewInit, OnDestroy, Inject, PLATFORM_ID, ChangeDetectorRef } from '@angular/core';
import { AudioPlayerService } from './audio-player.service';
import { isPlatformBrowser } from '@angular/common';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { RouterOutlet } from '@angular/router';
import { IconsModule } from './icons';
import { IconDemoComponent } from './icons/icon-demo.component';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, IconsModule, IconDemoComponent],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App implements AfterViewInit, OnDestroy {
  playerStatus = signal('Player');
  protected readonly title = signal('main-app');
  leftRailWidth = '15%';

    // Numeric signal initialized to 0
    SignalA = signal(0);
    SignalB = signal(0);;

    // Method to increment SignalA
    incrementSignalA() {
       this.SignalA.set(this.SignalA() + 1);
    }

    // Extract SignalA value getter
    getSignalA() {
      console.log('SignalA value:', this.SignalA());
    }
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
