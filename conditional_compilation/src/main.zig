const std = @import("std");

const config = @import("config");

const fibonacciFn = @import("fibonacci").fib;

pub fn main() !void {
    // executable command lines processing
    // everything after `--`
    var args_iterator = std.process.args();

    _ = args_iterator.next(); // program's name

    const n: usize = if (args_iterator.next()) |arg| try std.fmt.parseInt(usize, arg, 10) else 7;

    const fibonacciFnType: []const u8 = if (config.use_loop) "loop" else "recursive";

    std.debug.print("\n\n {}th fibonacci ({s})", .{ n, fibonacciFnType, fibonacciFn(n) });
}
