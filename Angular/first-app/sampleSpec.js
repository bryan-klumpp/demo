describe("A suite for demo purposes", function() {
  it("should add numbers correctly", function() {
    expect(1 + 2).toBe(3);
  });

  it("should compare strings", function() {
    expect("hello".toUpperCase()).toBe("HELLO");
  });

  it("should check array contents", function() {
    var arr = [1, 2, 3];
    expect(arr).toContain(2);
    expect(arr.length).toBe(3);
  });

  it("should handle asynchronous code", function(done) {
    setTimeout(function() {
      expect(true).toBe(true);
      done();
    }, 100);
  });
});
