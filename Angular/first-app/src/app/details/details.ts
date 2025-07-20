import { Component,inject } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { HousingService } from '../housingservice';
import { HousingLocationInfoInterface } from '../housinglocation';
import {FormControl,FormGroup,ReactiveFormsModule} from '@angular/forms';

@Component({
  selector: 'app-details',
  imports: [ReactiveFormsModule],
  template: `
    <article><img class="listing-photo" src="{{housingLocation?.photo}}" alt="Exterior of {{housingLocation?.name}}" crossorigin/>
    <section class="listing-apply">
      <h2 class="section-heading">Apply now</h2>
      <form [formGroup]="applyForm" (submit)="submitApplication()">
        <label for="firstName">First Name</label>
        <input formControlName="firstName" />
        <label for="lastName">Last Name</label>
        <input id="lastName" formControlName="lastName" />
        <label for="email">Email</label>
        <input id="email" formControlName="email" />
        <button class="primary" type="button" (click)="submitApplication()">Submit Application</button>
      </form>
    </section>
  </article>

  `,
  styleUrls: ['./details.css'],
})
export class Details {
route:ActivatedRoute = inject(ActivatedRoute);
housingService=inject(HousingService);
housingLocation:HousingLocationInfoInterface | undefined;
applyForm = new FormGroup({
  firstName: new FormControl(''),
  lastName: new FormControl(''),
  email: new FormControl(''),
})
constructor(){
const housingLocationId=Number(this.route.snapshot.params['id']);
this.housingLocation=this.housingService.getHousingLocationById(housingLocationId);
}
submitApplication() {
  this.housingService.submitApplication(
    this.applyForm.value.firstName ?? '',
    this.applyForm.value.lastName ?? '',
    this.applyForm.value.email ?? '',
  );
}
}
