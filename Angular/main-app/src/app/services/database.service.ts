import { Injectable } from '@angular/core';
import { Dexie, Table } from 'dexie';
import { Item, ItemWithLocation } from '../models/item.model';
import { Location, LocationType, LocationHierarchy } from '../models/location.model';
import { Alarm } from '../models/alarm.model';

@Injectable({
  providedIn: 'root'
})
export class DatabaseService extends Dexie {
  items!: Table<Item, number>;
  locations!: Table<Location, number>;
  alarms!: Table<Alarm, number>;

  constructor() {
    super('HouseholdTracker');

    this.version(1).stores({
      items: '++id, name, category, locationId, *tags, createdAt, updatedAt',
      locations: '++id, name, type, parentId, createdAt, updatedAt'
    });

    // Version 2: adds alarms table for time management feature
    this.version(2).stores({
      alarms: '++id, time, enabled, createdAt, updatedAt'
    });

    this.items.hook('creating', (primKey, obj, trans) => {
      obj.createdAt = new Date();
      obj.updatedAt = new Date();
    });

    this.items.hook('updating', (modifications, primKey, obj, trans) => {
      const mod = modifications as any;
      mod.updatedAt = new Date();
    });

    this.locations.hook('creating', (primKey, obj, trans) => {
      obj.createdAt = new Date();
      obj.updatedAt = new Date();
    });

    this.locations.hook('updating', (modifications, primKey, obj, trans) => {
      const mod = modifications as any;
      mod.updatedAt = new Date();
    });

    this.alarms.hook('creating', (primKey, obj, trans) => {
      obj.createdAt = new Date();
      obj.updatedAt = new Date();
    });

    this.alarms.hook('updating', (modifications, primKey, obj, trans) => {
      const mod = modifications as any;
      mod.updatedAt = new Date();
    });
  }

  // Location operations
  async addLocation(location: Omit<Location, 'id'>): Promise<number> {
    const locationToAdd = {
      ...location,
      createdAt: new Date(),
      updatedAt: new Date()
    };
    return await this.locations.add(locationToAdd as any);
  }

  async updateLocation(id: number, changes: Partial<Location>): Promise<number> {
    return await this.locations.update(id, changes);
  }

  async deleteLocation(id: number): Promise<void> {
    // Check if location has items
    const itemsInLocation = await this.items.where('locationId').equals(id).count();
    if (itemsInLocation > 0) {
      throw new Error('Cannot delete location that contains items');
    }
    
    // Check if location has sub-locations
    const subLocations = await this.locations.where('parentId').equals(id).count();
    if (subLocations > 0) {
      throw new Error('Cannot delete location that contains sub-locations');
    }
    
    await this.locations.delete(id);
  }

  async getAllLocations(): Promise<Location[]> {
    return await this.locations.orderBy('name').toArray();
  }

  async getLocationHierarchy(): Promise<LocationHierarchy[]> {
    const allLocations = await this.getAllLocations();
    return this.buildLocationHierarchy(allLocations);
  }

  private buildLocationHierarchy(locations: Location[]): LocationHierarchy[] {
    const locationMap = new Map<number, LocationHierarchy>();
    const rootLocations: LocationHierarchy[] = [];

    // Convert to hierarchy objects and map by id
    locations.forEach(location => {
      const hierarchyLocation: LocationHierarchy = {
        ...location,
        children: []
      };
      locationMap.set(location.id!, hierarchyLocation);
    });

    // Build parent-child relationships
    locations.forEach(location => {
      const hierarchyLocation = locationMap.get(location.id!);
      if (!hierarchyLocation) return;

      if (location.parentId) {
        const parent = locationMap.get(location.parentId);
        if (parent) {
          parent.children!.push(hierarchyLocation);
        }
      } else {
        rootLocations.push(hierarchyLocation);
      }
    });

    // Generate full paths
    this.generateLocationPaths(rootLocations);
    
    return rootLocations;
  }

  private generateLocationPaths(locations: LocationHierarchy[], parentPath = ''): void {
    locations.forEach(location => {
      location.fullPath = parentPath ? `${parentPath} > ${location.name}` : location.name;
      if (location.children?.length) {
        this.generateLocationPaths(location.children, location.fullPath);
      }
    });
  }

  async getLocationById(id: number): Promise<Location | undefined> {
    return await this.locations.get(id);
  }

  async getLocationPath(locationId: number): Promise<string> {
    let path = '';
    let currentId = locationId;
    
    while (currentId) {
      const location = await this.getLocationById(currentId);
      if (!location) break;
      
      path = path ? `${location.name} > ${path}` : location.name;
      currentId = location.parentId || 0;
    }
    
    return path;
  }

  // Item operations
  async addItem(item: Omit<Item, 'id'>): Promise<number> {
    const itemToAdd = {
      ...item,
      createdAt: new Date(),
      updatedAt: new Date()
    };
    return await this.items.add(itemToAdd as any);
  }

  async updateItem(id: number, changes: Partial<Item>): Promise<number> {
    return await this.items.update(id, changes);
  }

  async deleteItem(id: number): Promise<void> {
    await this.items.delete(id);
  }

