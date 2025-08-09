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
  leftRailWidth = 150; // px

  leftRailSrc: SafeResourceUrl;

  constructor(private sanitizer: DomSanitizer) {
    this.leftRailSrc = this.sanitizer.bypassSecurityTrustResourceUrl('/left-rail.html');
  }

  get leftRailWidthPx(): string {
    return `${this.leftRailWidth}px`;
  }
}
