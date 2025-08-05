import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { App } from '../src/app/app';
import { FloatingMenuComponent } from '../src/app/floating-menu/floating-menu';

describe('App Component', () => {
  let component: App;
  let fixture: ComponentFixture<App>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [
        RouterTestingModule,
        App, // Standalone component
        FloatingMenuComponent // Import floating menu component
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(App);
    component = fixture.componentInstance;
  });

  it('should create the app component', () => {
    expect(component).toBeTruthy();
  });

  it('should have the title "homes"', () => {
    expect(component.title).toBe('homes');
  });

  it('should render the header with logo', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const header = compiled.querySelector('header');
    expect(header).toBeTruthy();
    
    const logo = compiled.querySelector('img.brand-logo');
    expect(logo).toBeTruthy();
    expect(logo?.getAttribute('src')).toBe('/assets/logo.svg');
  });

  it('should have router outlet for navigation', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const routerOutlet = compiled.querySelector('router-outlet');
    expect(routerOutlet).toBeTruthy();
  });

  it('should include floating menu component', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const floatingMenu = compiled.querySelector('app-floating-menu');
    expect(floatingMenu).toBeTruthy();
  });
});
