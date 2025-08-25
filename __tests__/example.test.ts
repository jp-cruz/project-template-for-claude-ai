/**
 * Example test file
 * Replace with your actual tests
 */

describe('Example Test Suite', () => {
  beforeEach(() => {
    // Setup before each test
  });

  afterEach(() => {
    // Cleanup after each test
  });

  it('should pass this example test', () => {
    expect(true).toBe(true);
  });

  it('should handle basic math operations', () => {
    expect(2 + 2).toEqual(4);
    expect(10 - 5).toEqual(5);
    expect(3 * 4).toEqual(12);
    expect(8 / 2).toEqual(4);
  });

  it('should handle async operations', async () => {
    const result = await Promise.resolve('test');
    expect(result).toBe('test');
  });

  describe('Nested test suite', () => {
    it('should group related tests', () => {
      const testObject = {
        name: 'test',
        value: 42
      };

      expect(testObject).toHaveProperty('name', 'test');
      expect(testObject).toHaveProperty('value', 42);
    });
  });
});

// Example of testing with mocks
describe('Mock Example', () => {
  it('should mock functions properly', () => {
    const mockFunction = jest.fn();
    mockFunction('test-argument');

    expect(mockFunction).toHaveBeenCalledWith('test-argument');
    expect(mockFunction).toHaveBeenCalledTimes(1);
  });
});