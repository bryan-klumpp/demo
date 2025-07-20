import { Component,inject } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { HousingService } from '../housing';
import { HousingLocationInfoInterface } from '../housinglocation';

@Component({
  selector: 'app-details',
  imports: [],
  template: `
    <article><img class="listing-photo" src="{{housingLocation?.photo}}" alt="Exterior of {{housingLocation?.name}}" crossorigin/></article>
  `,
  styleUrls: ['./details.css'],
})
export class Details {
route:ActivatedRoute = inject(ActivatedRoute);
housingService=inject(HousingService);
housingLocation:HousingLocationInfoInterface | undefined;
constructor(){
const housingLocationId=Number(this.route.snapshot.params['id']);
this.housingLocation=this.housingService.getHousingLocationById(housingLocationId);
}
}
