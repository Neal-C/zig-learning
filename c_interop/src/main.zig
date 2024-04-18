// Zig doesn't require FFI to interoperate with C code
const std = @import("std");

// Run C code directly in zig without explicitly building a separate library
const c_world = @cImport({
    @cDefine("INCREMENT_BY", "10");
    @cInclude("add.c");
});

// See build.zig comments to understand how to build with C code

pub fn main() !void {
    const a = 21;
    const b = 21;
    const c = c_world.add(a, b);

    std.debug.print("zig world: a + b = {} \n", .{c});
    std.debug.print("zig world: a++ = {} \n", .{c_world.increment(a)});

    // The C standard library is also included in zig for convenience
    _ = std.c.printf("zig via c std lib: a + b = %d", .{c});
}
