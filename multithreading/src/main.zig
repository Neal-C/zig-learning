const std = @import("std");

fn work(id: usize) void {
    std.time.sleep(std.time.ns_per_s * 1);
    std.debug.print("{} finished \n", .{id});
}

// zig build && time ./zig-out/bin/multithreading

pub fn main() !void {
    const cpus = try std.Thread.getCpuCount();

    // No Threading
    // for (0..cpus) |n| {
    //     work(n);
    // }

    // Manual Threading
    // I am hardcoding my own number of CPUs
    // else, it will break
    // var threadHandles: [12]std.Thread = undefined;

    // for (0..cpus) |n| {
    //     threadHandles[n] = try std.Thread.spawn(.{}, work, .{n});
    // }

    // for (threadHandles) |handle| handle.join();


        // Manual threading with detach.
    // for (0..cpus) |i| {
    //     var handle = try std.Thread.spawn(.{}, work, .{i});
    //     handle.detach();
    // }
    //
    // std.time.sleep(1001 * std.time.ns_per_ms);

    // Thread pool.
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var pool: std.Thread.Pool = undefined;
    try pool.init(.{ .allocator = allocator });
    defer pool.deinit();

    for (0..cpus) |i| {
        try pool.spawn(work, .{i});
    }
}

