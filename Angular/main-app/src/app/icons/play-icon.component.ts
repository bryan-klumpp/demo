import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-play-icon',
  template: `
    <svg 
      [attr.width]="size" 
      [attr.height]="size" 
      [attr.fill]="color"
      viewBox="0 0 24 24" 
      xmlns="http://www.w3.org/2000/svg">
      <path d="M8 5v14l11-7z"/>
    </svg>
  `,
  styles: [`
    :host {
      display: inline-block;
    }
    svg {
      vertical-align: middle;
    }
  `]
})
export class PlayIconComponent {
  @Input() size: string = '24';
  @Input() color: string = 'currentColor';
}
