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
      <input type="text" [value]="changeCounter" placeholder="Filter by city" #changeCounterInput readonly/>
      <!-- https://www.google.com/search?q=button+debounce+using+angular+pipe&oq=button+debounce+using+angular+pipe&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBCDg0MjJqMGo0qAIAsAIB&sourceid=chrome&ie=UTF-8 -->
      <!--                                                               (I used [disabled] but could use the [busy] property which we have in our app?) -->
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
    private buttonClicks2 = new Subject<void>();
    changeCounter:string = "0";
    private destroy$ = new Subject<void>(); // For unsubscribing on component destruction
    isButtonDebounced = false;
    timeout: number | undefined;

    isButtonDisabled(): boolean {
       return this.isButtonDebounced /* AND values not matched...  */;
    }
    buttonTapped(textValue: string) {
       console.log('Button tapped');
       this.buttonClicks.next();
       this.doDebounce();
    }
    async doDebounce() {
        this.buttonClicks2.next();
    }
    ngOnInit(): void {
      this.buttonClicks.pipe(
        takeUntil(this.destroy$), // Unsubscribe when the component is destroyed
        tap(() => this.doRightAway()), // Increment the counter
      ).subscribe();
      this.buttonClicks2.pipe(debounceTime(1000)).pipe(
          takeUntil(this.destroy$), // Unsubscribe when the component is destroyed
          switchMap(() => {
          this.isButtonDebounced = false; // Reset the debounce state
          console.log('setting isButtonDebounced to false');
          return "dummyToken";
        })).subscribe();
    }
    ngOnDestroy(): void {
      this.destroy$.next();
      this.destroy$.complete();
    }
    doRightAway() {
        console.log('doRightAway called');
        if( ! this.isButtonDebounced ) {
          this.changeCounter = (parseInt(this.changeCounter, 10) + 1).toString();
        }
        this.isButtonDebounced = true;
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
