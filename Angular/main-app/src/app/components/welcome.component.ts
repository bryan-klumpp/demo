import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-welcome',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <div class="welcome-container">
      <header class="welcome-header">
        <h1>Welcome to the Multi-Purpose App</h1>
        <p>Choose what you'd like to explore</p>
      </header>

      <div class="app-grid">
        <div class="app-card" routerLink="/tracker">
          <div class="app-icon">📦</div>
          <h2>Household Tracker</h2>
          <p>Keep track of where you store your household items. Search, organize, and never lose track of your belongings again.</p>
          <div class="app-features">
            <span class="feature">🔍 Search Items</span>
            <span class="feature">📍 Location Hierarchy</span>
            <span class="feature">💾 Backup & Restore</span>
            <span class="feature">🏷️ Categories & Tags</span>
          </div>
          <button class="app-button primary">Launch Tracker</button>
        </div>

        <div class="app-card" routerLink="/demo">
          <div class="app-icon">🎛️</div>
          <h2>Angular Demo</h2>
          <p>Explore various Angular features including signals, components, audio player, and iframe communication demos.</p>
          <div class="app-features">
            <span class="feature">⚡ Angular Signals</span>
            <span class="feature">🎵 Audio Player</span>
            <span class="feature">🎨 Custom Icons</span>
            <span class="feature">🖼️ iFrame Communication</span>
          </div>
          <button class="app-button secondary">View Demo</button>
        </div>
      </div>

      <footer class="welcome-footer">
        <p>Built with Angular 20 • Choose an application above to get started</p>
      </footer>
    </div>
  `,
  styles: [`
    .welcome-container {
      min-height: 100vh;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 2rem;
      box-sizing: border-box;
    }

    .welcome-header {
      text-align: center;
      color: white;
      margin-bottom: 4rem;
    }

    .welcome-header h1 {
      font-size: 3rem;
      font-weight: 700;
      margin-bottom: 1rem;
      text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
    }

    .welcome-header p {
      font-size: 1.25rem;
      opacity: 0.9;
      font-weight: 300;
    }

    .app-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
      gap: 2rem;
      max-width: 1000px;
      width: 100%;
    }

    .app-card {
      background: white;
      border-radius: 16px;
      padding: 2.5rem;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
      transition: all 0.3s ease;
      cursor: pointer;
      text-decoration: none;
      color: inherit;
      display: flex;
      flex-direction: column;
      align-items: center;
      text-align: center;
    }

    .app-card:hover {
      transform: translateY(-8px);
      box-shadow: 0 16px 48px rgba(0, 0, 0, 0.2);
    }

    .app-icon {
      font-size: 4rem;
      margin-bottom: 1.5rem;
      filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.1));
    }

    .app-card h2 {
      font-size: 1.75rem;
      font-weight: 600;
      color: #333;
      margin-bottom: 1rem;
    }

    .app-card p {
      font-size: 1rem;
      color: #666;
      line-height: 1.6;
      margin-bottom: 2rem;
    }

    .app-features {
      display: flex;
      flex-wrap: wrap;
      gap: 0.75rem;
      justify-content: center;
      margin-bottom: 2rem;
    }

    .feature {
      background: #f3f4f6;
      color: #374151;
      padding: 0.5rem 0.75rem;
      border-radius: 20px;
      font-size: 0.875rem;
      font-weight: 500;
    }

    .app-button {
      padding: 0.875rem 2rem;
      border: none;
      border-radius: 8px;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      min-width: 160px;
    }

    .app-button.primary {
      background: #4f46e5;
      color: white;
    }

    .app-button.primary:hover {
      background: #4338ca;
      transform: scale(1.05);
    }

    .app-button.secondary {
      background: #059669;
      color: white;
    }

    .app-button.secondary:hover {
      background: #047857;
      transform: scale(1.05);
    }

    .welcome-footer {
      margin-top: 4rem;
      text-align: center;
      color: white;
      opacity: 0.8;
    }

    .welcome-footer p {
      font-size: 0.9rem;
      margin: 0;
    }

    @media (max-width: 768px) {
      .welcome-container {
        padding: 1rem;
      }

      .welcome-header h1 {
        font-size: 2.5rem;
      }

      .app-grid {
        grid-template-columns: 1fr;
        max-width: 500px;
      }

      .app-card {
        padding: 2rem;
      }

      .app-features {
        flex-direction: column;
        align-items: center;
      }
    }

    @media (max-width: 480px) {
      .welcome-header h1 {
        font-size: 2rem;
      }

      .app-card {
        padding: 1.5rem;
      }

      .app-icon {
        font-size: 3rem;
      }
    }
  `]
})
export class WelcomeComponent {}