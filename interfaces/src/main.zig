const std = @import("std");

// More performant, but requires control over the source code
// const Stringer = @import("to_string_tagged.zig").Stringer;

const Stringer = @import("to_string_ptr.zig").Stringer;
const User = @import("to_string_ptr.zig").User;
const Animal = @import("to_string_ptr.zig").Animal;

fn printStringer(s: Stringer) !void {
    var buffer: [256]u8 = undefined;
    const str = try s.toString(&buffer);
    std.debug.print("{s}\n ", .{str});
}

pub fn main() !void {
    // Tagged union interface

    // const bob = Stringer{
    //     .user = .{ .name = "Bob", .email = "bobandalice@ziglings.com" },
    // };

    // try printStringer(bob);

    // const donald = Stringer{ .animal = .{
    //     .name = "Donald",
    //     .greeting = "quack! quack!",
    // } };

    // try printStringer(donald);

    // Pointer cast interface

    var alice = User{ .name = "Alice", .email = "alice@ziglings.com" };

    const alice_stringer_implementation = alice.stringer();

    try printStringer(alice_stringer_implementation);

    var beethoven = Animal{ .name = "Beethoven", .greeting = "Waf! Waf!" };

    const beethoven_stringer_implementation = beethoven.stringer();

    try printStringer(beethoven_stringer_implementation);
}
