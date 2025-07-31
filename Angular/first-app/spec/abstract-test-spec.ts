import { Type } from '@angular/core';

export abstract class TestSpec<T> {
  // Subclasses must implement this to return sub-component types
  protected abstract getSubComponentTypes(): Array<Type<any>>;
  // Subclasses must provide the main component type
  protected abstract getComponentType(): Type<T>;

  // Optionally, subclasses can override this to provide a custom description
  protected getSubComponentTestDescription(): string {
    return 'should have all sub-components defined (truthy)';
  }
  protected getComponentTestDescription(): string {
    return 'should have the main component defined (truthy)';
  }

  // Call this in the subclass's describe() block to run the generic tests
  public runComponentAndSubComponentTruthinessTests(): void {
    const component = this.getComponentType();
    it(this.getComponentTestDescription(), () => {
      expect(component).toBeTruthy();
    });

    const subComponents = this.getSubComponentTypes();
    it(this.getSubComponentTestDescription(), () => {
      for (const comp of subComponents) {
        expect(comp).toBeTruthy();
      }
    });
  }
}
