import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router, RouterModule } from '@angular/router';
import { DatabaseService } from '../services/database.service';
import { Location, LocationType, LocationHierarchy } from '../models/location.model';

// Location Tree Node Component
@Component({
  selector: 'app-location-tree-node',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="tree-node">
      <div class="node-content">
        <span class="node-icon">{{ getLocationIcon(location.type) }}</span>
        <span class="node-name">{{ location.name }}</span>
        <span class="node-type">({{ getLocationTypeLabel(location.type) }})</span>
        <button 
          (click)="onDelete()" 
          class="delete-btn" 
          title="Delete location"
        >
          🗑️
        </button>
      </div>
      
      <div class="node-children" *ngIf="location.children && location.children.length > 0">
        <app-location-tree-node
          *ngFor="let child of location.children"
          [location]="child"
          (delete)="delete.emit($event)"
          (refresh)="refresh.emit()"
        ></app-location-tree-node>
      </div>
    </div>
  `,
  styles: [`
    .tree-node {
      margin-left: 1rem;
    }

    .node-content {
      display: flex;
      align-items: center;
      padding: 0.5rem;
      margin: 0.25rem 0;
      background: #f9fafb;
      border-radius: 6px;
      border-left: 3px solid #4f46e5;
    }

    .node-content:hover {
      background: #f3f4f6;
    }

    .node-icon {
      margin-right: 0.5rem;
      font-size: 1.1rem;
    }

    .node-name {
      font-weight: 500;
      color: #333;
      flex: 1;
    }

    .node-type {
      color: #666;
      font-size: 0.875rem;
      margin-right: 0.5rem;
    }

    .delete-btn {
      background: none;
      border: none;
      cursor: pointer;
      font-size: 0.9rem;
      padding: 0.25rem;
      border-radius: 4px;
      opacity: 0.7;
    }

    .delete-btn:hover {
      background: #fee2e2;
      opacity: 1;
    }

    .node-children {
      margin-left: 1rem;
      border-left: 2px dashed #d1d5db;
      padding-left: 0.5rem;
    }
  `]
})
export class LocationTreeNodeComponent {
  @Input() location!: LocationHierarchy;
  @Output() delete = new EventEmitter<number>();
  @Output() refresh = new EventEmitter<void>();

  getLocationIcon(type: LocationType): string {
    switch (type) {
      case LocationType.ROOM:
        return '🏠';
      case LocationType.FURNITURE:
        return '🪑';
      case LocationType.SHELF_DRAWER:
        return '📚';
      case LocationType.CONTAINER:
        return '📦';
      default:
        return '📍';
    }
  }

  getLocationTypeLabel(type: LocationType): string {
    switch (type) {
      case LocationType.ROOM:
        return 'Room';
      case LocationType.FURNITURE:
        return 'Furniture';
      case LocationType.SHELF_DRAWER:
        return 'Shelf/Drawer';
      case LocationType.CONTAINER:
        return 'Container';
      default:
        return 'Unknown';
    }
  }

  onDelete() {
    if (this.location.id && confirm(`Are you sure you want to delete "${this.location.name}"?`)) {
      this.delete.emit(this.location.id);
    }
  }
}

@Component({
  selector: 'app-location-management',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule, LocationTreeNodeComponent],
  template: `
    <div class="location-container">
      <header class="location-header">
        <h1>📍 Manage Locations</h1>
        <p>Organize your storage areas hierarchically</p>
      </header>

      <div class="location-content">
        <div class="location-section">
          <h2>Add New Location</h2>
          <form (ngSubmit)="onSubmit()" class="location-form">
            <div class="form-row">
              <div class="form-group">
                <label for="name">Location Name *</label>
                <input
                  type="text"
                  id="name"
                  [(ngModel)]="newLocation.name"
                  name="name"
                  required
                  class="form-control"
                  placeholder="e.g., Kitchen, Bedroom Closet, Top Shelf"
                />
              </div>

              <div class="form-group">
                <label for="type">Location Type *</label>
                <select id="type" [(ngModel)]="newLocation.type" name="type" required class="form-control">
                  <option value="">Select type</option>
                  <option value="room">🏠 Room</option>
                  <option value="furniture">🪑 Furniture</option>
                  <option value="shelf_drawer">📚 Shelf/Drawer</option>
                  <option value="container">📦 Container</option>
                </select>
              </div>
            </div>

            <div class="form-group">
              <label for="parent">Parent Location</label>
              <select id="parent" [(ngModel)]="newLocation.parentId" name="parent" class="form-control">
                <option value="">No parent (top-level)</option>
                <option *ngFor="let location of flatLocations" [value]="location.id">
                  {{ location.fullPath }} ({{ getLocationTypeLabel(location.type) }})
                </option>
              </select>
              <p class="help-text">Choose the parent location that contains this new location</p>
            </div>

            <div class="form-group">
              <label for="description">Description</label>
              <textarea
                id="description"
                [(ngModel)]="newLocation.description"
                name="description"
                class="form-control"
                rows="2"
                placeholder="Optional description of this location"
              ></textarea>
            </div>

            <div class="form-actions">
              <button 
                type="submit" 
                [disabled]="!newLocation.name.trim() || !newLocation.type || isSubmitting"
                class="btn btn-primary"
              >
                {{ isSubmitting ? 'Adding...' : 'Add Location' }}
              </button>
            </div>
          </form>
        </div>

        <div class="location-section">
          <h2>Location Hierarchy</h2>
          <div class="hierarchy-container" *ngIf="locationHierarchy.length > 0; else noLocations">
            <div *ngFor="let location of locationHierarchy" class="location-tree">
              <app-location-tree-node 
                [location]="location" 
                (delete)="deleteLocation($event)"
                (refresh)="loadLocations()">
              </app-location-tree-node>
            </div>
          </div>
          
          <ng-template #noLocations>
            <div class="no-locations">
              <p>No locations created yet.</p>
              <p>Start by creating a room, then add furniture, shelves, and containers.</p>
            </div>
          </ng-template>
        </div>
      </div>

      <div class="location-tips">
        <h3>💡 Tips for organizing locations:</h3>
        <ul>
          <li><strong>Rooms:</strong> Kitchen, Living Room, Bedroom, Garage, Basement</li>
          <li><strong>Furniture:</strong> Bookshelf, Dresser, Desk, Kitchen Cabinet</li>
          <li><strong>Shelves/Drawers:</strong> Top Shelf, Middle Drawer, Bottom Compartment</li>
          <li><strong>Containers:</strong> Storage Box, Plastic Bin, File Folder</li>
        </ul>
      </div>

      <div class="quick-links">
        <button routerLink="/tracker" class="nav-link">🏠 Dashboard</button>
        <button routerLink="/tracker/add-item" class="nav-link">➕ Add Item</button>
        <button routerLink="/tracker/search" class="nav-link">🔍 Find Items</button>
      </div>
    </div>
  `,
  styles: [`
    .location-container {
      max-width: 1000px;
      margin: 0 auto;
      padding: 2rem;
    }

    .location-header {
      text-align: center;
      margin-bottom: 2rem;
    }

    .location-header h1 {
      font-size: 2.5rem;
      color: #333;
      margin-bottom: 0.5rem;
    }

    .location-header p {
      color: #666;
      font-size: 1.1rem;
    }

    .location-content {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 2rem;
      margin-bottom: 2rem;
    }

    @media (max-width: 768px) {
      .location-content {
        grid-template-columns: 1fr;
      }
    }

    .location-section {
      background: white;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      padding: 1.5rem;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }

    .location-section h2 {
      margin: 0 0 1.5rem 0;
      color: #333;
    }

    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1rem;
    }

    @media (max-width: 480px) {
      .form-row {
        grid-template-columns: 1fr;
      }
    }

    .form-group {
      margin-bottom: 1rem;
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

    .form-actions {
      margin-top: 1.5rem;
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

    .hierarchy-container {
      max-height: 400px;
      overflow-y: auto;
      border: 1px solid #e5e7eb;
      border-radius: 6px;
      padding: 1rem;
    }

    .no-locations {
      text-align: center;
      color: #666;
      padding: 2rem;
    }

    .location-tips {
      background: #f9fafb;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      padding: 1.5rem;
      margin-bottom: 2rem;
    }

    .location-tips h3 {
      margin: 0 0 1rem 0;
      color: #333;
    }

    .location-tips ul {
      margin: 0;
      padding-left: 1.5rem;
    }

    .location-tips li {
      margin-bottom: 0.5rem;
      color: #555;
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
export class LocationManagementComponent implements OnInit {
  newLocation: Omit<Location, 'id'> = {
    name: '',
    type: '' as LocationType,
    parentId: undefined,
    description: '',
    createdAt: new Date(),
    updatedAt: new Date()
  };
  
  locationHierarchy: LocationHierarchy[] = [];
  flatLocations: LocationHierarchy[] = [];
  isSubmitting = false;

  constructor(
    private db: DatabaseService,
    private router: Router
  ) {}

  async ngOnInit() {
    await this.loadLocations();
  }

  async loadLocations() {
    try {
      this.locationHierarchy = await this.db.getLocationHierarchy();
      this.flatLocations = this.flattenLocationHierarchy(this.locationHierarchy);
    } catch (error) {
      console.error('Error loading locations:', error);
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

  getLocationTypeLabel(type: LocationType): string {
    switch (type) {
      case LocationType.ROOM:
        return 'Room';
      case LocationType.FURNITURE:
        return 'Furniture';
      case LocationType.SHELF_DRAWER:
        return 'Shelf/Drawer';
      case LocationType.CONTAINER:
        return 'Container';
      default:
        return 'Unknown';
    }
  }

  async onSubmit() {
    if (!this.newLocation.name.trim() || !this.newLocation.type || this.isSubmitting) {
      return;
    }

    this.isSubmitting = true;

    try {
      // Set parentId to undefined if not set
      if (this.newLocation.parentId === null || this.newLocation.parentId === undefined || this.newLocation.parentId === 0) {
        this.newLocation.parentId = undefined;
      }

      await this.db.addLocation(this.newLocation);
      
      // Reset form
      this.newLocation = {
        name: '',
        type: '' as LocationType,
        parentId: undefined,
        description: '',
        createdAt: new Date(),
        updatedAt: new Date()
      };
      
      // Reload locations
      await this.loadLocations();
      
    } catch (error) {
      console.error('Error adding location:', error);
      alert('Failed to add location. Please try again.');
    } finally {
      this.isSubmitting = false;
    }
  }

  async deleteLocation(locationId: number) {
    try {
      await this.db.deleteLocation(locationId);
      await this.loadLocations();
    } catch (error) {
      console.error('Error deleting location:', error);
      alert(error instanceof Error ? error.message : 'Failed to delete location');
    }
  }
}