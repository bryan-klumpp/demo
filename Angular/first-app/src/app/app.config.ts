/*!
 * @license
 * Copyright Google LLC All Rights Reserved.
 *
 * Use of this source code is governed by an MIT-style license that can be
 * found in the LICENSE file at https://angular.dev/license
 */

import {ApplicationConfig} from '@angular/core';
import { provideRouter,withComponentInputBinding } from '@angular/router';
import routeConfig from './routes';

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(
      routeConfig,
      withComponentInputBinding(), // Google angular router pass input parameters to home component
    ),
  ],
};