  async getAllItems(): Promise<ItemWithLocation[]> {
    const items = await this.items.orderBy('name').toArray();
    return await this.enrichItemsWithLocation(items);
  }

  async getItemById(id: number): Promise<ItemWithLocation | undefined> {
    const item = await this.items.get(id);
    if (!item) return undefined;
    
    const enrichedItems = await this.enrichItemsWithLocation([item]);
    return enrichedItems[0];
  }

  private async enrichItemsWithLocation(items: Item[]): Promise<ItemWithLocation[]> {
    return await Promise.all(
      items.map(async item => {
        let locationPath = '';
        let location = undefined;
        
        if (item.locationId) {
          locationPath = await this.getLocationPath(item.locationId);
          location = await this.getLocationById(item.locationId);
        }
        
        return {
          ...item,
          locationPath,
          location
        };
      })
    );
  }

  // Search operations
  async searchItems(query: string): Promise<ItemWithLocation[]> {
    const searchTerm = query.toLowerCase();
    
    const items = await this.items
      .filter(item => {
        const name = item.name?.toLowerCase() || '';
        const description = item.description?.toLowerCase() || '';
        const category = item.category?.toLowerCase() || '';
        const notes = item.notes?.toLowerCase() || '';
        const tagsMatch = item.tags?.some(tag => tag?.toLowerCase().includes(searchTerm)) || false;
        
        return name.includes(searchTerm) ||
               description.includes(searchTerm) ||
               category.includes(searchTerm) ||
               tagsMatch ||
               notes.includes(searchTerm);
      })
      .toArray();
    
    return await this.enrichItemsWithLocation(items);
  }

  async getItemsByLocation(locationId: number, includeSubLocations = false): Promise<ItemWithLocation[]> {
    if (!includeSubLocations) {
      const items = await this.items.where('locationId').equals(locationId).toArray();
      return await this.enrichItemsWithLocation(items);
    }

    // Get all sub-location IDs
    const allLocationIds = await this.getLocationAndSubLocationIds(locationId);
    const items = await this.items.where('locationId').anyOf(allLocationIds).toArray();
    return await this.enrichItemsWithLocation(items);
  }

  private async getLocationAndSubLocationIds(locationId: number): Promise<number[]> {
    const ids = [locationId];
    const subLocations = await this.locations.where('parentId').equals(locationId).toArray();
    
    for (const subLocation of subLocations) {
      const subIds = await this.getLocationAndSubLocationIds(subLocation.id!);
      ids.push(...subIds);
    }
    
    return ids;
  }

  async getItemsByCategory(category: string): Promise<ItemWithLocation[]> {
    const items = await this.items.where('category').equals(category).toArray();
    return await this.enrichItemsWithLocation(items);
  }

  // Alarm operations
  async addAlarm(alarm: Omit<Alarm, 'id'>): Promise<number> {
    return await this.alarms.add({ ...alarm, createdAt: new Date(), updatedAt: new Date() } as any);
  }

  async updateAlarm(id: number, changes: Partial<Alarm>): Promise<number> {
    return await this.alarms.update(id, changes);
  }

  async deleteAlarm(id: number): Promise<void> {
    await this.alarms.delete(id);
  }

  async getAllAlarms(): Promise<Alarm[]> {
    return await this.alarms.orderBy('time').toArray();
  }

  async getEnabledAlarms(): Promise<Alarm[]> {
    return await this.alarms.where('enabled').equals(1).toArray();
  }

  // Backup and restore functions
  async exportData(): Promise<string> {
    const items = await this.items.toArray();
    const locations = await this.locations.toArray();
    // Export alarm settings without binary audio data (files can be large)
    const alarms = (await this.alarms.toArray()).map(({ audioData, ...rest }) => rest);

    const exportData = {
      version: 2,
      timestamp: new Date().toISOString(),
      items,
      locations,
      alarms
    };

    return JSON.stringify(exportData, null, 2);
  }

  async importData(jsonData: string): Promise<void> {
    try {
      const data = JSON.parse(jsonData);

      if (data.version !== 1 && data.version !== 2) {
        throw new Error('Unsupported backup version');
      }

      await this.transaction('rw', [this.items, this.locations, this.alarms], async () => {
        await this.items.clear();
        await this.locations.clear();
        await this.alarms.clear();

        if (data.locations) {
          await this.locations.bulkAdd(data.locations);
        }
        if (data.items) {
          await this.items.bulkAdd(data.items);
        }
        if (data.alarms) {
          await this.alarms.bulkAdd(data.alarms);
        }
      });

    } catch (error) {
      throw new Error(`Failed to import data: ${error}`);
    }
  }

  // Statistics
  async getStats() {
    const [itemCount, locationCount, categories] = await Promise.all([
      this.items.count(),
      this.locations.count(),
      this.items.orderBy('category').uniqueKeys()
    ]);

    const itemsByCategory = await Promise.all(
      categories.map(async category => ({
        category: category || 'Uncategorized',
        count: await this.items.where('category').equals(category).count()
      }))
    );

    return {
      totalItems: itemCount,
      totalLocations: locationCount,
      categoriesCount: categories.length,
      itemsByCategory
    };
  }
}