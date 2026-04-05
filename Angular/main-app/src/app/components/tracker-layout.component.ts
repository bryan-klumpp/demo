import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-tracker-layout',
  standalone: true,
  imports: [CommonModule, RouterModule, RouterOutlet],
  template: `
    <!-- Navigation -->
    <nav class="tracker-nav">
      <div class="nav-container">
        <h1 routerLink="/tracker" class="nav-logo">📦 Household Tracker</h1>
        <div class="nav-links">
          <a routerLink="/tracker" routerLinkActive="active" [routerLinkActiveOptions]="{exact:true}">Dashboard</a>
          <a routerLink="/tracker/search" routerLinkActive="active">Find Items</a>
          <a routerLink="/tracker/add-item" routerLinkActive="active">Add Item</a>
          <a routerLink="/tracker/locations" routerLinkActive="active">Locations</a>
          <a routerLink="/tracker/backup" routerLinkActive="active">Backup</a>
        </div>
        <button routerLink="/" class="home-btn">🏠 Main Menu</button>
      </div>
    </nav>

    <!-- Main Content -->
    <main class="tracker-content">
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

    .tracker-nav {
      background: #4f46e5;
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
      gap: 2rem;
    }

    .nav-logo {
      font-size: 1.5rem;
      font-weight: 600;
      color: white;
      text-decoration: none;
      cursor: pointer;
      margin: 0;
      white-space: nowrap;
    }

    .nav-logo:hover {
      opacity: 0.9;
    }

    .nav-links {
      display: flex;
      gap: 1.5rem;
      align-items: center;
      flex: 1;
      justify-content: center;
    }

    .nav-links a {
      color: white;
      text-decoration: none;
      padding: 0.5rem 1rem;
      border-radius: 6px;
      transition: all 0.3s ease;
      font-weight: 500;
      white-space: nowrap;
    }

    .nav-links a:hover {
      background: rgba(255, 255, 255, 0.2);
    }

    .nav-links a.active {
      background: rgba(255, 255, 255, 0.3);
      box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.1);
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
      text-decoration: none;
      display: inline-block;
      transition: all 0.3s ease;
      white-space: nowrap;
    }

    .home-btn:hover {
      background: rgba(255, 255, 255, 0.3);
    }

    .tracker-content {
      flex: 1;
      background: #f9fafb;
      min-height: 0;
      overflow-y: auto;
    }

    @media (max-width: 968px) {
      .nav-container {
        flex-wrap: wrap;
        gap: 1rem;
      }

      .nav-links {
        order: 3;
        width: 100%;
        justify-content: center;
        gap: 0.5rem;
        flex-wrap: wrap;
      }

      .nav-links a {
        font-size: 0.9rem;
        padding: 0.5rem 0.75rem;
      }
    }

    @media (max-width: 768px) {
      .nav-container {
        padding: 1rem;
      }

      .nav-logo {
        font-size: 1.25rem;
      }

      .home-btn {
        font-size: 0.8rem;
        padding: 0.5rem 0.75rem;
      }
    }
  `]
})
export class TrackerLayoutComponent {}