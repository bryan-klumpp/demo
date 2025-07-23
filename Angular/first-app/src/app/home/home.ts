import { Component, inject, OnInit, OnDestroy } from '@angular/core';
import { HousingLocation } from '../housing-location/housing-location';
import { HousingLocationInfoInterface } from '../housinglocation';
import { HousingService } from '../housingservice';
import { Subject, throttleTime  } from 'rxjs';
import { debounceTime, switchMap, takeUntil, tap, delay } from 'rxjs/operators';

@Component({
  selector: 'app-home',
  imports: [HousingLocation],
  template: `
    <section><form>
      <!-- https://www.google.com/search?q=button+debounce+using+angular+pipe&oq=button+debounce+using+angular+pipe&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBCDg0MjJqMGo0qAIAsAIB&sourceid=chrome&ie=UTF-8 -->
      <input type="text" [value]="changeCounter" placeholder="Filter by city" #changeCounterInput readonly/>

    <!-- This button will be debounced, meaning it will block for one second after every click.
         There are, unfortunately, two different means of the word "debounce" on the Internet,
         the difference being whether or not the intended action is executed immediately if there 
         were no recent clicks.  In this case, yes, we want it to take action immediately if there 
         were no recent clicks.  The button simply increments the value in the input box.  -->
    <button class="primary" type="button" (click)="buttonTapped(changeCounterInput.value)">Debounce Test</button></form></section>

    <section class="results"> 
        @for(nextHousingLocation of filteredLocationList; track $index) {
          <app-housing-location [housingLocation]="nextHousingLocation"></app-housing-location>
        }
    </section>
  `,
  styleUrls: ['./home.css'],
})
export class Home implements OnInit, OnDestroy {
    private buttonClicks = new Subject<void>();
    changeCounter:string = "0";
    private destroy$ = new Subject<void>(); // For unsubscribing on component destruction
    isButtonDebounced = false;

    buttonTapped(textValue: string) {
       this.buttonClicks.next();                   // Kick off the pipe chain
    }
    ngOnInit(): void {
      this.buttonClicks.pipe(
        takeUntil(this.destroy$),                  // Unsubscribe when the component is destroyed
        tap(() => this.doRightAway()),             // This function will check the debounce status and actually do something useful ONLY if not debounced
        debounceTime(1000),                        // Wait for 1 second of inactivity before resetting the debounce state
        tap(() => this.isButtonDebounced = false), // Reset the debounce state
      ).subscribe();
    }
    doRightAway() {
        if( ! this.isButtonDebounced ) {
          this.changeCounter = (Number(this.changeCounter) + 1).toString(); // This is the actual stuff we want the button to do, for example incrementing a value displayed on screen
          this.isButtonDebounced = true;            // Prevent button taps from doing anything for another second after a tap
        }
    }
    ngOnDestroy(): void {
      this.destroy$.next();
      this.destroy$.complete();
    }



  //housingService:HousingService= ;
  housingLocationList: HousingLocationInfoInterface[] = [];
  housingService = inject(HousingService);
  filteredLocationList: HousingLocationInfoInterface[] = this.housingLocationList;
   constructor() {
     this.housingService.getAllHousingLocations().then((housingLocationList: HousingLocationInfoInterface[]) => {
        this.housingLocationList = housingLocationList;
        this.filteredLocationList = housingLocationList;
     }); 
   }

}
