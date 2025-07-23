import { Injectable } from '@angular/core';
import { HousingLocationInfoInterface } from './housinglocation';

@Injectable({
  providedIn: 'root'
})
export class HousingService {
  url='http://localhost:3000/locations';


    async getAllHousingLocations(): Promise<HousingLocationInfoInterface[]> {
      const data = await fetch(this.url);
      return (await data.json()) ?? [];
    }
    async getHousingLocationById(id:number): Promise<HousingLocationInfoInterface|undefined> {
      const data = await fetch(`${this.url}?id=${id}`);
      const locationJson = await data.json();
      return locationJson[0] ?? {};
    }
    submitApplication(firstName:string,lastName:string,email:string){
      console.log(`Homes application received: firstname: ${firstName}, LastName: `+lastName);
    }
}
