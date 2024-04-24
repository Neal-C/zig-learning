// Interface implemented with a tagged union

const std = @import("std");

pub const User = struct {
	name: []const u8,
    email: []const u8,

    const Self = @This();

    pub fn toString(self: Self, buffer: []u8) anyerror![]u8 {
        return std.fmt.bufPrint(buffer, "User(name: {[name]s}, email: {[email]s})", self.*);
    }
};
pub const Animal = struct {
    name: []const u8,
    greeting: []const u8,

    const Self = @This();

    pub fn toString(self: Self, buffer: []u8) anyerror![]u8 {
        return std.fmt.bufPrint(buffer, "{[name]s} says {[greeting]s})", self.*);
    }
};

pub const Stringer = union(enum) {
	// Closed implementation that requires control over the source code
	// Everytime you want to implement this interface, you must explicity add a type here
    user: User,
    animal: Animal,

    const Self = @This();

    pub fn toString(self: Self, buffer: []u8) ![]u8 {
        return switch (self) {
            inline else => |itself| itself.toString(buffer),
        };
    }
};
