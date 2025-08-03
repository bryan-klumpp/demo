import {Component} from '@angular/core';
import {Home} from './home/home';
import { RouterModule } from '@angular/router';
import { FloatingMenuComponent } from './floating-menu/floating-menu';

@Component({
  selector: 'app-root',
  imports: [/*Home,*/RouterModule, FloatingMenuComponent],
  template: `<main>
    <a [routerLink]="['/']">
    <header class="brand-name"><img class="brand-logo" src="/assets/logo.svg" alt="logo" aria-hidden="true">
  </header>
</a>
  <section class="content"><router-outlet/></section>
  <app-floating-menu></app-floating-menu>
  </main>
  `,
  styleUrls: ['./app.css'],
})
export class App {
  title = 'homes';
}
