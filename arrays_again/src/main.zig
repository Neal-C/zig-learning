const std = @import("std");

pub fn main() !void {
    const array_literal = [_]u8{ 1, 2, 3 };

    std.debug.print("array_literal : {any} \n", .{array_literal});

    // result location semantics, aka "inference". the location gives the type
    const tuple_literal: [3]u8 = .{ 1, 2, 3 };
    std.debug.print("tuple_literal : {any} \n\n", .{tuple_literal});

    var my_array: [3]u8 = undefined;
    // must be initialized before use;
    my_array[0] = 1;
    my_array[1] = 2;
    my_array[2] = 3;

    // destructuring syntax
    my_array[0], my_array[1], my_array[2] = .{ 2, 4, 6 };

    std.debug.print("my_array  : {any} \n\n", .{my_array});

    const a, const b, const c = my_array;
    std.debug.print("a,b,c values: {} , {} , {} \n\n", .{ a, b, c });
}
