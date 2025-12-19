import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { PlayIconComponent } from './play-icon.component';
import { PauseIconComponent } from './pause-icon.component';
import { StopIconComponent } from './stop-icon.component';
import { VolumeIconComponent } from './volume-icon.component';

// This module imports standalone components and re-exports them
// This allows you to import the module and get all icons at once
@NgModule({
  imports: [
    CommonModule,
    PlayIconComponent,
    PauseIconComponent,
    StopIconComponent,
    VolumeIconComponent
  ],
  exports: [
    PlayIconComponent,
    PauseIconComponent,
    StopIconComponent,
    VolumeIconComponent
  ]
})
export class IconsModule { }
