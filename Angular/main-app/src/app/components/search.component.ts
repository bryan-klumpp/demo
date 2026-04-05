import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { DatabaseService } from '../services/database.service';
import { ItemWithLocation } from '../models/item.model';
import { LocationHierarchy } from '../models/location.model';

@Component({
  selector: 'app-search',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  template: `
    <div class="search-container">
      <header class="search-header">
        <h1>🔍 Find Your Items</h1>
        <p>Search by name, category, tags, or browse by location</p>
      </header>

      <div class="search-controls">
        <div class="search-box">
          <input
            type="text"
            [(ngModel)]="searchQuery"
            (input)="onSearchInput()"
            placeholder="Search for items..."
            class="search-input"
          />
          <button (click)="clearSearch()" class="clear-btn" *ngIf="searchQuery">✖️</button>
        </div>

        <div class="filter-section">
          <select [(ngModel)]="selectedLocationId" (change)="onLocationFilter()" class="location-filter">
            <option value="">All Locations</option>
            <option *ngFor="let location of flatLocations" [value]="location.id">
              {{ location.fullPath }}
            </option>
          </select>
          
          <select [(ngModel)]="selectedCategory" (change)="onCategoryFilter()" class="category-filter">
            <option value="">All Categories</option>
            <option *ngFor="let category of categories" [value]="category">
              {{ category || 'Uncategorized' }}
            </option>
          </select>
        </div>
      </div>

      <div class="search-stats" *ngIf="searchResults">
        <p>Found {{ searchResults.length }} item(s)</p>
      </div>

      <div class="results-section" *ngIf="searchResults">
        <div *ngIf="searchResults.length === 0" class="no-results">
          <p>No items found matching your search criteria.</p>
          <button routerLink="/tracker/add-item" class="add-item-btn">➕ Add New Item</button>
        </div>

        <div class="results-grid" *ngIf="searchResults.length > 0">
          <div *ngFor="let item of searchResults" class="item-card">
            <div class="item-header">
              <h3>{{ item.name }}</h3>
              <div class="item-actions">
                <button (click)="editItem(item)" class="edit-btn" title="Edit">✏️</button>
                <button (click)="deleteItem(item)" class="delete-btn" title="Delete">🗑️</button>
              </div>
            </div>
            
            <div class="item-details">
              <p *ngIf="item.description" class="description">{{ item.description }}</p>
              
              <div class="item-meta">
                <span *ngIf="item.category" class="category">🏷️ {{ item.category }}</span>
                <span *ngIf="item.locationPath" class="location">📍 {{ item.locationPath }}</span>
                <span *ngIf="item.condition" class="condition">⭐ {{ item.condition }}</span>
              </div>
              
              <div class="item-tags" *ngIf="item.tags && item.tags.length > 0">
                <span *ngFor="let tag of item.tags" class="tag"># {{ tag }}</span>
              </div>
              
              <div class="item-notes" *ngIf="item.notes">
                <p><strong>Notes:</strong> {{ item.notes }}</p>
              </div>
              
              <div class="item-dates">
                <small>Added: {{ formatDate(item.createdAt) }}</small>
                <small *ngIf="item.updatedAt && item.updatedAt !== item.createdAt">
                  | Updated: {{ formatDate(item.updatedAt) }}
                </small>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="quick-links">
        <button routerLink="/tracker" class="nav-link">🏠 Dashboard</button>
        <button routerLink="/tracker/add-item" class="nav-link">➕ Add Item</button>
        <button routerLink="/tracker/locations" class="nav-link">📍 Manage Locations</button>
      </div>
    </div>
  `,
  styles: [`
    .search-container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 2rem;
    }

    .search-header {
      text-align: center;
      margin-bottom: 2rem;
    }

    .search-header h1 {
      font-size: 2.5rem;
      color: #333;
      margin-bottom: 0.5rem;
    }

    .search-header p {
      color: #666;
      font-size: 1.1rem;
    }

    .search-controls {
      background: white;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      padding: 1.5rem;
      margin-bottom: 1rem;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }

    .search-box {
      position: relative;
      margin-bottom: 1rem;
    }

    .search-input {
      width: 100%;
      padding: 0.75rem;
      border: 1px solid #d1d5db;
      border-radius: 8px;
      font-size: 1rem;
      box-sizing: border-box;
    }

    .search-input:focus {
      outline: none;
      border-color: #4f46e5;
    }

    .clear-btn {
      position: absolute;
      right: 0.5rem;
      top: 50%;
      transform: translateY(-50%);
      background: none;
      border: none;
      cursor: pointer;
      font-size: 0.9rem;
    }

    .filter-section {
      display: flex;
      gap: 1rem;
      flex-wrap: wrap;
    }

    .location-filter, .category-filter {
      flex: 1;
      min-width: 200px;
      padding: 0.5rem;
      border: 1px solid #d1d5db;
      border-radius: 6px;
      font-size: 0.9rem;
    }

    .search-stats {
      margin-bottom: 1rem;
      color: #666;
    }

    .no-results {
      text-align: center;
      padding: 2rem;
      color: #666;
    }

    .add-item-btn {
      background: #4f46e5;
      color: white;
      border: none;
      padding: 0.75rem 1.5rem;
      border-radius: 8px;
      cursor: pointer;
      text-decoration: none;
      display: inline-block;
      margin-top: 1rem;
    }

    .results-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
      gap: 1.5rem;
      margin-bottom: 2rem;
    }

    .item-card {
      background: white;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      padding: 1.5rem;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
      transition: transform 0.2s ease;
    }

    .item-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }

    .item-header {
      display: flex;
      justify-content: space-between;
      align-items: start;
      margin-bottom: 1rem;
    }

    .item-header h3 {
      margin: 0;
      color: #333;
      font-size: 1.2rem;
    }

    .item-actions {
      display: flex;
      gap: 0.5rem;
    }

    .edit-btn, .delete-btn {
      background: none;
      border: none;
      cursor: pointer;
      font-size: 1.1rem;
      padding: 0.25rem;
      border-radius: 4px;
    }

    .edit-btn:hover {
      background: #f3f4f6;
    }

    .delete-btn:hover {
      background: #fee2e2;
    }

    .description {
      color: #666;
      font-style: italic;
      margin-bottom: 1rem;
    }

    .item-meta {
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
      margin-bottom: 1rem;
    }

    .item-meta span {
      font-size: 0.9rem;
    }

    .category {
      color: #7c3aed;
    }

    .location {
      color: #059669;
    }

    .condition {
      color: #f59e0b;
    }

    .item-tags {
      margin-bottom: 1rem;
    }

    .tag {
      display: inline-block;
      background: #e5e7eb;
      color: #374151;
      padding: 0.25rem 0.5rem;
      border-radius: 4px;
      font-size: 0.75rem;
      margin-right: 0.5rem;
      margin-bottom: 0.25rem;
    }

    .item-notes {
      background: #f9fafb;
      padding: 0.75rem;
      border-radius: 6px;
      margin-bottom: 1rem;
    }

    .item-notes p {
      margin: 0;
      font-size: 0.9rem;
      color: #374151;
    }

    .item-dates {
      font-size: 0.75rem;
      color: #9ca3af;
      border-top: 1px solid #f3f4f6;
      padding-top: 0.75rem;
    }

    .quick-links {
      display: flex;
      gap: 1rem;
      justify-content: center;
      flex-wrap: wrap;
      margin-top: 2rem;
      padding-top: 2rem;
      border-top: 1px solid #e5e7eb;
    }

    .nav-link {
      padding: 0.75rem 1.5rem;
      background: white;
      border: 1px solid #d1d5db;
      border-radius: 8px;
      color: #374151;
      text-decoration: none;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .nav-link:hover {
      background: #f9fafb;
      border-color: #9ca3af;
    }
  `]
})
export class SearchComponent implements OnInit {
  searchQuery = '';
  searchResults: ItemWithLocation[] = [];
  flatLocations: LocationHierarchy[] = [];
  categories: string[] = [];
  selectedLocationId = '';
  selectedCategory = '';
  
