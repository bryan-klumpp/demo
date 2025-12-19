import { Component } from '@angular/core';
import { IconsModule } from './icons.module';

@Component({
  selector: 'app-icon-demo',
  standalone: true,
  imports: [IconsModule],
  template: `
    <div class="icon-demo">
      <h3>Icon Demo (using IconsModule)</h3>
      <div class="icon-grid">
        <div class="icon-item">
          <app-play-icon size="32" color="#22c55e"></app-play-icon>
          <span>Play (32px, green)</span>
        </div>
        <div class="icon-item">
          <app-pause-icon size="24" color="#ef4444"></app-pause-icon>
          <span>Pause (24px, red)</span>
        </div>
        <div class="icon-item">
          <app-stop-icon size="20" color="#f59e0b"></app-stop-icon>
          <span>Stop (20px, amber)</span>
        </div>
        <div class="icon-item">
          <app-volume-icon size="28" color="#8b5cf6"></app-volume-icon>
          <span>Volume (28px, purple)</span>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .icon-demo {
      padding: 1rem;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      margin: 1rem 0;
    }
    .icon-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
      gap: 1rem;
      margin-top: 1rem;
    }
    .icon-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 0.5rem;
      padding: 1rem;
      border: 1px solid #f3f4f6;
      border-radius: 6px;
      background: #fafafa;
    }
    .icon-item span {
      font-size: 12px;
      color: #6b7280;
      text-align: center;
    }
    h3 {
      margin: 0 0 1rem 0;
      color: #374151;
    }
  `]
})
export class IconDemoComponent { }
