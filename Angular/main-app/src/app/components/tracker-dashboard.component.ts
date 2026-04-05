import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink, RouterModule } from '@angular/router';
import { DatabaseService } from '../services/database.service';

@Component({
  selector: 'app-tracker-dashboard',
  standalone: true,
  imports: [CommonModule, RouterLink, RouterModule],
  template: `
    <div class="dashboard-container">
      <header class="dashboard-header">
        <h1>📦 Household Tracker</h1>
        <p>Keep track of where you store your things</p>
      </header>

      <div class="quick-actions">
        <button routerLink="/tracker/add-item" class="action-btn primary">
          ➕ Add Item
        </button>
        <button routerLink="/tracker/add-location" class="action-btn secondary">
          📍 Add Location
        </button>
        <button routerLink="/tracker/search" class="action-btn secondary">
          🔍 Find Items
        </button>
      </div>

      <div class="stats-grid">
        <div class="stat-card">
          <h3>{{ stats?.totalItems || 0 }}</h3>
          <p>Total Items</p>
        </div>
        <div class="stat-card">
          <h3>{{ stats?.totalLocations || 0 }}</h3>
          <p>Locations</p>
        </div>
        <div class="stat-card">
          <h3>{{ stats?.categoriesCount || 0 }}</h3>
          <p>Categories</p>
        </div>
      </div>

      <div class="recent-section" *ngIf="recentItems && recentItems.length > 0">
        <h2>Recently Added Items</h2>
        <div class="recent-items">
          <div *ngFor="let item of recentItems" class="recent-item-card">
            <h4>{{ item.name }}</h4>
            <p *ngIf="item.locationPath" class="location">📍 {{ item.locationPath }}</p>
            <p *ngIf="item.category" class="category">🏷️ {{ item.category }}</p>
          </div>
        </div>
      </div>

      <div class="navigation-section">
        <h2>Quick Navigation</h2>
        <div class="nav-buttons">
          <button routerLink="/tracker/items" class="nav-btn">
            📋 All Items
          </button>
          <button routerLink="/tracker/locations" class="nav-btn">
            🏠 Manage Locations
          </button>
          <button routerLink="/tracker/backup" class="nav-btn">
            💾 Backup & Restore
          </button>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .dashboard-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 2rem;
    }

    .dashboard-header {
      text-align: center;
      margin-bottom: 2rem;
    }

    .dashboard-header h1 {
      font-size: 2.5rem;
      color: #333;
      margin-bottom: 0.5rem;
    }

    .dashboard-header p {
      color: #666;
      font-size: 1.1rem;
    }

    .quick-actions {
      display: flex;
      gap: 1rem;
      justify-content: center;
      margin-bottom: 2rem;
      flex-wrap: wrap;
    }

    .action-btn {
      padding: 0.75rem 1.5rem;
      border: none;
      border-radius: 8px;
      font-size: 1rem;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      transition: all 0.3s ease;
    }

    .action-btn.primary {
      background: #4f46e5;
      color: white;
    }

    .action-btn.primary:hover {
      background: #4338ca;
    }

    .action-btn.secondary {
      background: #e5e7eb;
      color: #374151;
    }

    .action-btn.secondary:hover {
      background: #d1d5db;
    }

    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 1rem;
      margin-bottom: 2rem;
    }

    .stat-card {
      background: white;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      padding: 1.5rem;
      text-align: center;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }

    .stat-card h3 {
      font-size: 2rem;
      color: #4f46e5;
      margin-bottom: 0.5rem;
    }

    .stat-card p {
      color: #666;
      margin: 0;
    }

    .recent-section {
      margin-bottom: 2rem;
    }

    .recent-section h2 {
      color: #333;
      margin-bottom: 1rem;
    }

    .recent-items {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 1rem;
    }

    .recent-item-card {
      background: white;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      padding: 1rem;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }

    .recent-item-card h4 {
      margin: 0 0 0.5rem 0;
      color: #333;
    }

    .recent-item-card p {
      margin: 0.25rem 0;
      font-size: 0.9rem;
      color: #666;
    }

    .location {
      color: #059669 !important;
    }

    .category {
      color: #7c3aed !important;
    }

    .navigation-section h2 {
      color: #333;
      margin-bottom: 1rem;
    }

    .nav-buttons {
      display: flex;
      gap: 1rem;
      flex-wrap: wrap;
    }

    .nav-btn {
      padding: 0.75rem 1.5rem;
      background: white;
      border: 1px solid #d1d5db;
      border-radius: 8px;
      color: #374151;
      text-decoration: none;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .nav-btn:hover {
      background: #f9fafb;
      border-color: #9ca3af;
    }
  `]
})
export class TrackerDashboardComponent implements OnInit {
  stats: any = null;
  recentItems: any[] = [];

  constructor(private db: DatabaseService) {}

  async ngOnInit() {
    await this.loadDashboardData();
  }

  private async loadDashboardData() {
    try {
      this.stats = await this.db.getStats();
      
      // Get 5 most recent items
      const allItems = await this.db.getAllItems();
      this.recentItems = allItems
        .sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
        .slice(0, 5);
    } catch (error) {
      console.error('Error loading dashboard data:', error);
    }
  }
}