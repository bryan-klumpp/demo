import { provideZonelessChangeDetection, PLATFORM_ID } from '@angular/core';
import { TestBed, ComponentFixture } from '@angular/core/testing';
import { DomSanitizer } from '@angular/platform-browser';
import { App } from './app';
import { AudioPlayerService } from './audio-player.service';

describe('App', () => {
  let component: App;
  let fixture: ComponentFixture<App>;
  let sanitizer: DomSanitizer;
  let mockAudioPlayer: jasmine.SpyObj<AudioPlayerService>;

  beforeEach(async () => {
    mockAudioPlayer = jasmine.createSpyObj('AudioPlayerService', ['play']);
    mockAudioPlayer.play.and.callFake((url: string, onStart?: () => void, onEnd?: () => void) => {
      if (onStart) {
        onStart();
        setTimeout(() => {
          if (onEnd) onEnd();
        }, 200);
      }
    });

    await TestBed.configureTestingModule({
      imports: [App],
      providers: [
        provideZonelessChangeDetection(),
        { provide: PLATFORM_ID, useValue: 'browser' },
        { provide: AudioPlayerService, useValue: mockAudioPlayer },
      ]
    }).compileComponents();

    // Use the real DomSanitizer but spy on the bypass method
    sanitizer = TestBed.inject(DomSanitizer);
    spyOn(sanitizer, 'bypassSecurityTrustResourceUrl').and.callThrough();

    fixture = TestBed.createComponent(App);
    component = fixture.componentInstance;
  });

  fit('should play audio when playAudio is called', async () => {
    // fixture.detectChanges(); // Initialize component template
    
    component.playAudio();
    expect(mockAudioPlayer.play).toHaveBeenCalled();
    expect(component.playerStatus()).toBe('Playing...');
    console.log('Audio started playing at ' + new Date().toLocaleTimeString());
    //     setTimeout(() => {
    //   expect(component.playerStatus()).toBe('Player');
    //   done();
    //   console.log('Audio ended at ' + new Date().toLocaleTimeString());
    //   console.log('audio test passed?');
    // });

    await new Promise(resolve => setTimeout(resolve, 300)); // Wait slightly longer than mock delay
    
    expect(component.playerStatus()).toBe('Player');
    console.log('Audio ended at ' + new Date().toLocaleTimeString());
    console.log('audio test passed?');
  });

  it('should create the app', () => {
    expect(component).toBeTruthy();
  });

  it('should initialize with correct default values', () => {
    expect(component.leftRailWidth).toBe('15%');
    expect(component.leftRailWidthCss).toBe('15%');
    // Note: title is protected, so we test it through the template
  });

  it('should create sanitized iframe URLs with cache-busting', () => {
    fixture.detectChanges();
    
  expect(sanitizer.bypassSecurityTrustResourceUrl).toHaveBeenCalledTimes(2);
  expect(sanitizer.bypassSecurityTrustResourceUrl).toHaveBeenCalledWith(
      jasmine.stringMatching(/^\/left-rail\.html\?v=\d+$/)
    );
  expect(sanitizer.bypassSecurityTrustResourceUrl).toHaveBeenCalledWith(
      jasmine.stringMatching(/^\/main-iframe\.html\?v=\d+$/)
    );
  });

  it('should render iframe grid layout', () => {
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;
    
    const appGrid = compiled.querySelector('.app-grid');
    expect(appGrid).toBeTruthy();
    
    const iframes = compiled.querySelectorAll('iframe');
    expect(iframes.length).toBe(2);
    
    const leftIframe = compiled.querySelector('.left-rail') as HTMLIFrameElement;
    const mainIframe = compiled.querySelector('.main-frame') as HTMLIFrameElement;
    expect(leftIframe).toBeTruthy();
    expect(mainIframe).toBeTruthy();
    
    // Check that src attributes are set (they should contain the URLs returned by sanitizer)
    expect(leftIframe.src).toContain('left-rail.html');
    expect(mainIframe.src).toContain('main-iframe.html');
  });

  describe('PostMessage Communication', () => {
    let mockLeftWindow: any;
    let mockMainWindow: any;

    beforeEach(() => {
      fixture.detectChanges(); // This triggers component initialization
      
      // Mock iframe content windows
      mockLeftWindow = { postMessage: jasmine.createSpy('leftPostMessage') };
      mockMainWindow = { postMessage: jasmine.createSpy('mainPostMessage') };

      // Mock ViewChild iframes after component is initialized
      component.leftIframe = {
        nativeElement: { contentWindow: mockLeftWindow }
      } as any;
      component.mainIframe = {
        nativeElement: { contentWindow: mockMainWindow }
      } as any;
    });

    it('should relay message from left iframe to main iframe', () => {
      const testMessage = {
        type: 'sync-text',
        value: 'test message from left',
        source: 'left'
      };

      // Simulate message event
      const messageEvent = new MessageEvent('message', { data: testMessage });
      component['onMessage'](messageEvent);

      expect(mockMainWindow.postMessage).toHaveBeenCalledWith(testMessage, '*');
      expect(mockLeftWindow.postMessage).not.toHaveBeenCalled();
    });

    it('should relay message from main iframe to left iframe', () => {
      const testMessage = {
        type: 'sync-text',
        value: 'test message from main',
        source: 'main'
      };

      const messageEvent = new MessageEvent('message', { data: testMessage });
      component['onMessage'](messageEvent);

      expect(mockLeftWindow.postMessage).toHaveBeenCalledWith(testMessage, '*');
      expect(mockMainWindow.postMessage).not.toHaveBeenCalled();
    });

    it('should relay message from external source to both iframes', () => {
      const testMessage = {
        type: 'sync-text',
        value: 'test message from external',
        source: 'external'
      };

      const messageEvent = new MessageEvent('message', { data: testMessage });
      component['onMessage'](messageEvent);

      expect(mockLeftWindow.postMessage).toHaveBeenCalledWith(testMessage, '*');
      expect(mockMainWindow.postMessage).toHaveBeenCalledWith(testMessage, '*');
    });

    it('should ignore non sync-text messages', () => {
      const testMessage = {
        type: 'other-message',
        value: 'should be ignored'
      };

      const messageEvent = new MessageEvent('message', { data: testMessage });
      component['onMessage'](messageEvent);

      expect(mockLeftWindow.postMessage).not.toHaveBeenCalled();
      expect(mockMainWindow.postMessage).not.toHaveBeenCalled();
    });

    it('should handle missing iframe windows gracefully', () => {
      component.leftIframe = { nativeElement: { contentWindow: null } } as any;
      component.mainIframe = { nativeElement: { contentWindow: null } } as any;

      const testMessage = {
        type: 'sync-text',
        value: 'test message',
        source: 'left'
      };

      const messageEvent = new MessageEvent('message', { data: testMessage });
      
      expect(() => component['onMessage'](messageEvent)).not.toThrow();
    });
  });

  describe('Lifecycle Hooks', () => {
    it('should add message listener on ngAfterViewInit in browser', () => {
      const addEventListenerSpy = spyOn(window, 'addEventListener');
      
      component.ngAfterViewInit();
      
      expect(addEventListenerSpy).toHaveBeenCalledWith('message', component['onMessage']);
    });

    it('should remove message listener on ngOnDestroy in browser', () => {
      const removeEventListenerSpy = spyOn(window, 'removeEventListener');
      
      component.ngOnDestroy();
      
      expect(removeEventListenerSpy).toHaveBeenCalledWith('message', component['onMessage']);
    });
  });

  describe('SSR Compatibility', () => {
    beforeEach(async () => {
      // Reconfigure TestBed with server platform
      await TestBed.resetTestingModule();
      await TestBed.configureTestingModule({
        imports: [App],
        providers: [
          provideZonelessChangeDetection(),
          { provide: PLATFORM_ID, useValue: 'server' }
        ]
      }).compileComponents();

  // Spy on the real sanitizer in the SSR context as well
  sanitizer = TestBed.inject(DomSanitizer);
  spyOn(sanitizer, 'bypassSecurityTrustResourceUrl').and.callThrough();

      fixture = TestBed.createComponent(App);
      component = fixture.componentInstance;
    });

    it('should not add event listeners on server platform', () => {
      const addEventListenerSpy = spyOn(window, 'addEventListener');
      const removeEventListenerSpy = spyOn(window, 'removeEventListener');
      
      component.ngAfterViewInit();
      component.ngOnDestroy();
      
      expect(addEventListenerSpy).not.toHaveBeenCalled();
      expect(removeEventListenerSpy).not.toHaveBeenCalled();
    });

    it('should still create iframe URLs on server', () => {
      fixture.detectChanges();
      
      expect(component.leftRailSrc).toBeTruthy();
      expect(component.mainIframeSrc).toBeTruthy();
  expect(sanitizer.bypassSecurityTrustResourceUrl).toHaveBeenCalledTimes(2);
    });
  });
});
