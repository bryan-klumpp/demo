import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';

interface ButtonData {
  id: number;
  label: string;
  color: string;
  icon: string;
}

@Component({
  selector: 'app-ng-template-outlet-demo',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `
    <div class="demo-container">
      <header class="demo-header">
        <h1>ngTemplateOutlet Demo</h1>
        <p>This page demonstrates using ngTemplateOutlet with dynamic data in a for loop</p>
        <a [routerLink]="['/']" class="back-link">← Back to Home</a>
      </header>

      <section class="demo-section">
        <h2>Button Template with ngTemplateOutlet</h2>
        <p>Here we define a template once and reuse it multiple times with different data:</p>

        <!-- Define the template -->
        <ng-template #buttonTemplate let-buttonData="data" let-index="index">
          <button 
            class="demo-button"
            [style.background-color]="buttonData.color"
            (click)="onButtonClick(buttonData, index)">
            <span class="button-icon">{{ buttonData.icon }}</span>
            <span class="button-label">{{ buttonData.label }}</span>
            <span class="button-number">#{{ index + 1 }}</span>
          </button>
        </ng-template>

        <!-- Use the template in a loop -->
        <div class="buttons-grid">
          <div *ngFor="let button of buttonDataList; let i = index" class="button-wrapper">
            <ng-container 
              *ngTemplateOutlet="buttonTemplate; context: { data: button, index: i }">
            </ng-container>
          </div>
        </div>
      </section>

      <section class="demo-section">
        <h2>Alternative: Card Template Example</h2>
        <p>Another template example showing different data types:</p>

        <!-- Define another template for cards -->
        <ng-template #cardTemplate let-item="cardData" let-position="pos">
          <div class="demo-card" [class]="'card-' + item.type">
            <div class="card-header">
              <h3>{{ item.title }}</h3>
              <span class="card-position">Position: {{ position }}</span>
            </div>
            <div class="card-body">
              <p>{{ item.description }}</p>
              <div class="card-stats">
                <span class="stat">{{ item.stat1 }}</span>
                <span class="stat">{{ item.stat2 }}</span>
              </div>
            </div>
          </div>
        </ng-template>

        <!-- Use card template -->
        <div class="cards-container">
          <div *ngFor="let card of cardDataList; let pos = index">
            <ng-container 
              *ngTemplateOutlet="cardTemplate; context: { cardData: card, pos: pos + 1 }">
            </ng-container>
          </div>
        </div>
      </section>

      <section class="demo-section">
        <h2>Click Results</h2>
        <div class="results-area">
          <div *ngIf="lastClickedButton" class="click-result">
            <h4>Last Clicked Button:</h4>
            <p><strong>Label:</strong> {{ lastClickedButton.label }}</p>
            <p><strong>Index:</strong> {{ lastClickedIndex }}</p>
            <p><strong>Color:</strong> {{ lastClickedButton.color }}</p>
            <p><strong>Icon:</strong> {{ lastClickedButton.icon }}</p>
          </div>
          <div *ngIf="!lastClickedButton" class="no-clicks">
            Click any button above to see the results here!
          </div>
        </div>
      </section>
    </div>
  `,
  styleUrls: ['./ng-template-outlet-demo.css']
})
export class NgTemplateOutletDemoComponent {
  buttonDataList: ButtonData[] = [
    { id: 1, label: 'Primary Action', color: '#007bff', icon: '🚀' },
    { id: 2, label: 'Secondary Action', color: '#6c757d', icon: '⚙️' },
    { id: 3, label: 'Success Action', color: '#28a745', icon: '✅' },
    { id: 4, label: 'Warning Action', color: '#ffc107', icon: '⚠️' },
    { id: 5, label: 'Danger Action', color: '#dc3545', icon: '❌' },
    { id: 6, label: 'Info Action', color: '#17a2b8', icon: 'ℹ️' }
  ];

  cardDataList = [
    {
      type: 'feature',
      title: 'Dynamic Templates',
      description: 'ngTemplateOutlet allows you to define reusable templates',
      stat1: '100% Reusable',
      stat2: 'Type Safe'
    },
    {
      type: 'benefit',
      title: 'Context Passing',
      description: 'Pass data to templates using the context object',
      stat1: 'Flexible',
      stat2: 'Powerful'
    },
    {
      type: 'usage',
      title: 'Loop Integration',
      description: 'Perfect for use with *ngFor and dynamic data',
      stat1: 'Scalable',
      stat2: 'Efficient'
    }
  ];

  lastClickedButton: ButtonData | null = null;
  lastClickedIndex: number = -1;

  onButtonClick(buttonData: ButtonData, index: number): void {
    this.lastClickedButton = buttonData;
    this.lastClickedIndex = index;
    console.log('Button clicked:', buttonData, 'at index:', index);
  }
}
