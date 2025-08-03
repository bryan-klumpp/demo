import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';

/*ok, now let's change Leaf 2 into a demo page for Angular enums and enum-like complex types.
Maybe make some enum-like complex types for constants to categorize the different types of houses
like ranch, town house, mansion, etc., and those types could have attributes like
typicalNumberOccupants, typicalPrice, typicalFloors, etc.
You can show some stuff on the page but mainly this page will be used as a playground by me
to study and experiment with these concepts in TypeScript.

For the array of HouseCharacteristics, can you add an example of doing an array lookup
given a HouseType enum value and then storing that in a constant?
*/

// Basic string enum for house types
enum HouseType {
  RANCH = 'ranch',
  TOWNHOUSE = 'townhouse',
  MANSION = 'mansion',
  APARTMENT = 'apartment',
  CONDO = 'condo',
  COTTAGE = 'cottage'
}

// Numeric enum for price ranges
enum PriceRange {
  BUDGET = 1,
  MODERATE = 2,
  PREMIUM = 3,
  LUXURY = 4,
  ULTRA_LUXURY = 5
}

// Enum with computed values
enum FloorCount {
  SINGLE_STORY = 1,
  TWO_STORY = 2,
  THREE_STORY = 3,
  MULTI_STORY = FloorCount.THREE_STORY + 1, // Computed value
  HIGH_RISE = 10
}

// Complex type using enums
interface HouseCharacteristics {
  readonly type: HouseType;
  readonly priceRange: PriceRange;
  readonly typicalPrice: number;
  readonly typicalOccupants: number;
  readonly typicalFloors: FloorCount;
  readonly squareFootage: number;
  readonly hasGarage: boolean;
  readonly hasYard: boolean;
}

// Enum-like object (const assertion alternative)
const HouseFeatures = {
  FIREPLACE: 'fireplace',
  POOL: 'pool',
  GARAGE: 'garage',
  BASEMENT: 'basement',
  ATTIC: 'attic',
  BALCONY: 'balcony',
  GARDEN: 'garden'
} as const;

type HouseFeature = typeof HouseFeatures[keyof typeof HouseFeatures];

// Advanced: Discriminated union with enums
type HouseProperty = 
  | { type: HouseType.RANCH; acres: number; }
  | { type: HouseType.TOWNHOUSE; unitNumber: string; }
  | { type: HouseType.MANSION; estateName: string; }
  | { type: HouseType.APARTMENT; floor: number; unitNumber: string; }
  | { type: HouseType.CONDO; buildingName: string; }
  | { type: HouseType.COTTAGE; isWaterfront: boolean; };

