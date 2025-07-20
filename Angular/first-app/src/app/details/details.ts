import { Component,inject } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { HousingService } from '../housing';
import { HousingLocationInfoInterface } from '../housinglocation';

@Component({
  selector: 'app-details',
  imports: [],
  template: `
    <p>
      details works!  {{housingLocationId}}
    </p>
  `,
  styles: ``
})
export class Details {
route:ActivatedRoute = inject(ActivatedRoute);
housingLocationId = -1;
constructor(){
this.housingLocationId = Number(this.route.snapshot.params['id']);

}
}
