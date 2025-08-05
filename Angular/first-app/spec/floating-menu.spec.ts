import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { FloatingMenuComponent } from '../src/app/floating-menu/floating-menu';

describe('FloatingMenuComponent', () => {
  let component: FloatingMenuComponent;
  let fixture: ComponentFixture<FloatingMenuComponent>;
  let mockRouter: jasmine.SpyObj<Router>;

  beforeEach(async () => {
    const routerSpy = jasmine.createSpyObj('Router', ['navigate']);

    await TestBed.configureTestingModule({
      imports: [FloatingMenuComponent], // Standalone component
      providers: [
        { provide: Router, useValue: routerSpy }
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(FloatingMenuComponent);
    component = fixture.componentInstance;
    mockRouter = TestBed.inject(Router) as jasmine.SpyObj<Router>;
  });

  it('should create the floating menu component', () => {
    expect(component).toBeTruthy();
  });

  it('should initialize with menu hidden', () => {
    expect(component.menuState.visible).toBeFalse();
    expect(component.menuState.level).toBe(0);
  });

  it('should initialize with dialog hidden', () => {
    expect(component.dialogVisible).toBeFalse();
    expect(component.dialogMessage).toBe('');
  });

  it('should have top level menu items defined', () => {
    expect(component.menuState.items).toBeTruthy();
    expect(component.menuState.items.length).toBeGreaterThan(0);
  });

  it('should toggle menu visibility when toggleMenu is called', () => {
    expect(component.menuState.visible).toBeFalse();
    
    component.toggleMenu();
    expect(component.menuState.visible).toBeTrue();
    
    component.toggleMenu();
    expect(component.menuState.visible).toBeFalse();
  });

  it('should open menu with correct initial state', () => {
    component.openMenu();
    expect(component.menuState.visible).toBeTrue();
    expect(component.menuState.level).toBe(0);
  });

  it('should close menu and reset state', () => {
    component.menuState.visible = true;
    component.menuState.level = 1;
    
    component.closeMenu();
    expect(component.menuState.visible).toBeFalse();
    expect(component.menuState.level).toBe(0);
  });

  it('should navigate to ngTemplateOutlet demo when called', () => {
    component.navigateToNgTemplateOutletDemo();
    expect(mockRouter.navigate).toHaveBeenCalledWith(['/ng-template-outlet-demo']);
    expect(component.menuState.visible).toBeFalse();
  });

  it('should navigate to enum demo when called', () => {
    component.navigateToEnumDemo();
    expect(mockRouter.navigate).toHaveBeenCalledWith(['/enum-demo']);
    expect(component.menuState.visible).toBeFalse();
  });

  it('should show dialog with correct message', () => {
    const testMessage = 'Test Dialog Message';
    component.showDialog(testMessage);
    
    expect(component.dialogVisible).toBeTrue();
    expect(component.dialogMessage).toBe(testMessage);
    expect(component.menuState.visible).toBeFalse();
  });

  it('should close dialog and clear message', () => {
    component.dialogVisible = true;
    component.dialogMessage = 'Test Message';
    
    component.closeDialog();
    expect(component.dialogVisible).toBeFalse();
    expect(component.dialogMessage).toBe('');
  });

  it('should render floating menu button', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const menuButton = compiled.querySelector('.floating-menu-btn');
    expect(menuButton).toBeTruthy();
  });

  it('should render menu icon', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    const menuIcon = compiled.querySelector('.menu-icon');
    expect(menuIcon).toBeTruthy();
    expect(menuIcon?.textContent?.trim()).toBe('☰');
  });

  it('should show menu content when menu is visible', () => {
    component.menuState.visible = true;
    fixture.detectChanges();
    
    const compiled = fixture.nativeElement as HTMLElement;
    const menuContent = compiled.querySelector('.menu-content');
    const menuOverlay = compiled.querySelector('.menu-overlay');
    
    expect(menuContent).toBeTruthy();
    expect(menuOverlay).toBeTruthy();
  });

  it('should hide menu content when menu is not visible', () => {
    component.menuState.visible = false;
    fixture.detectChanges();
    
    const compiled = fixture.nativeElement as HTMLElement;
    const menuContent = compiled.querySelector('.menu-content');
    const menuOverlay = compiled.querySelector('.menu-overlay');
    
    expect(menuContent).toBeFalsy();
    expect(menuOverlay).toBeFalsy();
  });

  it('should show dialog when dialog is visible', () => {
    component.dialogVisible = true;
    component.dialogMessage = 'Test Dialog';
    fixture.detectChanges();
    
    const compiled = fixture.nativeElement as HTMLElement;
    const dialogOverlay = compiled.querySelector('.dialog-overlay');
    const dialogContent = compiled.querySelector('.dialog-content');
    
    expect(dialogOverlay).toBeTruthy();
    expect(dialogContent).toBeTruthy();
  });
});
