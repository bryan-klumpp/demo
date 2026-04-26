import { Component, HostListener, OnInit } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { AlarmService } from './services/alarm.service';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App implements OnInit {
  protected readonly title = 'Household Tracker';

  constructor(private alarmService: AlarmService) {}

  ngOnInit(): void {
    this.alarmService.start();
  }

  @HostListener('document:click')
  @HostListener('document:keydown')
  onUserInteraction(): void {
    this.alarmService.unlockAudioContext();
  }
}