  private searchTimeout: any;

  constructor(private db: DatabaseService) {}

  async ngOnInit() {
    await this.loadInitialData();
    await this.loadAllItems(); // Start with all items
  }

  private async loadInitialData() {
    try {
      // Load location hierarchy and flatten it
      const locationHierarchy = await this.db.getLocationHierarchy();
      this.flatLocations = this.flattenLocationHierarchy(locationHierarchy);
      
      // Load unique categories
      const stats = await this.db.getStats();
      this.categories = stats.itemsByCategory.map(cat => String(cat.category)).filter((category): category is string => Boolean(category));
    } catch (error) {
      console.error('Error loading initial data:', error);
    }
  }

  private flattenLocationHierarchy(locations: LocationHierarchy[]): LocationHierarchy[] {
    let flat: LocationHierarchy[] = [];
    
    for (const location of locations) {
      flat.push(location);
      if (location.children && location.children.length > 0) {
        flat = flat.concat(this.flattenLocationHierarchy(location.children));
      }
    }
    
    return flat;
  }

  async loadAllItems() {
    try {
      this.searchResults = await this.db.getAllItems();
    } catch (error) {
      console.error('Error loading items:', error);
      this.searchResults = [];
    }
  }

  onSearchInput() {
    // Debounce search
    clearTimeout(this.searchTimeout);
    this.searchTimeout = setTimeout(() => {
      this.performSearch();
    }, 300);
  }

  async performSearch() {
    try {
      if (!this.searchQuery.trim() && !this.selectedLocationId && !this.selectedCategory) {
        await this.loadAllItems();
        return;
      }

      let results: ItemWithLocation[] = [];

      if (this.searchQuery.trim()) {
        results = await this.db.searchItems(this.searchQuery);
      } else {
        results = await this.db.getAllItems();
      }

      // Apply location filter
      if (this.selectedLocationId) {
        const locationId = parseInt(this.selectedLocationId);
        const locationItems = await this.db.getItemsByLocation(locationId, true);
        const locationItemIds = new Set(locationItems.map(item => item.id));
        results = results.filter(item => locationItemIds.has(item.id));
      }

      // Apply category filter
      if (this.selectedCategory) {
        results = results.filter(item => item.category === this.selectedCategory);
      }

      this.searchResults = results;
    } catch (error) {
      console.error('Error performing search:', error);
      this.searchResults = [];
    }
  }

  async onLocationFilter() {
    await this.performSearch();
  }

  async onCategoryFilter() {
    await this.performSearch();
  }

  clearSearch() {
    this.searchQuery = '';
    this.selectedLocationId = '';
    this.selectedCategory = '';
    this.loadAllItems();
  }

  editItem(item: ItemWithLocation) {
    // TODO: Navigate to edit item page
    console.log('Edit item:', item);
  }

  async deleteItem(item: ItemWithLocation) {
    if (confirm(`Are you sure you want to delete "${item.name}"?`)) {
      try {
        await this.db.deleteItem(item.id!);
        await this.performSearch(); // Refresh results
      } catch (error) {
        console.error('Error deleting item:', error);
        alert('Failed to delete item');
      }
    }
  }

  formatDate(date: Date | string): string {
    const d = date instanceof Date ? date : new Date(date);
    return d.toLocaleDateString();
  }
}