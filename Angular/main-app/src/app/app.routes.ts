import { Routes } from '@angular/router';
import { WelcomeComponent } from './components/welcome.component';
import { DemoComponent } from './components/demo.component';
import { TrackerLayoutComponent } from './components/tracker-layout.component';
import { TrackerDashboardComponent } from './components/tracker-dashboard.component';
import { SearchComponent } from './components/search.component';
import { AddItemComponent } from './components/add-item.component';
import { LocationManagementComponent } from './components/location-management.component';
import { BackupRestoreComponent } from './components/backup-restore.component';
import { TimeManagementLayoutComponent } from './components/time-management-layout.component';
import { WakeAlarmsComponent } from './components/wake-alarms.component';
import { DatabaseExportLayoutComponent } from './components/database-export-layout.component';

export const routes: Routes = [
  { path: '', component: WelcomeComponent },
  { path: 'demo', component: DemoComponent },
  {
    path: 'tracker',
    component: TrackerLayoutComponent,
    children: [
      { path: '', component: TrackerDashboardComponent },
      { path: 'search', component: SearchComponent },
      { path: 'add-item', component: AddItemComponent },
      { path: 'add-location', component: LocationManagementComponent },
      { path: 'locations', component: LocationManagementComponent },
      { path: 'items', component: SearchComponent } // Alias for search
    ]
  },
  {
    path: 'time-management',
    component: TimeManagementLayoutComponent,
    children: [
      { path: '', component: WakeAlarmsComponent }
    ]
  },
  {
    path: 'database-export',
    component: DatabaseExportLayoutComponent,
    children: [
      { path: '', component: BackupRestoreComponent }
    ]
  }
];
