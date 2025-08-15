// Global test setup file

// Global setup - runs before ALL tests
(async () => {
  console.log('Starting global test setup, pausing for debugger attachment...');
  await new Promise(resolve => setTimeout(resolve, 10000)); // 10 second delay
  console.log('Continuing with test execution...');

  // Find and load all test files
  const context = (require as any).context('./', true, /\.spec\.ts$/);
  context.keys().forEach(context);
})();
