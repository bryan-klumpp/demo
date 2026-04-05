import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { DatabaseService } from '../services/database.service';
import { Item, ItemCondition } from '../models/item.model';
import { LocationHierarchy } from '../models/location.model';

@Component({
  selector: 'app-add-item',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  template: `
    <div class="add-item-container">
      <header class="form-header">
        <h1>➕ Add New Item</h1>
        <p>Add an item to track its location in your home</p>
      </header>

      <form (ngSubmit)="onSubmit()" class="item-form">
        <div class="form-group">
          <label for="name">Item Name *</label>
          <input
            type="text"
            id="name"
            [(ngModel)]="item.name"
            name="name"
            required
            class="form-control"
            placeholder="Enter item name"
          />
        </div>

        <div class="form-group">
          <label for="description">Description</label>
          <textarea
            id="description"
            [(ngModel)]="item.description"
            name="description"
            class="form-control"
            rows="3"
            placeholder="Describe the item (optional)"
          ></textarea>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="category">Category</label>
            <input
              type="text"
              id="category"
              [(ngModel)]="item.category"
              name="category"
              class="form-control"
              placeholder="e.g., Electronics, Books, Clothing"
              list="categories"
            />
            <datalist id="categories">
              <option *ngFor="let category of existingCategories" [value]="category"></option>
            </datalist>
          </div>

          <div class="form-group">
            <label for="condition">Condition</label>
            <select id="condition" [(ngModel)]="item.condition" name="condition" class="form-control">
              <option value="">Select condition</option>
              <option value="new">New</option>
              <option value="excellent">Excellent</option>
              <option value="good">Good</option>
              <option value="fair">Fair</option>
              <option value="poor">Poor</option>
            </select>
          </div>
        </div>

        <div class="form-group">
          <label for="location">Location</label>
          <select id="location" [(ngModel)]="item.locationId" name="location" class="form-control">
            <option value="">Select location (optional)</option>
            <option *ngFor="let location of flatLocations" [value]="location.id">
              {{ location.fullPath }}
            </option>
          </select>
          <p class="help-text">
            Don't see your location? 
            <a routerLink="/tracker/add-location" target="_blank">Create a new location</a>
          </p>
        </div>

        <div class="form-group">
          <label for="tags">Tags</label>
          <input
            type="text"
            id="tags"
            [(ngModel)]="tagsInput"
            name="tags"
            class="form-control"
            placeholder="Enter tags separated by commas (e.g., vintage, fragile, important)"
          />
          <p class="help-text">Separate tags with commas</p>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="value">Estimated Value ($)</label>
            <input
              type="number"
              id="value"
              [(ngModel)]="item.value"
              name="value"
              min="0"
              step="0.01"
              class="form-control"
              placeholder="0.00"
            />
          </div>

          <div class="form-group">
            <label for="purchaseDate">Purchase Date</label>
            <input
              type="date"
              id="purchaseDate"
              [(ngModel)]="purchaseDateString"
              name="purchaseDate"
              class="form-control"
            />
          </div>
        </div>

        <div class="form-group">
          <label for="notes">Additional Notes</label>
          <textarea
            id="notes"
            [(ngModel)]="item.notes"
            name="notes"
            class="form-control"
            rows="3"
            placeholder="Any additional information about this item"
          ></textarea>
        </div>

        <div class="form-actions">
          <button 
            type="button" 
            (click)="goBack()" 
            class="btn btn-secondary"
          >
            Cancel
          </button>
          
          <button 
            type="submit" 
            [disabled]="!item.name.trim() || isSubmitting"
            class="btn btn-primary"
          >
            {{ isSubmitting ? 'Adding...' : 'Add Item' }}
          </button>
        </div>
      </form>

      <div class="quick-links">
        <button routerLink="/tracker" class="nav-link">🏠 Dashboard</button>
        <button routerLink="/tracker/search" class="nav-link">🔍 Find Items</button>
        <button routerLink="/tracker/add-location" class="nav-link">📍 Add Location</button>
      </div>
    </div>
  `,
  styles: [`
    .add-item-container {
      max-width: 800px;
      margin: 0 auto;
      padding: 2rem;
    }

    .form-header {
      text-align: center;
      margin-bottom: 2rem;
    }

    .form-header h1 {
      font-size: 2.5rem;
      color: #333;
      margin-bottom: 0.5rem;
    }

    .form-header p {
      color: #666;
      font-size: 1.1rem;
    }

    .item-form {
      background: white;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      padding: 2rem;
      margin-bottom: 2rem;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }

    .form-group {
      margin-bottom: 1.5rem;
    }

    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1rem;
    }

    @media (max-width: 768px) {
      .form-row {
        grid-template-columns: 1fr;
      }
    }

    label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: 500;
      color: #374151;
    }

    .form-control {
      width: 100%;
      padding: 0.75rem;
      border: 1px solid #d1d5db;
      border-radius: 6px;
      font-size: 1rem;
      box-sizing: border-box;
    }

    .form-control:focus {
      outline: none;
      border-color: #4f46e5;
      box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }

    .help-text {
      margin-top: 0.25rem;
      font-size: 0.875rem;
      color: #6b7280;
    }

    .help-text a {
      color: #4f46e5;
      text-decoration: none;
    }

    .help-text a:hover {
      text-decoration: underline;
    }

    .form-actions {
      display: flex;
      gap: 1rem;
      justify-content: flex-end;
      margin-top: 2rem;
      padding-top: 1.5rem;
      border-top: 1px solid #e5e7eb;
    }

    .btn {
      padding: 0.75rem 1.5rem;
      border: none;
      border-radius: 6px;
      font-size: 1rem;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .btn:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }

    .btn-primary {
      background: #4f46e5;
      color: white;
    }

    .btn-primary:hover:not(:disabled) {
      background: #4338ca;
    }

    .btn-secondary {
      background: #e5e7eb;
      color: #374151;
    }

    .btn-secondary:hover {
      background: #d1d5db;
    }

    .quick-links {
      display: flex;
      gap: 1rem;
      justify-content: center;
      flex-wrap: wrap;
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
export class AddItemComponent implements OnInit {
  item: Omit<Item, 'id'> = {
    name: '',
    description: '',
    category: '',
    locationId: undefined,
    tags: [],
    value: undefined,
    purchaseDate: undefined,
    condition: undefined,
    notes: '',
    imageUrl: '',
    createdAt: new Date(),
    updatedAt: new Date()
  };
  
  tagsInput = '';
  purchaseDateString = '';
  flatLocations: LocationHierarchy[] = [];
  existingCategories: string[] = [];
  isSubmitting = false;

  constructor(
    private db: DatabaseService,
    private router: Router
  ) {}

  async ngOnInit() {
    await this.loadFormData();
  }

  private async loadFormData() {
    try {
      // Load location hierarchy and flatten it
      const locationHierarchy = await this.db.getLocationHierarchy();
      this.flatLocations = this.flattenLocationHierarchy(locationHierarchy);
      
      // Load existing categories for autocomplete
      const stats = await this.db.getStats();
      this.existingCategories = stats.itemsByCategory.map(cat => String(cat.category)).filter((category): category is string => Boolean(category));
    } catch (error) {
      console.error('Error loading form data:', error);
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

  async onSubmit() {
    if (!this.item.name.trim() || this.isSubmitting) {
      return;
    }

    this.isSubmitting = true;

    try {
      // Process tags
      if (this.tagsInput.trim()) {
        this.item.tags = this.tagsInput
          .split(',')
          .map(tag => tag.trim())
          .filter(tag => tag.length > 0);
      }

      // Process purchase date
      if (this.purchaseDateString) {
        this.item.purchaseDate = new Date(this.purchaseDateString);
      }

      // Set locationId to undefined if not set
      if (this.item.locationId === null || this.item.locationId === undefined || this.item.locationId === 0) {
        this.item.locationId = undefined;
      }

      const itemId = await this.db.addItem(this.item);
      
      console.log('Item added successfully with ID:', itemId);
      
      // Navigate back to dashboard or search page
      this.router.navigate(['/tracker/search']);
      
    } catch (error) {
      console.error('Error adding item:', error);
      alert('Failed to add item. Please try again.');
    } finally {
      this.isSubmitting = false;
    }
  }

  goBack() {
    this.router.navigate(['/tracker']);
  }
}