const std = @import("std");


const List = @import("linkedlist_with_arena.zig").List;

pub fn main() !void {
    // We use the GeneralPurposeAllocator for normal allocations.
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // defer _ = gpa.deinit();
    // const allocator = gpa.allocator();

    // We use the page_allocator as backing allocator for the
    // ArenaAllocator. page_allocator is not recommended for
    // normal allocations since it allocates a full page of
    // memory per allocation.
    const allocator = std.heap.page_allocator;

    const iterations: usize = 100;
    const item_count: usize = 1_000;

    var timer = try std.time.Timer.start();

    for (0..iterations) |_| {
        var list = try List(usize).init(allocator, 13);
        errdefer list.deinit();
        // Add items, allocating each time.
        for (0..item_count) |i| try list.append(i);
        // Free allocated memory. Once per item for
        // non-arena List; only once for arena List.
        list.deinit();
    }

    // Get elapsed time in milliseconds.
    var took: f64 = @floatFromInt(timer.read());
    took /= std.time.ns_per_ms;

    std.debug.print("took: {d:.2}ms\n", .{took});
}