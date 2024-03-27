const std = @import("std");

const global_const: u8 = 42;

var global_var: u8 = 0;

fn printInfo(name: []const u8, x: anytype) void {
    std.debug.print("{s:>10} {any:^10}\t{}\n", .{ name, x, @TypeOf(x) });
}
// Calm down, this isn't like typescript's any
pub fn main() anyerror!void {
    std.debug.print("{s:>10} {s:^10}\t{s}\n", .{ "name", "value", "type" });
    std.debug.print("{s:>10} {s:^10}\t{s}\n", .{ "----", "-----", "----" });

    const my_const = 1;
    printInfo("my_const", my_const);

    var my_var: u8 = 2;

    my_var += 1;

    printInfo("my_var", my_var);

    // comptime
    comptime var my_other_var = 42;
    my_other_var += 10;

    const that_same_var: u8 = 42;
    _ = that_same_var;

    var undefined_until_defined: u8 = undefined;
    printInfo("undefined_until_defined", undefined_until_defined);

    undefined_until_defined = 75;
    printInfo("undefined_until_defined", undefined_until_defined);

    const anything_unsigned: u1 = 0;
    _ = anything_unsigned;

    const arbitrary_unsigned: u2 = 1;
    _ = arbitrary_unsigned;

    _ = 1_000_000;
    _ = 0x10ff_ffff; // decimal
    _ = 0o777; // octol
    _ = 0b1111_0101_0111; // binary

    const unicode_code_point: u21 = 'f';
    _ = unicode_code_point;

    // comptime types

    const comptimed_typed = 42;
    _ = comptimed_typed;

    // floating points

    _ = 123.0E+77; // with exponent
    _ = 123.0; // without exponnent
    _ = 123.0e+77; // e or E , both.

    _ = 42_42.00;

    _ = std.math.inf(f64); // positive infinity
    _ = -std.math.inf(f64); // negative infinity
    _ = std.math.nan(f64); // Nan, not a number

}
