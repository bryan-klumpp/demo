import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ActivatedRoute } from '@angular/router';
import { of } from 'rxjs';
import { Details } from '../src/app/details/details';
import { HousingService } from '../src/app/housingservice';
import { HousingLocationInfoInterface } from '../src/app/housinglocation';

describe('Details Component', () => {
  let component: Details;
  let fixture: ComponentFixture<Details>;
  let mockHousingService: jasmine.SpyObj<HousingService>;
  let mockActivatedRoute: any;

  const mockHousingLocation: HousingLocationInfoInterface = {
    id: 1,
    name: 'Test House',
    city: 'Test City',
    state: 'TS',
    photo: 'test.jpg',
    availableUnits: 5,
    wifi: true,
    laundry: true
  };

  beforeEach(async () => {
    // Create spy for HousingService
    const housingServiceSpy = jasmine.createSpyObj('HousingService', ['getHousingLocationById', 'submitApplication']);
    
    // Mock ActivatedRoute
    mockActivatedRoute = {
      params: of({ id: '1' })
    };

    await TestBed.configureTestingModule({
      imports: [Details], // Standalone component
      providers: [
        { provide: HousingService, useValue: housingServiceSpy },
        { provide: ActivatedRoute, useValue: mockActivatedRoute }
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(Details);
    component = fixture.componentInstance;
    mockHousingService = TestBed.inject(HousingService) as jasmine.SpyObj<HousingService>;
    
    // Setup service spy return values
    mockHousingService.getHousingLocationById.and.returnValue(Promise.resolve(mockHousingLocation));
    mockHousingService.submitApplication.and.returnValue();
  });

  it('should create the details component', () => {
    expect(component).toBeTruthy();
  });

  it('should initialize housingLocation as undefined', () => {
    expect(component.housingLocation).toBeUndefined();
  });

  it('should call HousingService.getHousingLocationById during construction', () => {
    // This is called in constructor, so we just verify the spy was called
    expect(mockHousingService.getHousingLocationById).toHaveBeenCalledWith(1);
  });

  it('should have submitApplication method', () => {
    expect(component.submitApplication).toBeTruthy();
    expect(typeof component.submitApplication).toBe('function');
  });

  it('should have applyForm with correct form controls', () => {
    expect(component.applyForm).toBeTruthy();
    expect(component.applyForm.get('firstName')).toBeTruthy();
    expect(component.applyForm.get('lastName')).toBeTruthy();
    expect(component.applyForm.get('email')).toBeTruthy();
  });

  it('should call HousingService.submitApplication when form is submitted', () => {
    // Set form values
    component.applyForm.patchValue({
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com'
    });
    
    component.submitApplication();
    expect(mockHousingService.submitApplication).toHaveBeenCalledWith('John', 'Doe', 'john.doe@example.com');
  });

  it('should render housing location details when available', async () => {
    component.housingLocation = mockHousingLocation;
    fixture.detectChanges();

    const compiled = fixture.nativeElement as HTMLElement;
    const image = compiled.querySelector('img.listing-photo');
    expect(image).toBeTruthy();
    expect(image?.getAttribute('src')).toBe('test.jpg');
  });

  it('should render apply section with form', () => {
    fixture.detectChanges();

    const compiled = fixture.nativeElement as HTMLElement;
    const applySection = compiled.querySelector('section.listing-apply');
    expect(applySection).toBeTruthy();

    const form = compiled.querySelector('form');
    expect(form).toBeTruthy();
    
    const submitButton = compiled.querySelector('button.primary');
    expect(submitButton).toBeTruthy();
    expect(submitButton?.textContent?.trim()).toBe('Submit Application');
  });
});
