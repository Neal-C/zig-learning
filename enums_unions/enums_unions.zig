const std = @import("std");

// auto-assigned integers starting at 0;
// Uses the smallest possible unsigned integer type : u1, u2, u3, u4, u5, etc...
const Color = enum(u8) {
    red,
    green,
    blue,
    alpha,
    // this tells Zig that this enum is not covering all the possibilites
    _,
    // this above, is pure genius

    fn isRed(self: @This()) bool {
        return self == Color.red;
    }
};

const FightingStyle = union {
    Swords: u8,
    Artillery: []const u8,
    Fists: u2,
};

// tagged union
const Token = union(enum) {
    // if the type is void, you can omit it
    keyword_if,
    keyword_switch: void,
    digit: usize,

    const Self = @This();

    fn is(self: Self, tag: std.meta.Tag(Token)) bool {
        return self == tag;
    }
};

pub fn main() !void {
    var bull: Color = .red;

    std.debug.print("bulls are triggered by {s} , is it {} ? \n", .{ @tagName(bull), bull.isRed() });

    bull = .alpha;

    std.debug.print("bull as int = {} \n", .{@intFromEnum(bull)});

    switch (bull) {
        Color.red => std.debug.print("This is just Rust but for C", .{}),
        .blue => std.debug.print("If you're reading this, contact me !", .{}),
        else => std.debug.print("else branch, just anything else \n", .{}),
    }

    //union switch
    var token: Token = .keyword_if;
    std.debug.print("is if ? {} \n", .{token.is(.keyword_if)});

    switch (token) {
        .keyword_if => std.debug.print("if keyword \n", .{}),
        .keyword_switch => std.debug.print("switch keyword \n", .{}),
        .digit => |value| std.debug.print("digit value : {} \n", .{value}),
    }

    token = .{ .digit = 42 };

    switch (token) {
        .keyword_if => std.debug.print("if keyword \n", .{}),
        .keyword_switch => std.debug.print("switch keyword \n", .{}),
        .digit => |value| std.debug.print("digit value : {} \n", .{value}),
    }

    // useful "optional chaining"
    if (token == .digit and token.digit == 42) std.debug.print("one liner \n", .{});
}
