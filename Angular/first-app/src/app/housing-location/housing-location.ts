import { Component,input } from '@angular/core';
import { HousingLocationInfoInterface } from '../housinglocation';
import { Router, RouterLink } from '@angular/router';
import { RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-housing-location',
  imports: [RouterLink],
  template: `
    <section class="listing"><img class="listing-photo" 
    [src]="housingLocation().photo" alt="Photo of {{housingLocation().name}}"
    crossorigin />
    <h2 class="listing-heading">{{housingLocation().name}}</h2>
    <p class="listing-location">{{housingLocation().city}}, {{housingLocation().state}}</p>
    <a [routerLink]="['/details', housingLocation().id]">Learn more</a>
    </section>
  `,
  styleUrls: ['./housing-location.css'],
})
export class HousingLocation {
  housingLocation=input.required<HousingLocationInfoInterface>()
}
