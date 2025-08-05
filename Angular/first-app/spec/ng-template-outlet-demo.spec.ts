import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { NgTemplateOutletDemoComponent } from '../src/app/ng-template-outlet-demo/ng-template-outlet-demo';

describe('NgTemplateOutletDemoComponent', () => {
  let component: NgTemplateOutletDemoComponent;
  let fixture: ComponentFixture<NgTemplateOutletDemoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [
        RouterTestingModule,
        NgTemplateOutletDemoComponent // Standalone component
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(NgTemplateOutletDemoComponent);
    component = fixture.componentInstance;
  });

  it('should create the ng-template-outlet demo component', () => {
    expect(component).toBeTruthy();
  });

  it('should initialize with buttonDataList', () => {
    expect(component.buttonDataList).toBeTruthy();
    expect(component.buttonDataList.length).toBeGreaterThan(0);
    expect(component.buttonDataList[0].id).toBeDefined();
    expect(component.buttonDataList[0].label).toBeDefined();
    expect(component.buttonDataList[0].color).toBeDefined();
    expect(component.buttonDataList[0].icon).toBeDefined();
  });

  it('should initialize with cardDataList', () => {
    expect(component.cardDataList).toBeTruthy();
    expect(component.cardDataList.length).toBeGreaterThan(0);
    expect(component.cardDataList[0].type).toBeDefined();
    expect(component.cardDataList[0].title).toBeDefined();
    expect(component.cardDataList[0].description).toBeDefined();
  });

  it('should initialize with no clicked button', () => {
    expect(component.lastClickedButton).toBeNull();
    expect(component.lastClickedIndex).toBe(-1);
  });

  it('should handle button click correctly', () => {
    const testButton = component.buttonDataList[0];
    const testIndex = 0;
    
    component.onButtonClick(testButton, testIndex);
    
    expect(component.lastClickedButton).toBe(testButton);
    expect(component.lastClickedIndex).toBe(testIndex);
  });

  it('should render the demo header', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const header = compiled.querySelector('.demo-header h1');
    expect(header).toBeTruthy();
    expect(header?.textContent).toContain('ngTemplateOutlet Demo');
  });

  it('should render back link to home', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const backLink = compiled.querySelector('.back-link');
    expect(backLink).toBeTruthy();
    expect(backLink?.textContent?.trim()).toBe('← Back to Home');
  });

  it('should render button template section', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const buttonSection = compiled.querySelector('.demo-section');
    expect(buttonSection).toBeTruthy();
    
    const sectionTitle = buttonSection?.querySelector('h2');
    expect(sectionTitle?.textContent).toContain('Button Template');
  });

  it('should render demo buttons using ng-template', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const buttons = compiled.querySelectorAll('.demo-button');
    expect(buttons.length).toBe(component.buttonDataList.length);
  });

  it('should render card template section', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const cardSection = compiled.querySelectorAll('.demo-section')[1]; // Second section
    expect(cardSection).toBeTruthy();
    
    const sectionTitle = cardSection?.querySelector('h2');
    expect(sectionTitle?.textContent).toContain('Card Template');
  });

  it('should render cards using ng-template', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const cards = compiled.querySelectorAll('.demo-card');
    expect(cards.length).toBe(component.cardDataList.length);
  });

  it('should render results area', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const resultsArea = compiled.querySelector('.results-area');
    expect(resultsArea).toBeTruthy();
  });

  it('should show no clicks message initially', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const noClicksMessage = compiled.querySelector('.no-clicks');
    expect(noClicksMessage).toBeTruthy();
    expect(noClicksMessage?.textContent).toContain('Click any button');
  });

  it('should show click results after button click', () => {
    const testButton = component.buttonDataList[0];
    component.onButtonClick(testButton, 0);
    fixture.detectChanges();
    
    const compiled = fixture.nativeElement as HTMLElement;
    const clickResult = compiled.querySelector('.click-result');
    expect(clickResult).toBeTruthy();
    
    const noClicksMessage = compiled.querySelector('.no-clicks');
    expect(noClicksMessage).toBeFalsy();
  });

  it('should log button click to console', () => {
    spyOn(console, 'log');
    const testButton = component.buttonDataList[0];
    const testIndex = 0;
    
    component.onButtonClick(testButton, testIndex);
    
    expect(console.log).toHaveBeenCalledWith('Button clicked:', testButton, 'at index:', testIndex);
  });
});
