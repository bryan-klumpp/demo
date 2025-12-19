import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-pause-icon',
  template: `
    <svg 
      [attr.width]="size" 
      [attr.height]="size" 
      [attr.fill]="color"
      viewBox="0 0 24 24" 
      xmlns="http://www.w3.org/2000/svg">
      <path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/>
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
export class PauseIconComponent {
  @Input() size: string = '24';
  @Input() color: string = 'currentColor';
}
