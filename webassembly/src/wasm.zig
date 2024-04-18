// zig wasm is like writing a lib

// WASM freestandig is for browsers
// WASM WASI is for making it runnable in shells or operating systems with WASI runtime.

const std = @import("std");

const allocator = std.heap.wasm_allocator;

// export function to javascript

pub export fn add(a: i32, b: i32) i32 {
    return a +% b;
}

pub export fn substract(a: i32, b: i32) i32 {
    return a -% b;
}

// Allocate 'len' bytes in WASM memory, returns mayn-item-pointer on success, null on error
pub export fn alloc(len: usize) ?[*]u8 {
    return if (allocator.alloc(u8, len)) |slice| slice.ptr else null;
}

// Free 'len' bytes in WASM Memory pointed to by ptr
pub export fn free(ptr: [*]u8, len: usize) void {
    allocator.free(ptr[0..len]);
}

// WASM does not have a string type

// ! Black Magic
// Import function from javascript word
extern "env" fn jslog(ptr: [*]u8, len: usize) void;

// This function called from javascript, enters WASM/Zig, and turns back to javascript
pub export fn zigconsolelog(ptr: [*]u8, len: usize) void {
    jslog(ptr, len);
}
