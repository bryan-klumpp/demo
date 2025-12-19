import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-stop-icon',
  template: `
    <svg 
      [attr.width]="size" 
      [attr.height]="size" 
      [attr.fill]="color"
      viewBox="0 0 24 24" 
      xmlns="http://www.w3.org/2000/svg">
      <path d="M6 6h12v12H6z"/>
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
export class StopIconComponent {
  @Input() size: string = '24';
  @Input() color: string = 'currentColor';
}
