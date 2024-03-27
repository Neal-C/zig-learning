const std = @import("std");

const Point = @import("Point.zig");

const genericPoint = @import("generic_point.zig").Point;

pub fn main() void {
    const beginning = Point.new(0, 0);
    const destination = Point.new(42, 42);

    std.debug.print("distance is {d:.1} \n", .{beginning.distance(destination)});
	std.debug.print("type information: {} \n", .{@TypeOf(destination)});

    const southPole = genericPoint(f32).new(0, 0);
    const NorthPole = genericPoint(f32).new(42, 42);

    std.debug.print("distance is {d:.1} \n", .{southPole.distance(NorthPole)});
	std.debug.print("type information: {} \n", .{@TypeOf(NorthPole)});
}
