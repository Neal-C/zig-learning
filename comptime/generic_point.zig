pub fn Point(comptime T: type) type {
    return struct {
        x: T,
        y: T,

        const Self = @This();

        //Named spaced fn
        pub fn new(x: T, y: T) Self {
            return .{ .x = x, .y = y };
        }

        //Method
        pub fn distance(self: Self, other: Self) f64 {
            const differenceX: f64 = switch (@typeInfo(T)) {
                .Int => @floatFromInt(other.x - self.x),
                .Float => other.x - self.x,
                else => @compileError("[generic_point]::only floats or integers for generic Points"),
            };
            const differenceY: f64 = switch (@typeInfo(T)) {
                .Int => @floatFromInt(other.y - self.y),
                .Float => other.y - self.y,
                else => @compileError("[generic_point]::only floats or integers for generic Points"),
            };

            return @sqrt((differenceX * differenceX) + (differenceY * differenceY));
        }
    };
}
