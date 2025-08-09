import { Component, signal, ViewChild, ElementRef, AfterViewInit, OnDestroy, Inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App implements AfterViewInit, OnDestroy {
  protected readonly title = signal('main-app');
  leftRailWidth = '15%';

  leftRailSrc: SafeResourceUrl;
  mainIframeSrc: SafeResourceUrl;

  @ViewChild('leftIframe') leftIframe?: ElementRef<HTMLIFrameElement>;
  @ViewChild('mainIframe') mainIframe?: ElementRef<HTMLIFrameElement>;

  private readonly isBrowser: boolean;

  constructor(private sanitizer: DomSanitizer, @Inject(PLATFORM_ID) platformId: Object) {
    console.log('App component initialized at '+ new Date().toLocaleTimeString());
    this.isBrowser = isPlatformBrowser(platformId);
    const v = Date.now().toString(); // cache-busting version
    this.leftRailSrc = this.sanitizer.bypassSecurityTrustResourceUrl(`/left-rail.html?v=${v}`);
    this.mainIframeSrc = this.sanitizer.bypassSecurityTrustResourceUrl(`/main-iframe.html?v=${v}`);
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
