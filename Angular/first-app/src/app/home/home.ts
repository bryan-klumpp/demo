import { Component, inject, OnInit, OnDestroy } from '@angular/core';
import { HousingLocation } from '../housing-location/housing-location';
import { HousingLocationInfoInterface } from '../housinglocation';
import { HousingService } from '../housingservice';
import { Subject } from 'rxjs';
import { debounceTime, takeUntil, tap } from 'rxjs/operators';

@Component({
  selector: 'app-home',
  imports: [HousingLocation],
  template: `
    <section><form>
      <input type="text" placeholder="Filter by city" #filter />
      <!-- https://www.google.com/search?q=button+debounce+using+angular+pipe&oq=button+debounce+using+angular+pipe&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBCDg0MjJqMGo0qAIAsAIB&sourceid=chrome&ie=UTF-8 -->
      <!--                                                               (I used [disabled] but could use the [busy] property which we have in our app?) -->
      <button class="primary" type="button" (click)="buttonTapped(filter.value)" [disabled]="this.isButtonDebounced">Debounce Test</button></form></section>
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
    private destroy$ = new Subject<void>(); // For unsubscribing on component destruction
    isButtonDebounced = false;
    timeout: number | undefined;

    isButtonDisabled(): boolean {
       return this.isButtonDebounced /* AND values not matched...  */;
    }
    buttonTapped(textValue: string) {
       console.log('Button tapped');
       if ( ! this.isButtonDebounced) {
          this.isButtonDebounced = true;
          this.buttonClicks.next();
       }
    }
    ngOnInit(): void {
      this.buttonClicks.pipe(
        debounceTime(1000), // Debounce for 1 second
        tap(() => this.isButtonDebounced = false), // Execute your action
        takeUntil(this.destroy$) // Unsubscribe when the component is destroyed
      ).subscribe();
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
