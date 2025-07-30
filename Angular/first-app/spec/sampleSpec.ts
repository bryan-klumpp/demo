 // to get VSCode support for these, run:  npm install --save-dev typescript jasmine @types/jasmine

describe('Simple Math', () => {
  it('should add numbers correctly', () => {
    const sum = 1 + 2;
    expect(sum).toBe(3);
  });

  it('should subtract numbers correctly', () => {
    const diff = 5 - 2;
    expect(diff).toBe(3);
  });
});