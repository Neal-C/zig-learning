const std = @import("std");

pub fn main() !void {
    const input = "404";
    std.debug.print("input was {s} \n", .{input});
}
