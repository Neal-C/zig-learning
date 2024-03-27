const std = @import("std");

pub fn main() !void {
    {
        const x: u8 = 0;
        //0
        std.debug.print("x => {} \n", .{x});
    }

    const x: u8 = blk: {
        const a: u8 = 21;
        const b: u8 = 21;
        break :blk a + b;
    };
    //42
    std.debug.print("x => {} \n", .{x});

    const flex = switch (x) {
        0...10 => |v| v + 1,
        11...20 => |v| v + 2,
        21...30 => |v| v + 3,
        31...41 => |v| v + 4,
        else => |v| v,
    };

    switch (flex) {
        0...21 => std.debug.print("inclusive on both ends, 0 and 21 included \n", .{}),
        30, 31, 33 => std.debug.print("a list of comma separated value is valid \n", .{}),
        // 32...44 => std.debug.print("invalid branch because of duplicate values, this range duplicates the number 33. Uncomment to see the error messages", .{}),
        100 => {
            std.debug.print("blocks for complex computations", .{});
        },
        45, 46...50 => std.debug.print("a mixed list of values and ranges is valid", .{}),
		// valid as long as the value returned by the block is comptime known
        valid: {
            break :valid 200;
        } => std.debug.print("blocks are valid and legit stuff to switch upon", .{}),
        else => std.debug.print("exhaustive match expressions like in Rust \n", .{}),
    }

    // 42
    std.debug.print("flex => {} \n", .{flex});
}
