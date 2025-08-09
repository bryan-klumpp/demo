import { Component, signal } from '@angular/core';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  protected readonly title = signal('main-app');
  leftRailWidth = '15%';

  leftRailSrc: SafeResourceUrl;
  mainIframeSrc: SafeResourceUrl;

  constructor(private sanitizer: DomSanitizer) {
    console.log('App component initialized at '+ new Date().toLocaleTimeString());
    const v = Date.now().toString(); // cache-busting version
    this.leftRailSrc = this.sanitizer.bypassSecurityTrustResourceUrl(`/left-rail.html?v=${v}`);
    this.mainIframeSrc = this.sanitizer.bypassSecurityTrustResourceUrl(`/main-iframe.html?v=${v}`);
  }

  get leftRailWidthCss(): string {
    return this.leftRailWidth;
  }
}
