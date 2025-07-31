import { TestSpec } from './abstract-test-spec';
import { Home } from '../src/app/home/home';
import { HousingLocation } from '../src/app/housing-location/housing-location';

describe('Home Component', () => {
  class HomeTestSpec extends TestSpec<Home> {
    protected getSubComponentTypes() {
      return [HousingLocation];
    }
    protected getComponentType() {
      return Home;
    }
  }

  const testSpec = new HomeTestSpec();
  testSpec.runComponentAndSubComponentTruthinessTests();

  // Additional tests for Home can go here
  it('should create Home component instance', () => {
    const home = new Home();
    expect(home).toBeTruthy();
  });
});
