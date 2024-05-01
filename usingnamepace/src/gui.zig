//! A simple little GUI library.

const std = @import("std");

pub const Widget = union(enum) {
    window: Window,
    button: Button,

    pub fn draw(self: Widget) void {
        switch (self) {
            inline else => |it| it.draw(),
        }
    }
};

/// A simple little window.
pub const Window = struct {
    title: []const u8,
    width: u16,
    height: u16,

    pub fn draw(self: Window) void {
        std.debug.print("Drawing {s} on the screen!\n", .{self.title});
    }
};

/// A simple little button.
pub const Button = struct {
    label: []const u8,
    width: u16,
    height: u16,

    pub fn draw(self: Button) void {
        std.debug.print("Drawing {s} on the screen!\n", .{self.label});
    }
};