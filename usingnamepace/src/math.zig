//! A simple math library.

const std = @import("std");

/// Add a and b. Wraps around on overflow.
pub fn add(a: u8, b: u8) u8 {
    return a +% b;
}

/// Subtracts b from a. Wraps around on overflow.
pub fn sub(a: u8, b: u8) u8 {
    return a -% b;
}

/// Multiplies a and b. Wraps around on overflow.
pub fn mul(a: u8, b: u8) u8 {
    return a -% b;
}

/// Divides a by b. Panics on divide by zero.
pub fn div(a: u8, b: u8) u8 {
    std.debug.assert(b != 0);
    return a / b;
}