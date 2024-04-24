const std = @import("std");

// An interface for anything that can turn itself into a string

pub const Stringer = struct {
    // anyopaque means "we have no type information or details about this type. It is a black box"
    // It also said to be and known as : type erasure
    // Anything coerced to anyopaque will lose its type information
    // Here (in our interface), it is necessary so that we can accept anything that wants/can implement the interface
    // anyopaque does not have a known size, because we just don't know what it is !
    // However, a pointer will always have a known size: the computer architecture word size
    // So the known size of the pointer satisfies the compiler
    ptr: *anyopaque,
    // Here, we specify the type of the actual function in this interface
    // Here, we have 1 function but interfaces can have many functions
    toStringFn: *const fn (*anyopaque, []u8) anyerror![]u8,

    const Self = @This();

    pub fn toString(self: Self, buffer: []u8) anyerror![]u8 {
        return self.toStringFn(self.ptr, buffer);
    }
};

// User implementation
pub const User = struct {
    name: []const u8,
    email: []const u8,

    const Self = @This();

    pub fn toString(ptr: *anyopaque, buffer: []u8) anyerror![]u8 {
        // pointer to anyopaque has a data alignment of 1 ( since we don't know the actual alignment of the type we have in memory)
        // @alignCast will cast its alignment to the inferred/Specifed type
        // where here it is *Self/*User
        // And @ptrCast will cast that pointer to anyopaque to a pointer to Self/User
        // We're basically un-erasing type information
        const self: *Self = @ptrCast(@alignCast(ptr));
        return std.fmt.bufPrint(buffer, "User(name: {[name]s}, email: {[email]s})", self.*);
    }

    pub fn stringer(self: *Self) Stringer {
        return Stringer{
            .ptr = self,
            .toStringFn = Self.toString,
        };
    }
};

// Animal implementation
pub const Animal = struct {
    name: []const u8,
    greeting: []const u8,

    const Self = @This();

    pub fn toString(ptr: *anyopaque, buffer: []u8) anyerror![]u8 {
        const self: *Self = @ptrCast(@alignCast(ptr));
        return std.fmt.bufPrint(buffer, "{[name]s} says {[greeting]s})", self.*);
    }

    pub fn stringer(self: *Self) Stringer {
        return Stringer{
            .ptr = self,
            .toStringFn = Self.toString,
        };
    }
};
