import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-database-export-layout',
  standalone: true,
  imports: [CommonModule, RouterModule, RouterOutlet],
  template: `
    <nav class="de-nav">
      <div class="nav-container">
        <h1 class="nav-logo">🗄️ Database Export</h1>
        <button routerLink="/" class="home-btn">🏠 Main Menu</button>
      </div>
    </nav>

    <main class="de-content">
      <router-outlet></router-outlet>
    </main>
  `,
  styles: [`
    :host {
      display: flex;
      flex-direction: column;
      height: 100vh;
      font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
        Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji",
        "Segoe UI Symbol";
    }

    .de-nav {
      background: #b45309;
      color: white;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      position: sticky;
      top: 0;
      z-index: 1000;
    }

    .nav-container {
      max-width: 1200px;
      margin: 0 auto;
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 1rem 2rem;
    }

    .nav-logo {
      font-size: 1.5rem;
      font-weight: 600;
      color: white;
      margin: 0;
    }

    .home-btn {
      background: rgba(255, 255, 255, 0.2);
      color: white;
      border: none;
      padding: 0.5rem 1rem;
      border-radius: 6px;
      cursor: pointer;
      font-size: 0.9rem;
      font-weight: 500;
      transition: all 0.3s ease;
      white-space: nowrap;
    }

    .home-btn:hover {
      background: rgba(255, 255, 255, 0.3);
    }

    .de-content {
      flex: 1;
      background: #f9fafb;
      min-height: 0;
      overflow-y: auto;
    }

    @media (max-width: 768px) {
      .nav-container {
        padding: 1rem;
      }

      .nav-logo {
        font-size: 1.25rem;
      }
    }
  `]
})
export class DatabaseExportLayoutComponent {}
