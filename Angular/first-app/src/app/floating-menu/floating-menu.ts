import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';

interface MenuState {
  level: number;
  visible: boolean;
  items: MenuItem[];
}

interface MenuItem {
  label: string;
  action: () => void;
}

@Component({
  selector: 'app-floating-menu',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="floating-menu-container">
      <!-- Floating Menu Button -->
      <button 
        class="floating-menu-btn" 
        (click)="toggleMenu()"
        [class.active]="menuState.visible">
        <span class="menu-icon">☰</span>
      </button>

      <!-- Menu Overlay -->
      <div class="menu-overlay" 
           *ngIf="menuState.visible" 
           (click)="closeMenu()">
      </div>

      <!-- Menu Content -->
      <div class="menu-content" 
           *ngIf="menuState.visible"
           [class.slide-in]="menuState.visible">
        
        <!-- Back Button (only show if not at top level) -->
        <button *ngIf="menuState.level > 0" 
                class="menu-item back-btn" 
                (click)="goBack()">
          ← Back
        </button>

        <!-- Menu Items -->
        <button *ngFor="let item of menuState.items" 
                class="menu-item"
                (click)="item.action()">
          {{ item.label }}
        </button>
      </div>
    </div>

    <!-- Dialog Box -->
    <div class="dialog-overlay" 
         *ngIf="dialogVisible" 
         (click)="closeDialog()">
      <div class="dialog-content" (click)="$event.stopPropagation()">
        <h3>{{ dialogMessage }}</h3>
        <button class="dialog-close-btn" (click)="closeDialog()">Close</button>
      </div>
    </div>
  `,
  styleUrls: ['./floating-menu.css']
})
export class FloatingMenuComponent {
  menuState: MenuState = {
    level: 0,
    visible: false,
    items: []
  };

  dialogVisible = false;
  dialogMessage = '';

  private topLevelItems: MenuItem[] = [
    {
      label: 'Submenu 1',
      action: () => this.showSubmenu1()
    },
    {
      label: 'Submenu 2', 
      action: () => this.showSubmenu2()
    }
  ];

  private submenu1Items: MenuItem[] = [
    {
      label: 'ngTemplateOutlet',
      action: () => this.navigateToNgTemplateOutletDemo()
    },
    {
      label: 'Enum Demo',
      action: () => this.navigateToEnumDemo()
    }
  ];

  private submenu2Items: MenuItem[] = [
    {
      label: 'Leaf 3',
      action: () => this.showDialog('Leaf 3')
    },
    {
      label: 'Leaf 4',
      action: () => this.showDialog('Leaf 4')
    }
  ];

  constructor(private router: Router) {
    this.menuState.items = this.topLevelItems;
  }

  toggleMenu(): void {
    if (this.menuState.visible) {
      this.closeMenu();
    } else {
      this.openMenu();
    }
  }

  openMenu(): void {
    this.menuState.visible = true;
    this.menuState.level = 0;
    this.menuState.items = this.topLevelItems;
  }

  closeMenu(): void {
    this.menuState.visible = false;
    this.menuState.level = 0;
    this.menuState.items = this.topLevelItems;
  }

  showSubmenu1(): void {
    this.menuState.level = 1;
    this.menuState.items = this.submenu1Items;
  }

  showSubmenu2(): void {
    this.menuState.level = 1;
    this.menuState.items = this.submenu2Items;
  }

  goBack(): void {
    if (this.menuState.level > 0) {
      this.menuState.level = 0;
      this.menuState.items = this.topLevelItems;
    }
  }

  showDialog(message: string): void {
    this.dialogMessage = message;
    this.dialogVisible = true;
    this.closeMenu(); // Hide menu when dialog opens
  }

  navigateToNgTemplateOutletDemo(): void {
    this.closeMenu(); // Hide menu before navigation
    this.router.navigate(['/ng-template-outlet-demo']);
  }

  navigateToEnumDemo(): void {
    this.closeMenu(); // Hide menu before navigation
    this.router.navigate(['/enum-demo']);
  }

  closeDialog(): void {
    this.dialogVisible = false;
    this.dialogMessage = '';
  }
}
