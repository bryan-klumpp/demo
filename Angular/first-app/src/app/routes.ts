import {Routes, provideRouter, withComponentInputBinding} from '@angular/router';
import {Home} from './home/home';
import {Details} from './details/details';
import { NgTemplateOutletDemoComponent } from './ng-template-outlet-demo/ng-template-outlet-demo';
import { EnumDemoComponent } from './enum-demo/enum-demo';

const routeConfig: Routes = [
{
    path: '',
    component: Home,
    title: 'Home page',
  },
  {
    path: 'details/:id',
    component: Details,
    title: 'Home details',
  },
  {
    path: 'ng-template-outlet-demo',
    component: NgTemplateOutletDemoComponent,
    title: 'ngTemplateOutlet Demo',
  },
  {
    path: 'enum-demo',
    component: EnumDemoComponent,
    title: 'TypeScript Enums Demo',
  },
];

export default routeConfig;