extern fn print(i32) void;

// freestanding => for browsers
// zig build-exe add.zig -target wasm32-freestanding -fno-entry --export=add -O ReleaseFast

// WASI => Web assembly runtime / Web Assembly System Interface
// zig build-exe add.zig -target wasm32-wasi -fno-entry --export=add -O ReleaseFast 
export fn add(a: i32, b: i32) void {
    print(a + b);
}