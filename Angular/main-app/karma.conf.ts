import { Config, ConfigOptions } from 'karma';

module.exports = function(config: Config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine', '@angular-devkit/build-angular'],
    plugins: [
      require('karma-jasmine'),
      require('karma-chrome-launcher'),
      require('karma-jasmine-html-reporter'),
      require('karma-coverage'),
      require('@angular-devkit/build-angular/plugins/karma')
      ],
      customLaunchers: {
          Chrome_with_debugging: {
              base: 'Chrome',
              flags: ['--remote-debugging-port=9222'], // Or any other available port
              debug: true
          }
      },
      browsers: ['Chrome_with_debugging'], // Use this launcher for debugging
      client: {
      clearContext: false, // leave Jasmine Spec Runner output visible in browser
      jasmine: {
        random: false, // Run tests in order for easier debugging
        failFast: true // Stop on first failure
      }
    },
    coverageReporter: {
      dir: require('path').join(__dirname, './coverage'),
      subdir: '.',
      reporters: [
        { type: 'html' },
        { type: 'text-summary' }
      ]
    },
    reporters: ['progress', 'kjhtml'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['ChromeHeadless'],
    singleRun: false,
    restartOnFileChange: true
  } as ConfigOptions);
};
