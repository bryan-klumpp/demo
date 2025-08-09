import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { EnumDemoComponent } from '../src/app/enum-demo/enum-demo';
import { unlink } from 'fs';

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


  // Generic utility function for compile-time validation that all enum string values are in a string literal union
  function staticAssertEnumSubset<
    E extends Record<string, string>,
    U extends string
  >(): (`${E[keyof E]}` extends U ? true : never) {
    return true as any;
  }

//   function isMyType1(obj: any): obj is MyType1 {
//   return typeof obj.property1 === 'string';
// }

// function isMyType2(obj: any): obj is MyType2 {
//   return typeof obj.property2 === 'number';
// }

// function isMyCombinedType(obj: any): obj is MyType1 & MyType2 {
//   return isMyType1(obj) && isMyType2(obj);
// }
  //no worky but interesting to study why
  function staticAssertStringLiteralUnionAllOfAareOptionsInB<A extends Record<string,string>, B extends string>(Ap: A extends string & B ? true : never, Bp: B extends string & A ? true : never) : A extends B ? true : never {
    // const staticassertX : A = Bp;
    return true as any;
  }

  type stringLiteralUnion = 'ranch' | 'townhouse' | 'mansion' | 'cottage' | 'condo' | 'apartment';
  

  enum HouseType2 {
    RANCH = 'ranch',
    TOWNHOUSE = 'townhouse',
    MANSION = 'mansion',
    COTTAGE = 'cottage',
    CONDO = 'condo',
    APARTMENT = 'apartment'
  };
enum HouseTypeLimited {
    RANCH = 'ranch',
    TOWNHOUSE = 'townhouse',
  };
function assertTrue<T extends true>(): void{
  const staticcheck: T = true as T;
}
function assertTypeTrue<T extends true>() {
  const staticcheck: T = true as T;
}


function assert2<T>(val: T): asserts val is (T extends stringLiteralUnion ? T : never) { //https://www.google.com/search?q=how+to+assert+TypeScript+conditional+type+expression&oq=how+to+assert+TypeScript+conditional+type+expression&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBCDM4MTVqMGo5qAIAsAIB&sourceid=chrome&ie=UTF-8
  if (typeof val !== 'string' && typeof val !== 'number') {
    throw new Error("Value is not a string or a number.");
  }
}
function staticTypeAssert<T = true>(): void { /* noop */ }
const newstringliteraluniontype = `${HouseTypeLimited}`;
assert2<typeof newstringliteraluniontype>('ranch'); // This is just to use the assert function and not throw an error

/* I could not find a way to do some static asserts without creating a const.
This is a workaround so that no problems are flagged when doing the static assert.
eslint configuration can be updated, but I had difficulty getting VSCode to completely
ignore it, such as when you hover the cursor over it.  This function will reject anything
other than true, so cannot be used to throw away most variables that might actually
suggest a bug. */
function unLintOnlyTrue(result : true): void {
}
  type AssertAllEnumValuesInUnion2 = `${HouseTypeLimited}` extends stringLiteralUnion ? true : never;
// This line will cause a compile-time error if the condition is not met:

const linterThrowAwayStaticTypeChecks : true = true;

//staticTypeAssert<typeof HouseTypeLimited)[keyof typeof HouseTypeLimited] extends stringLiteralUnion ? true : never>();
assertTrue<AssertAllEnumValuesInUnion2>(); // \(\s*`\s*\$\s*\{
 const staticcheckLimited3: ((typeof HouseTypeLimited)[keyof typeof HouseTypeLimited] extends stringLiteralUnion ? true : never) = true; // alternate way to get string literal union from enum
const staticcheckLimited: (`${HouseTypeLimited}` extends stringLiteralUnion ? true : never) = true; // assertion not working directly this way?
 unLintOnlyTrue(staticcheckLimited);
 const _staticcheckLimited2: ((typeof HouseTypeLimited)[keyof typeof HouseTypeLimited] extends stringLiteralUnion ? true : never) = true; // alternate way to get string literal union from enum
 assertTypeTrue<((typeof HouseTypeLimited)[keyof typeof HouseTypeLimited] extends stringLiteralUnion ? true : never)>();
 

 //unLintStaticAssert('asdf'); //should fail
 
 true as (`${HouseTypeLimited}` extends stringLiteralUnion ? true : never);
  //staticAssertStringLiteralUnionAllOfAareOptionsInB<typeof HouseTypeLimited, stringLiteralUnion>(HouseTypeLimited, `${stringLiteralUnion}`); //no worky
  type HouseTypeEnumValues = `${HouseType2}`; // This gives you a union of all enum string values
  type AssertAllEnumValuesInUnion = HouseTypeEnumValues extends stringLiteralUnion ? true : never;
  type AssertAllOriginalUnionValuesInEnum = stringLiteralUnion extends HouseTypeEnumValues ? true : never;
  const staticcheck: AssertAllEnumValuesInUnion = true;
  const staticcheckOriginal: AssertAllOriginalUnionValuesInEnum = true;
 
  // Using the generic utility function as well
  const utilityFunctionCheck = staticAssertEnumSubset<typeof HouseType2, stringLiteralUnion>() as true;
  const utilityFunctionCheckLimited = staticAssertEnumSubset<typeof HouseTypeLimited, stringLiteralUnion>() as true;

  



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
