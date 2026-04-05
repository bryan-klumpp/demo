export interface Location {
  id?: number;
  name: string;
  type: LocationType;
  parentId?: number;
  description?: string;
  createdAt: Date;
  updatedAt: Date;
}

export enum LocationType {
  ROOM = 'room',
  FURNITURE = 'furniture', 
  SHELF_DRAWER = 'shelf_drawer',
  CONTAINER = 'container'
}

export interface LocationHierarchy extends Location {
  children?: LocationHierarchy[];
  fullPath?: string;
}