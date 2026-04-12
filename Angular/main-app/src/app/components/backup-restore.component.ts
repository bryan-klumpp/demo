import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { DatabaseService } from '../services/database.service';
import { format } from 'date-fns';

@Component({
  selector: 'app-backup-restore',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <div class="backup-container">
      <header class="backup-header">
        <h1>🗄️ Database Export</h1>
        <p>Export and import data shared across all app modules</p>
      </header>

      <div class="backup-sections">
        <div class="backup-section">
          <h2>📤 Export Data</h2>
          <p>Download a backup file containing all your items and locations.</p>
          
          <div class="export-info" *ngIf="stats">
            <div class="stat-item">
              <strong>{{ stats.totalItems }}</strong> items
            </div>
            <div class="stat-item">
              <strong>{{ stats.totalLocations }}</strong> locations
            </div>
            <div class="stat-item">
              <strong>{{ stats.categoriesCount }}</strong> categories
            </div>
          </div>
          
          <button 
            (click)="exportData()" 
            [disabled]="isExporting"
            class="btn btn-primary"
          >
            {{ isExporting ? 'Exporting...' : '📥 Download Backup' }}
          </button>
          
          <div class="export-note">
            <small>Backup files are in JSON format and can be safely stored anywhere.</small>
          </div>
        </div>

        <div class="backup-section">
          <h2>📥 Import Data</h2>
          <p>Restore data from a previously exported backup file.</p>
          
          <div class="import-warning">
            <strong>⚠️ Warning:</strong> This will replace ALL existing data! Make sure to export your current data first if you want to keep it.
          </div>
          
          <div class="file-input-container">
            <input
              type="file"
              #fileInput
              (change)="onFileSelected($event)"
              accept=".json"
              class="file-input"
              id="backup-file"
            />
            <label for="backup-file" class="file-input-label">
              📎 Choose Backup File
            </label>
          </div>
          
          <button 
            (click)="importData()" 
            [disabled]="!selectedFile || isImporting"
            class="btn btn-secondary"
          >
            {{ isImporting ? 'Importing...' : '📤 Restore Backup' }}
          </button>
          
          <div class="selected-file" *ngIf="selectedFile">
            <p><strong>Selected file:</strong> {{ selectedFile.name }}</p>
            <p><strong>Size:</strong> {{ formatFileSize(selectedFile.size) }}</p>
            <p><strong>Modified:</strong> {{ formatDate(selectedFile.lastModified) }}</p>
          </div>
        </div>
      </div>

      <div class="backup-section">
        <h2>📋 Recent Backups</h2>
        <p>Keep track of when you last backed up your data.</p>
        
        <div class="backup-history" *ngIf="backupHistory.length > 0; else noHistory">
          <div *ngFor="let backup of backupHistory" class="history-item">
            <div class="history-info">
              <strong>{{ backup.filename }}</strong>
              <small>{{ formatDate(backup.timestamp) }}</small>
            </div>
            <div class="history-stats">
              {{ backup.itemCount }} items, {{ backup.locationCount }} locations
            </div>
          </div>
        </div>
        
        <ng-template #noHistory>
          <div class="no-history">
            <p>No backups created yet. Export your data to create your first backup!</p>
          </div>
        </ng-template>
      </div>

      <div class="backup-tips">
        <h3>💡 Backup Tips:</h3>
        <ul>
          <li><strong>Regular Backups:</strong> Export your data regularly to avoid losing information</li>
          <li><strong>Safe Storage:</strong> Store backup files in cloud storage (Google Drive, Dropbox, etc.)</li>
          <li><strong>Version Control:</strong> Keep multiple backup versions with dates in filenames</li>
          <li><strong>Test Restore:</strong> Occasionally test that your backups work properly</li>
          <li><strong>Before Major Changes:</strong> Always backup before deleting lots of data</li>
        </ul>
      </div>

      <div class="quick-links">
        <button routerLink="/" class="nav-link">🏠 Main Menu</button>
        <button routerLink="/tracker" class="nav-link">📦 Household Tracker</button>
        <button routerLink="/time-management" class="nav-link">⏰ Time Management</button>
      </div>
    </div>
  `,
  styles: [`
    .backup-container {
      max-width: 1000px;
      margin: 0 auto;
      padding: 2rem;
    }

    .backup-header {
      text-align: center;
      margin-bottom: 2rem;
    }

    .backup-header h1 {
      font-size: 2.5rem;
      color: #333;
      margin-bottom: 0.5rem;
    }

    .backup-header p {
      color: #666;
      font-size: 1.1rem;
    }

    .backup-sections {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 2rem;
      margin-bottom: 2rem;
    }

    @media (max-width: 768px) {
      .backup-sections {
        grid-template-columns: 1fr;
      }
    }

    .backup-section {
      background: white;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      padding: 1.5rem;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }

    .backup-section h2 {
      margin: 0 0 1rem 0;
      color: #333;
    }

    .backup-section p {
      color: #666;
      margin-bottom: 1.5rem;
    }

    .export-info {
      display: flex;
      gap: 1rem;
      margin-bottom: 1.5rem;
      flex-wrap: wrap;
    }

    .stat-item {
      background: #f3f4f6;
      padding: 0.5rem 1rem;
      border-radius: 6px;
      font-size: 0.9rem;
      color: #374151;
    }

    .btn {
      padding: 0.75rem 1.5rem;
      border: none;
      border-radius: 6px;
      font-size: 1rem;
      cursor: pointer;
      transition: all 0.3s ease;
      width: 100%;
      margin-bottom: 1rem;
    }

    .btn:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }

    .btn-primary {
      background: #4f46e5;
      color: white;
    }

    .btn-primary:hover:not(:disabled) {
      background: #4338ca;
    }

    .btn-secondary {
      background: #059669;
      color: white;
    }

    .btn-secondary:hover:not(:disabled) {
      background: #047857;
    }

    .export-note {
      color: #6b7280;
      font-size: 0.875rem;
    }

    .import-warning {
      background: #fee2e2;
      border: 1px solid #fecaca;
      color: #dc2626;
      padding: 1rem;
      border-radius: 6px;
      margin-bottom: 1.5rem;
      font-size: 0.9rem;
    }

    .file-input-container {
      margin-bottom: 1rem;
    }

    .file-input {
      display: none;
    }

    .file-input-label {
      display: inline-block;
      padding: 0.75rem 1.5rem;
      background: #f3f4f6;
      border: 2px dashed #d1d5db;
      border-radius: 6px;
      cursor: pointer;
      text-align: center;
      transition: all 0.3s ease;
      width: 100%;
      box-sizing: border-box;
    }

    .file-input-label:hover {
      background: #e5e7eb;
      border-color: #9ca3af;
    }

    .selected-file {
      background: #f0fdf4;
      border: 1px solid #bbf7d0;
      padding: 1rem;
      border-radius: 6px;
      margin-top: 1rem;
    }

    .selected-file p {
      margin: 0.25rem 0;
      font-size: 0.9rem;
      color: #166534;
    }

    .backup-history {
      max-height: 300px;
      overflow-y: auto;
    }

    .history-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 1rem;
      border: 1px solid #e5e7eb;
      border-radius: 6px;
      margin-bottom: 0.5rem;
      background: #f9fafb;
    }

    .history-info {
      display: flex;
      flex-direction: column;
    }

    .history-info strong {
      color: #333;
    }

    .history-info small {
      color: #666;
      margin-top: 0.25rem;
    }

    .history-stats {
      font-size: 0.875rem;
      color: #6b7280;
    }

    .no-history {
      text-align: center;
      color: #666;
      font-style: italic;
      padding: 2rem;
    }

    .backup-tips {
      background: #f0fdf4;
      border: 1px solid #bbf7d0;
      border-radius: 8px;
      padding: 1.5rem;
      margin-bottom: 2rem;
    }

    .backup-tips h3 {
      margin: 0 0 1rem 0;
      color: #166534;
    }

    .backup-tips ul {
      margin: 0;
      padding-left: 1.5rem;
    }

    .backup-tips li {
      margin-bottom: 0.5rem;
      color: #166534;
    }

    .quick-links {
      display: flex;
      gap: 1rem;
      justify-content: center;
      flex-wrap: wrap;
      padding-top: 2rem;
      border-top: 1px solid #e5e7eb;
    }

    .nav-link {
      padding: 0.75rem 1.5rem;
      background: white;
      border: 1px solid #d1d5db;
      border-radius: 8px;
      color: #374151;
      text-decoration: none;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .nav-link:hover {
      background: #f9fafb;
      border-color: #9ca3af;
    }
  `]
})
export class BackupRestoreComponent implements OnInit {
  stats: any = null;
  selectedFile: File | null = null;
  isExporting = false;
  isImporting = false;
  backupHistory: any[] = [];

  constructor(private db: DatabaseService) {}

  async ngOnInit() {
    await this.loadStats();
    this.loadBackupHistory();
  }

  private async loadStats() {
    try {
      this.stats = await this.db.getStats();
    } catch (error) {
      console.error('Error loading stats:', error);
    }
  }

  private loadBackupHistory() {
    // Load backup history from localStorage
    const stored = localStorage.getItem('household_backup_history');
    if (stored) {
      try {
        this.backupHistory = JSON.parse(stored);
      } catch (error) {
        console.error('Error loading backup history:', error);
        this.backupHistory = [];
      }
    }
  }

  private saveBackupHistory() {
    try {
      localStorage.setItem('household_backup_history', JSON.stringify(this.backupHistory));
    } catch (error) {
      console.error('Error saving backup history:', error);
    }
  }

  async exportData() {
    if (this.isExporting) return;

    this.isExporting = true;

    try {
      const exportData = await this.db.exportData();
      const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
      const filename = `household-tracker-backup-${timestamp}.json`;
      
      // Create and download file
      const blob = new Blob([exportData], { type: 'application/json' });
      const url = URL.createObjectURL(blob);
      
      const link = document.createElement('a');
      link.href = url;
      link.download = filename;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      
      URL.revokeObjectURL(url);

      // Add to backup history
      const backup = {
        filename,
        timestamp: new Date(),
        itemCount: this.stats?.totalItems || 0,
        locationCount: this.stats?.totalLocations || 0
      };
      
      this.backupHistory.unshift(backup);
      
      // Keep only last 10 backups in history
      if (this.backupHistory.length > 10) {
        this.backupHistory = this.backupHistory.slice(0, 10);
      }
      
      this.saveBackupHistory();

      console.log('Data exported successfully!');
      
    } catch (error) {
      console.error('Error exporting data:', error);
      alert('Failed to export data. Please try again.');
    } finally {
      this.isExporting = false;
    }
  }

  onFileSelected(event: Event) {
    const input = event.target as HTMLInputElement;
    this.selectedFile = input.files?.[0] || null;
  }

  async importData() {
    if (!this.selectedFile || this.isImporting) return;

    const confirmed = confirm(
      'This will replace ALL existing data with the backup file contents. ' +
      'Are you sure you want to continue? This action cannot be undone!'
    );

    if (!confirmed) return;

    this.isImporting = true;

    try {
      const fileContent = await this.readFileAsText(this.selectedFile);
      await this.db.importData(fileContent);
      
      // Reload stats
      await this.loadStats();
      
      alert('Data imported successfully!');
      
      // Clear selected file
      this.selectedFile = null;
      const fileInput = document.getElementById('backup-file') as HTMLInputElement;
      if (fileInput) fileInput.value = '';
      
    } catch (error) {
      console.error('Error importing data:', error);
      alert(`Failed to import data: ${error instanceof Error ? error.message : 'Unknown error'}`);
    } finally {
      this.isImporting = false;
    }
  }

  private readFileAsText(file: File): Promise<string> {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = (e) => resolve(e.target?.result as string);
      reader.onerror = () => reject(new Error('Failed to read file'));
      reader.readAsText(file);
    });
  }

  formatFileSize(bytes: number): string {
    if (bytes === 0) return '0 Bytes';
    
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  }

  formatDate(date: Date | number): string {
    const d = typeof date === 'number' ? new Date(date) : date;
    return format(d, 'MMM dd, yyyy HH:mm');
  }
}