@Component({
  selector: 'app-enum-demo',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <div class="demo-container">
      <header class="demo-header">
        <h1>TypeScript Enums & Complex Types Demo</h1>
        <p>A playground for exploring enums and enum-like patterns with house categorization</p>
        <a [routerLink]="['/']" class="back-link">← Back to Home</a>
      </header>

      <!-- Basic Enum Demo -->
      <section class="demo-section">
        <h2>1. Basic String Enum (HouseType)</h2>
        <div class="code-example">
          <h4>Enum Definition:</h4>
          <pre><code>enum HouseType &#123;
  RANCH = 'ranch',
  TOWNHOUSE = 'townhouse',
  MANSION = 'mansion',
  APARTMENT = 'apartment',
  CONDO = 'condo',
  COTTAGE = 'cottage'
&#125;</code></pre>
        </div>
        
        <div class="demo-grid">
          <div *ngFor="let type of houseTypeValues; let i = index" 
               class="enum-card"
               [class]="'card-' + (i % 3)">
            <h4>{{ getHouseTypeDisplayName(type) }}</h4>
            <p><strong>Enum Key:</strong> {{ getEnumKey(HouseType, type) }}</p>
            <p><strong>Enum Value:</strong> "{{ type }}"</p>
            <button (click)="selectHouseType(type)" class="select-btn">
              {{ selectedHouseType === type ? 'Selected ✓' : 'Select' }}
            </button>
          </div>
        </div>
        
        <div *ngIf="selectedHouseType" class="selection-display">
          <h4>Selected: {{ getHouseTypeDisplayName(selectedHouseType) }}</h4>
          <p>Type safety: {{ selectedHouseType }} (guaranteed to be a valid HouseType)</p>
        </div>
      </section>

      <!-- Numeric Enum Demo -->
      <section class="demo-section">
        <h2>2. Numeric Enum (PriceRange)</h2>
        <div class="code-example">
          <pre><code>enum PriceRange &#123;
  BUDGET = 1,      // $100k - $200k
  MODERATE = 2,    // $200k - $400k  
  PREMIUM = 3,     // $400k - $800k
  LUXURY = 4,      // $800k - $2M
  ULTRA_LUXURY = 5 // $2M+
&#125;</code></pre>
        </div>

        <div class="price-range-demo">
          <div *ngFor="let range of priceRangeValues" 
               class="price-card"
               [class.selected]="selectedPriceRange === range"
               (click)="selectPriceRange(range)">
            <h4>{{ getPriceRangeLabel(range) }}</h4>
            <p><strong>Numeric Value:</strong> {{ range }}</p>
            <p><strong>Price Range:</strong> {{ getPriceRangeDescription(range) }}</p>
          </div>
        </div>
      </section>

      <!-- Complex House Characteristics -->
      <section class="demo-section">
        <h2>3. Complex Types with Enums</h2>
        <div class="code-example">
          <h4>Interface using multiple enums:</h4>
          <pre><code>interface HouseCharacteristics &#123;
  readonly type: HouseType;
  readonly priceRange: PriceRange;
  readonly typicalPrice: number;
  readonly typicalOccupants: number;
  readonly typicalFloors: FloorCount;
  // ... more properties
&#125;</code></pre>
        </div>

        <div class="characteristics-grid">
          <div *ngFor="let house of houseCharacteristics" class="house-card">
            <h4>{{ getHouseTypeDisplayName(house.type) }}</h4>
            <div class="characteristics">
              <div class="char-row">
                <span class="label">Type:</span>
                <span class="value">{{ house.type }}</span>
              </div>
              <div class="char-row">
                <span class="label">Price Range:</span>
                <span class="value">{{ getPriceRangeLabel(house.priceRange) }} ({{ house.priceRange }})</span>
              </div>
              <div class="char-row">
                <span class="label">Typical Price:</span>
                <span class="value">{{ house.typicalPrice | currency }}</span>
              </div>
              <div class="char-row">
                <span class="label">Occupants:</span>
                <span class="value">{{ house.typicalOccupants }} people</span>
              </div>
              <div class="char-row">
                <span class="label">Floors:</span>
                <span class="value">{{ house.typicalFloors }} floor(s)</span>
              </div>
              <div class="char-row">
                <span class="label">Sq Ft:</span>
                <span class="value">{{ house.squareFootage | number }}</span>
              </div>
              <div class="char-row">
                <span class="label">Features:</span>
                <span class="value">
                  {{ house.hasGarage ? '🚗 Garage' : '' }}
                  {{ house.hasYard ? '🌿 Yard' : '' }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Enum-like Object Demo -->
      <section class="demo-section">
        <h2>4. Enum-like Object (const assertion)</h2>
        <div class="code-example">
          <pre><code>const HouseFeatures = &#123;
  FIREPLACE: 'fireplace',
  POOL: 'pool',
  GARAGE: 'garage',
  BASEMENT: 'basement',
  ATTIC: 'attic',
  BALCONY: 'balcony',
  GARDEN: 'garden'
&#125; as const;

type HouseFeature = typeof HouseFeatures[keyof typeof HouseFeatures];</code></pre>
        </div>

        <div class="features-demo">
          <h4>Available Features:</h4>
          <div class="features-grid">
            <div *ngFor="let feature of houseFeatureValues" 
                 class="feature-chip"
                 [class.selected]="selectedFeatures.includes(feature)"
                 (click)="toggleFeature(feature)">
              {{ getFeatureIcon(feature) }} {{ feature }}
            </div>
          </div>
          
          <div *ngIf="selectedFeatures.length > 0" class="selected-features">
            <h4>Selected Features:</h4>
            <p>{{ selectedFeatures.join(', ') }}</p>
          </div>
        </div>
      </section>

      <!-- Advanced Demo -->
      <section class="demo-section">
        <h2>5. Advanced: Discriminated Unions with Enums</h2>
        <div class="code-example">
          <pre><code>type HouseProperty = 
  | &#123; type: HouseType.RANCH; acres: number; &#125;
  | &#123; type: HouseType.TOWNHOUSE; unitNumber: string; &#125;
  | &#123; type: HouseType.MANSION; estateName: string; &#125;
  | &#123; type: HouseType.APARTMENT; floor: number; unitNumber: string; &#125;
  // ...</code></pre>
        </div>

        <div class="property-demo">
          <h4>Property Examples:</h4>
          <div *ngFor="let property of sampleProperties" class="property-card">
            <h4>{{ getHouseTypeDisplayName(property.type) }}</h4>
            <div class="property-details">
              <ng-container [ngSwitch]="property.type">
                <div *ngSwitchCase="HouseType.RANCH">
                  🏡 Ranch on {{ getRanchProperty(property).acres }} acres
                </div>
                <div *ngSwitchCase="HouseType.TOWNHOUSE">
                  🏘️ Townhouse Unit {{ getTownhouseProperty(property).unitNumber }}
                </div>
                <div *ngSwitchCase="HouseType.MANSION">
                  🏰 {{ getMansionProperty(property).estateName }} Estate
                </div>
                <div *ngSwitchCase="HouseType.APARTMENT">
                  🏢 Apartment {{ getApartmentProperty(property).unitNumber }} on Floor {{ getApartmentProperty(property).floor }}
                </div>
                <div *ngSwitchCase="HouseType.CONDO">
                  🏬 Condo in {{ getCondoProperty(property).buildingName }}
                </div>
                <div *ngSwitchCase="HouseType.COTTAGE">
                  🏚️ {{ getCottageProperty(property).isWaterfront ? 'Waterfront' : 'Inland' }} Cottage
                </div>
              </ng-container>
            </div>
          </div>
        </div>
      </section>

      <!-- Array Lookup Examples -->
      <section class="demo-section">
        <h2>6. Array Lookup with Enum Values</h2>
        <div class="code-example">
          <h4>Array lookup examples:</h4>
          <pre><code>// Find specific house type and store in constant
private readonly lookupHouseType = HouseType.MANSION;
readonly foundMansionCharacteristics: HouseCharacteristics | undefined = 
  this.houseCharacteristics.find(house => house.type === this.lookupHouseType);

// Multiple specific lookups
readonly ranchCharacteristics: HouseCharacteristics | undefined = 
  this.houseCharacteristics.find(house => house.type === HouseType.RANCH);

// Filter by enum value
readonly budgetHouses: HouseCharacteristics[] = 
  this.houseCharacteristics.filter(house => house.priceRange === PriceRange.BUDGET);

// Create lookup map
readonly houseCharacteristicsMap: Map&lt;HouseType, HouseCharacteristics&gt; = 
  new Map(this.houseCharacteristics.map(house => [house.type, house]));</code></pre>
        </div>

        <div class="lookup-demos">
          <!-- Specific Type Lookup -->
          <div class="lookup-example">
            <h4>Mansion Lookup Result:</h4>
            <div *ngIf="foundMansionCharacteristics" class="lookup-result">
              <p><strong>Type:</strong> {{ foundMansionCharacteristics.type }}</p>
              <p><strong>Price:</strong> {{ foundMansionCharacteristics.typicalPrice | currency }}</p>
              <p><strong>Square Footage:</strong> {{ foundMansionCharacteristics.squareFootage | number }}</p>
            </div>
            <div *ngIf="!foundMansionCharacteristics" class="no-result">
              No mansion found in characteristics array
            </div>
          </div>

          <!-- Budget Houses Filter -->
          <div class="lookup-example">
            <h4>Budget Houses ({{ budgetHouses.length }} found):</h4>
            <div class="budget-houses">
              <div *ngFor="let house of budgetHouses" class="mini-house-card">
                <strong>{{ getHouseTypeDisplayName(house.type) }}</strong><br>
                {{ house.typicalPrice | currency }}
              </div>
            </div>
          </div>

          <!-- Single Story Houses -->
          <div class="lookup-example">
            <h4>Single Story Houses ({{ singleStoryHouses.length }} found):</h4>
            <div class="single-story-houses">
              <div *ngFor="let house of singleStoryHouses" class="mini-house-card">
                <strong>{{ getHouseTypeDisplayName(house.type) }}</strong><br>
                {{ house.squareFootage | number }} sq ft
              </div>
            </div>
          </div>

          <!-- Interactive Lookup -->
          <div class="lookup-example">
            <h4>Interactive Lookup:</h4>
            <div class="interactive-lookup">
              <select #houseTypeSelect (change)="demonstrateLookup(houseTypeSelect.value)">
                <option value="">Select a house type...</option>
                <option *ngFor="let type of houseTypeValues" [value]="type">
                  {{ getHouseTypeDisplayName(type) }}
                </option>
              </select>
              
              <div *ngIf="selectedLookupResult" class="lookup-result">
                <h5>Found: {{ getHouseTypeDisplayName(selectedLookupResult.type) }}</h5>
                <p>Price Range: {{ getPriceRangeLabel(selectedLookupResult.priceRange) }}</p>
                <p>Typical Price: {{ selectedLookupResult.typicalPrice | currency }}</p>
                <p>Occupants: {{ selectedLookupResult.typicalOccupants }}</p>
              </div>
              
              <div *ngIf="lookupAttempted && !selectedLookupResult" class="no-result">
                No characteristics found for selected house type
              </div>
            </div>
          </div>

          <!-- Map Lookup Demo -->
          <div class="lookup-example">
            <h4>Map Lookup Demo:</h4>
            <div class="map-lookup">
              <p>Map contains {{ houseCharacteristicsMap.size }} entries</p>
              <div class="map-buttons">
                <button *ngFor="let type of houseTypeValues" 
                        (click)="demonstrateMapLookup(type)"
                        class="map-lookup-btn"
                        [class.found]="houseCharacteristicsMap.has(type)">
                  {{ getHouseTypeDisplayName(type) }}
                  {{ houseCharacteristicsMap.has(type) ? '✓' : '✗' }}
                </button>
              </div>
              
              <div *ngIf="mapLookupResult" class="map-result">
                <h5>Map Lookup Result:</h5>
                <p><strong>{{ getHouseTypeDisplayName(mapLookupResult.type) }}</strong></p>
                <p>{{ mapLookupResult.typicalPrice | currency }} - {{ mapLookupResult.squareFootage | number }} sq ft</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Utility Functions Demo -->
      <section class="demo-section">
        <h2>7. Enum Utility Functions</h2>
        <div class="utilities-demo">
          <div class="utility-example">
            <h4>Enum Keys:</h4>
            <code>{{ enumKeys }}</code>
          </div>
          <div class="utility-example">
            <h4>Enum Values:</h4>
            <code>{{ enumValues }}</code>
          </div>
          <div class="utility-example">
            <h4>Random House Type:</h4>
            <button (click)="generateRandomHouseType()" class="generate-btn">
              Generate Random: {{ randomHouseType || 'Click to generate' }}
            </button>
          </div>
        </div>
      </section>
    </div>
  `,
  styleUrls: ['./enum-demo.css']
})
export class EnumDemoComponent {
  // Expose enums to template
  HouseType = HouseType;
  PriceRange = PriceRange;
  FloorCount = FloorCount;
  HouseFeatures = HouseFeatures;

  // Component state
  selectedHouseType: HouseType | null = null;
  selectedPriceRange: PriceRange | null = null;
  selectedFeatures: HouseFeature[] = [];
  randomHouseType: HouseType | null = null;
  
  // New properties for lookup demonstrations
  selectedLookupResult: HouseCharacteristics | undefined;
  lookupAttempted: boolean = false;
  mapLookupResult: HouseCharacteristics | undefined;

  // Enum values for iteration
  houseTypeValues = Object.values(HouseType);
  priceRangeValues = Object.values(PriceRange).filter(v => typeof v === 'number') as PriceRange[];
  houseFeatureValues = Object.values(HouseFeatures);

  // Sample data
  houseCharacteristics: HouseCharacteristics[] = [
    {
      type: HouseType.RANCH,
      priceRange: PriceRange.MODERATE,
      typicalPrice: 350000,
      typicalOccupants: 4,
      typicalFloors: FloorCount.SINGLE_STORY,
      squareFootage: 1800,
      hasGarage: true,
      hasYard: true
    },
    {
      type: HouseType.TOWNHOUSE,
      priceRange: PriceRange.BUDGET,
      typicalPrice: 275000,
      typicalOccupants: 3,
      typicalFloors: FloorCount.TWO_STORY,
      squareFootage: 1200,
      hasGarage: false,
      hasYard: false
    },
    {
      type: HouseType.MANSION,
      priceRange: PriceRange.ULTRA_LUXURY,
      typicalPrice: 2500000,
      typicalOccupants: 6,
      typicalFloors: FloorCount.MULTI_STORY,
      squareFootage: 8000,
      hasGarage: true,
      hasYard: true
    },
    {
      type: HouseType.APARTMENT,
      priceRange: PriceRange.BUDGET,
      typicalPrice: 200000,
      typicalOccupants: 2,
      typicalFloors: FloorCount.SINGLE_STORY,
      squareFootage: 900,
      hasGarage: false,
      hasYard: false
    }
  ];

  // Array lookup examples using enum values
  // Example 1: Find a specific house type and store in a constant
  private readonly lookupHouseType = HouseType.MANSION;
  readonly foundMansionCharacteristics: HouseCharacteristics | undefined = 
    this.houseCharacteristics.find(house => house.type === this.lookupHouseType);

  // Example 2: Multiple lookups stored as constants
  readonly ranchCharacteristics: HouseCharacteristics | undefined = 
    this.houseCharacteristics.find(house => house.type === HouseType.RANCH);
  
  readonly townhouseCharacteristics: HouseCharacteristics | undefined = 
    this.houseCharacteristics.find(house => house.type === HouseType.TOWNHOUSE);

  // Example 3: Filter array by enum value and store result
  readonly budgetHouses: HouseCharacteristics[] = 
    this.houseCharacteristics.filter(house => house.priceRange === PriceRange.BUDGET);

  readonly singleStoryHouses: HouseCharacteristics[] = 
    this.houseCharacteristics.filter(house => house.typicalFloors === FloorCount.SINGLE_STORY);

  // Example 4: Create a lookup map using enum values as keys
  readonly houseCharacteristicsMap: Map<HouseType, HouseCharacteristics> = 
    new Map(this.houseCharacteristics.map(house => [house.type, house]));

  sampleProperties: HouseProperty[] = [
    { type: HouseType.RANCH, acres: 2.5 },
    { type: HouseType.TOWNHOUSE, unitNumber: 'B-12' },
    { type: HouseType.MANSION, estateName: 'Willowbrook' },
    { type: HouseType.APARTMENT, floor: 5, unitNumber: '5A' },
    { type: HouseType.CONDO, buildingName: 'Harbor View Tower' },
    { type: HouseType.COTTAGE, isWaterfront: true }
  ];

  // Utility properties
  get enumKeys(): string {
    return Object.keys(HouseType).join(', ');
  }

  get enumValues(): string {
    return Object.values(HouseType).join(', ');
  }

  // Methods
  selectHouseType(type: HouseType): void {
    this.selectedHouseType = type;
  }

  selectPriceRange(range: PriceRange): void {
    this.selectedPriceRange = range;
  }

  toggleFeature(feature: HouseFeature): void {
    const index = this.selectedFeatures.indexOf(feature);
    if (index > -1) {
      this.selectedFeatures.splice(index, 1);
    } else {
      this.selectedFeatures.push(feature);
    }
  }

  generateRandomHouseType(): void {
    const types = Object.values(HouseType);
    this.randomHouseType = types[Math.floor(Math.random() * types.length)];
  }

  getHouseTypeDisplayName(type: HouseType): string {
    return type.charAt(0).toUpperCase() + type.slice(1).replace(/([A-Z])/g, ' $1');
  }

  getPriceRangeLabel(range: PriceRange): string {
    const labels = {
      [PriceRange.BUDGET]: 'Budget',
      [PriceRange.MODERATE]: 'Moderate',
      [PriceRange.PREMIUM]: 'Premium',
      [PriceRange.LUXURY]: 'Luxury',
      [PriceRange.ULTRA_LUXURY]: 'Ultra Luxury'
    };
    return labels[range];
  }

  getPriceRangeDescription(range: PriceRange): string {
    const descriptions = {
      [PriceRange.BUDGET]: '$100k - $200k',
      [PriceRange.MODERATE]: '$200k - $400k',
      [PriceRange.PREMIUM]: '$400k - $800k',
      [PriceRange.LUXURY]: '$800k - $2M',
      [PriceRange.ULTRA_LUXURY]: '$2M+'
    };
    return descriptions[range];
  }

  getFeatureIcon(feature: HouseFeature): string {
    const icons: Record<HouseFeature, string> = {
      [HouseFeatures.FIREPLACE]: '🔥',
      [HouseFeatures.POOL]: '🏊',
      [HouseFeatures.GARAGE]: '🚗',
      [HouseFeatures.BASEMENT]: '🏠',
      [HouseFeatures.ATTIC]: '🏠',
      [HouseFeatures.BALCONY]: '🏢',
      [HouseFeatures.GARDEN]: '🌿'
    };
    return icons[feature];
  }

  getEnumKey<T extends Record<string, string>>(enumObj: T, value: string): string {
    return Object.keys(enumObj).find(key => enumObj[key] === value) || '';
  }

  // Example 5: Method that demonstrates runtime lookup
  getHouseCharacteristicsByType(houseType: HouseType): HouseCharacteristics | undefined {
    return this.houseCharacteristics.find(house => house.type === houseType);
  }

  // Example 6: Demonstrating lookup with default fallback
  getHouseCharacteristicsWithFallback(houseType: HouseType): HouseCharacteristics {
    const found = this.houseCharacteristics.find(house => house.type === houseType);
    
    // Fallback to a default if not found
    return found || {
      type: houseType,
      priceRange: PriceRange.MODERATE,
      typicalPrice: 300000,
      typicalOccupants: 3,
      typicalFloors: FloorCount.TWO_STORY,
      squareFootage: 1500,
      hasGarage: false,
      hasYard: false
    };
  }

  // New methods for lookup demonstrations
  demonstrateLookup(houseTypeValue: string): void {
    this.lookupAttempted = true;
    if (houseTypeValue) {
      const houseType = houseTypeValue as HouseType;
      this.selectedLookupResult = this.getHouseCharacteristicsByType(houseType);
    } else {
      this.selectedLookupResult = undefined;
      this.lookupAttempted = false;
    }
  }

  demonstrateMapLookup(houseType: HouseType): void {
    this.mapLookupResult = this.houseCharacteristicsMap.get(houseType);
  }

  // Type-safe property accessors for discriminated unions
  getRanchProperty(property: HouseProperty): { type: HouseType.RANCH; acres: number } {
    return property as { type: HouseType.RANCH; acres: number };
  }

  getTownhouseProperty(property: HouseProperty): { type: HouseType.TOWNHOUSE; unitNumber: string } {
    return property as { type: HouseType.TOWNHOUSE; unitNumber: string };
  }

  getMansionProperty(property: HouseProperty): { type: HouseType.MANSION; estateName: string } {
    return property as { type: HouseType.MANSION; estateName: string };
  }

  getApartmentProperty(property: HouseProperty): { type: HouseType.APARTMENT; floor: number; unitNumber: string } {
    return property as { type: HouseType.APARTMENT; floor: number; unitNumber: string };
  }

  getCondoProperty(property: HouseProperty): { type: HouseType.CONDO; buildingName: string } {
    return property as { type: HouseType.CONDO; buildingName: string };
  }

  getCottageProperty(property: HouseProperty): { type: HouseType.COTTAGE; isWaterfront: boolean } {
    return property as { type: HouseType.COTTAGE; isWaterfront: boolean };
  }
}
