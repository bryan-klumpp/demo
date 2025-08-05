import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { EnumDemoComponent } from '../src/app/enum-demo/enum-demo';

describe('EnumDemoComponent', () => {
  let component: EnumDemoComponent;
  let fixture: ComponentFixture<EnumDemoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [
        RouterTestingModule,
        EnumDemoComponent // Standalone component
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(EnumDemoComponent);
    component = fixture.componentInstance;
  });

  it('should create the enum demo component', () => {
    expect(component).toBeTruthy();
  });

  it('should initialize with correct enum values', () => {
    expect(component.HouseType).toBeTruthy();
    expect(component.PriceRange).toBeTruthy();
    expect(component.FloorCount).toBeTruthy();
    expect(component.HouseFeatures).toBeTruthy();
  });

  it('should initialize component state correctly', () => {
    expect(component.selectedHouseType).toBeNull();
    expect(component.selectedPriceRange).toBeNull();
    expect(component.selectedFeatures).toEqual([]);
    expect(component.randomHouseType).toBeNull();
    expect(component.selectedLookupResult).toBeUndefined();
    expect(component.lookupAttempted).toBe(false);
    expect(component.constantUpdateDemo).toBe(false);
    expect(component.customHouseArray).toEqual([]);
  });

  it('should have correct house type values', () => {
    expect(component.houseTypeValues).toBeTruthy();
    expect(component.houseTypeValues.length).toBeGreaterThan(0);
    expect(component.houseTypeValues).toContain(component.HouseType.RANCH);
    expect(component.houseTypeValues).toContain(component.HouseType.APARTMENT);
  });

  it('should have house characteristics constants defined', () => {
    expect(component.RANCH_HOUSE).toBeTruthy();
    expect(component.RANCH_HOUSE.type).toBe(component.HouseType.RANCH);
    expect(component.RANCH_HOUSE.typicalPrice).toBe(350000);
    
    expect(component.TOWNHOUSE_HOUSE).toBeTruthy();
    expect(component.TOWNHOUSE_HOUSE.type).toBe(component.HouseType.TOWNHOUSE);
    
    expect(component.MANSION_HOUSE).toBeTruthy();
    expect(component.MANSION_HOUSE.type).toBe(component.HouseType.MANSION);
  });

  it('should initialize houseCharacteristics array with constants', () => {
    expect(component.houseCharacteristics).toBeTruthy();
    expect(component.houseCharacteristics.length).toBe(4);
    expect(component.houseCharacteristics).toContain(component.RANCH_HOUSE);
    expect(component.houseCharacteristics).toContain(component.TOWNHOUSE_HOUSE);
  });

  it('should initialize allHouseCharacteristics with all constants', () => {
    expect(component.allHouseCharacteristics).toBeTruthy();
    expect(component.allHouseCharacteristics.length).toBe(6);
    expect(component.allHouseCharacteristics).toContain(component.RANCH_HOUSE);
    expect(component.allHouseCharacteristics).toContain(component.CONDO_HOUSE);
    expect(component.allHouseCharacteristics).toContain(component.COTTAGE_HOUSE);
  });

  it('should have correct lookup results initialized', () => {
    expect(component.foundMansionCharacteristics).toBeTruthy();
    expect(component.foundMansionCharacteristics?.type).toBe(component.HouseType.MANSION);
    
    expect(component.ranchCharacteristics).toBeTruthy();
    expect(component.ranchCharacteristics?.type).toBe(component.HouseType.RANCH);
  });

  it('should handle house type selection', () => {
    component.selectHouseType(component.HouseType.RANCH);
    expect(component.selectedHouseType).toBe(component.HouseType.RANCH);
    
    component.selectHouseType(component.HouseType.APARTMENT);
    expect(component.selectedHouseType).toBe(component.HouseType.APARTMENT);
  });

  it('should handle price range selection', () => {
    component.selectPriceRange(1); // BUDGET
    expect(component.selectedPriceRange).toBe(1);
    
    component.selectPriceRange(5); // ULTRA_LUXURY
    expect(component.selectedPriceRange).toBe(5);
  });

  it('should generate random house type', () => {
    component.generateRandomHouseType();
    expect(component.randomHouseType).toBeTruthy();
    expect(component.houseTypeValues).toContain(component.randomHouseType!);
  });

  it('should get correct house type display name', () => {
    expect(component.getHouseTypeDisplayName(component.HouseType.RANCH)).toBe('Ranch');
    expect(component.getHouseTypeDisplayName(component.HouseType.TOWNHOUSE)).toBe('Townhouse');
    expect(component.getHouseTypeDisplayName(component.HouseType.MANSION)).toBe('Mansion');
  });

  it('should get correct price range labels', () => {
    expect(component.getPriceRangeLabel(1)).toBe('Budget');
    expect(component.getPriceRangeLabel(2)).toBe('Moderate');
    expect(component.getPriceRangeLabel(5)).toBe('Ultra Luxury');
  });

  it('should get correct price range descriptions', () => {
    expect(component.getPriceRangeDescription(1)).toBe('$100k - $200k');
    expect(component.getPriceRangeDescription(5)).toBe('$2M+');
  });

  it('should demonstrate lookup functionality', () => {
    component.demonstrateLookup(component.HouseType.RANCH);
    expect(component.lookupAttempted).toBe(true);
    expect(component.selectedLookupResult).toBeTruthy();
    expect(component.selectedLookupResult?.type).toBe(component.HouseType.RANCH);
    
    component.demonstrateLookup('');
    expect(component.selectedLookupResult).toBeUndefined();
    expect(component.lookupAttempted).toBe(false);
  });

  it('should demonstrate map lookup functionality', () => {
    component.demonstrateMapLookup(component.HouseType.RANCH);
    expect(component.mapLookupResult).toBeTruthy();
    expect(component.mapLookupResult?.type).toBe(component.HouseType.RANCH);
  });

  it('should get house characteristics by type', () => {
      const result = component.getHouseCharacteristicsByType(component.HouseType.RANCH);
      expect(result).toBeTruthy();
      expect(result?.type).toBe(component.HouseType.RANCH);
      
      const notFound = component.getHouseCharacteristicsByType('cottage' as any);
      expect(notFound).toBeUndefined();
  });

  it('should get house characteristics with fallback', () => {
    const existing = component.getHouseCharacteristicsWithFallback(component.HouseType.RANCH);
    expect(existing.type).toBe('ranch');
    
    const fallback = component.getHouseCharacteristicsWithFallback(component.HouseType.COTTAGE);
    expect(fallback).toBeTruthy();
    expect(fallback.type).toBe('cottage');
    expect(fallback.typicalPrice).toBe(300000); // fallback price
  });

  it('should get budget houses from constants', () => {
    const budgetHouses = component.getBudgetHousesFromConstants();
    expect(budgetHouses.length).toBeGreaterThan(0);
    budgetHouses.forEach(house => {
      expect(house.priceRange).toBe(1); // BUDGET = 1
    });
  });

  it('should handle constant update demo toggle', () => {
    expect(component.constantUpdateDemo).toBe(false);
    component.demonstrateConstantUpdate();
    expect(component.constantUpdateDemo).toBe(true);
    component.demonstrateConstantUpdate();
    expect(component.constantUpdateDemo).toBe(false);
  });

  it('should manage custom house array', () => {
    expect(component.customHouseArray.length).toBe(0);
    
    component.addToCustomArray(component.RANCH_HOUSE);
    expect(component.customHouseArray.length).toBe(1);
    expect(component.isInCustomArray(component.RANCH_HOUSE)).toBe(true);
    
    // Should not add duplicate
    component.addToCustomArray(component.RANCH_HOUSE);
    expect(component.customHouseArray.length).toBe(1);
    
    component.addToCustomArray(component.MANSION_HOUSE);
    expect(component.customHouseArray.length).toBe(2);
    
    component.clearCustomArray();
    expect(component.customHouseArray.length).toBe(0);
  });

  it('should render the demo header', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const header = compiled.querySelector('.demo-header h1');
    expect(header).toBeTruthy();
    expect(header?.textContent).toContain('TypeScript Enums');
  });

  it('should render back link to home', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const backLink = compiled.querySelector('.back-link');
    expect(backLink).toBeTruthy();
    expect(backLink?.textContent?.trim()).toBe('← Back to Home');
  });

  it('should render all demo sections', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const sections = compiled.querySelectorAll('.demo-section');
    expect(sections.length).toBeGreaterThan(5);
  });

  it('should render house type cards', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const enumCards = compiled.querySelectorAll('.enum-card');
    expect(enumCards.length).toBe(component.houseTypeValues.length);
  });

  it('should handle property type accessors correctly', () => {
    const ranchProperty = { type: 'ranch' as any, acres: 5 };
    const townhouseProperty = { type: 'townhouse' as any, unitNumber: 'A1' };
    
    const ranchResult = component.getRanchProperty(ranchProperty as any);
    expect(ranchResult.acres).toBe(5);
    
    const townhouseResult = component.getTownhouseProperty(townhouseProperty as any);
    expect(townhouseResult.unitNumber).toBe('A1');
  });
});
