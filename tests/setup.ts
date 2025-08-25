/**
 * Jest setup file
 * Runs before each test file
 */

// Global test configuration
beforeEach(() => {
  // Reset any mocks or state before each test
  jest.clearAllMocks();
});

afterEach(() => {
  // Cleanup after each test
  jest.restoreAllMocks();
});

// Global test utilities
global.console = {
  ...console,
  // Suppress console.log in tests unless explicitly needed
  log: jest.fn(),
  debug: jest.fn(),
  info: jest.fn(),
  warn: jest.fn(),
  error: console.error, // Keep error for debugging
};

// Add custom matchers if needed
expect.extend({
  // Custom matcher example
  // toBeValidEmail(received) {
  //   const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  //   return {
  //     message: () => `expected ${received} to be a valid email`,
  //     pass: emailRegex.test(received),
  //   };
  // },
});