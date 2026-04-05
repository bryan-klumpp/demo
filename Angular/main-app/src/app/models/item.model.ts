export interface Item {
  id?: number;
  name: string;
  description?: string;
  category?: string;
  locationId?: number;
  tags?: string[];
  value?: number;
  purchaseDate?: Date;
  condition?: ItemCondition;
  notes?: string;
  imageUrl?: string;
  createdAt: Date;
  updatedAt: Date;
}

export enum ItemCondition {
  NEW = 'new',
  EXCELLENT = 'excellent',
  GOOD = 'good',
  FAIR = 'fair',
  POOR = 'poor'
}

export interface ItemWithLocation extends Item {
  locationPath?: string;
  location?: Location;
}

import { Location } from './location.model';