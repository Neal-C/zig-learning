const std = @import("std");

pub fn addWillSaturate(n: u8, x: u8) u8 {
    return n +| x;
}

pub fn addCanOverflowAndWrap(n: u8, x: u8) u8 {
    return n +% x;
}

pub fn subWillSaturate(n: u8, x: u8) u8 {
    return n -| x;
}

pub fn subCanOverflowAndWrap(n: u8, x: u8) u8 {
    return n -% x;
}

pub fn main() anyerror!void {
    const zero: u8 = 0;
    const one: u8 = 1;
    const two: u8 = 2;
    const two_fifty: u8 = 250;

    var result = zero + two - one + two / one % 2;

    // safe
    result = two_fifty +| two;
    // watch out
    result = two_fifty +% two +% two +% two;

    // Shifts
    _ = 1 << 2;
    _ = 1 <<| 2;
    _ = 42 >> 1;

    // bit ops
    _ = 32 | 1; // or
    _ = 32 & 1; // and
    _ = 32 ^ 0; // NOR

    const one_bit: u8 = 0b0000_0001;
    _ = ~one_bit; // NOT

    const byte_size: u8 = 200;
    const word: u16 = 999;

    // safe coercion
    const instruction: u32 = byte_size + word;
    std.debug.print("instruction: {} \n", .{instruction});

    // cast coercion
    const second_instruction: u16 = @intCast(instruction);
    std.debug.print("second_instruction: {} \n", .{second_instruction});

    // conversions
    var my_float: f32 = 3.1415;
    const my_int_from_float: i32 = @intFromFloat(my_float);
    std.debug.print("my_int_from_float: {} \n", .{my_int_from_float});

    my_float = @floatFromInt(my_int_from_float);

    std.debug.print("my_float: {} \n", .{my_float});

	// builtins
	// @addWithOverlfow, @mod , @rem , @fabs, @sqrt , @min , @max 
	// std.math{divExact, add, sub}
	// std.math.divExact(n,x);
}
