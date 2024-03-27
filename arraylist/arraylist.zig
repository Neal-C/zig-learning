const std = @import("std");

pub fn main() !void {
    var generalPurposeAllocator = std.head.generalPurposeAllocator(.{}){};
    defer _ = generalPurposeAllocator.deinit();

    var list = std.ArrayList(u8).init(generalPurposeAllocator.allocator());
    defer list.deinit();

	for ("Hello, World!") |byte| try list.append(byte);
    printList(list);


    try list.append('\n'); // push
    printList(list);
    _ = list.pop();
    printList(list);

    // Use it like a writer if it's an u8 list.
    const writer = list.writer();
    _ = try writer.print(" Writing to an ArrayLIst: {}", .{42});
    printList(list);

    // iterator.
    while (list.popOrNull()) |byte| std.debug.print("{c} ", .{byte});
    std.debug.print("\n\n", .{});
    printList(list);

    // Append a slice.
    try list.appendSlice("Hello, World!");
    printList(list);

    // Ordered remove. Returns removed item.
    // Shifts items over. O(N)
    _ = list.orderedRemove(5);
    printList(list);

    // Swap remove. Moves last item into new slot. O(1)
    _ = list.swapRemove(5);
    printList(list);

    // ArrayList is just a handy wrapper of functionality
    // around a slice of items. You can still work with the
    // slice directly.
    list.items[5] = ' ';
    printList(list);

    // You can clear the list and obtain the items as an
    // owned slice which you must free.
    const slice = try list.toOwnedSlice();
    defer generalPurposeAllocator.allocator().free(slice);
    printList(list);

    list = try std.ArrayList(u8).initCapacity(generalPurposeAllocator.allocator(), 12);

    for ("Hello") |byte| list.appendAssumeCapacity(byte);
    std.debug.print("len: {}, cap: {}\n", .{ list.items.len, list.capacity });
    printList(list);

    
    const bytes = try gatherBytes(generalPurposeAllocator.allocator(), "Hey there!");
    defer generalPurposeAllocator.allocator().free(bytes);
    std.debug.print("bytes: {s}\n", .{bytes});
}

fn printList(list: std.ArrayList(u8)) void {
    std.debug.print("list: ", .{});
    for (list.items) |item| std.debug.print("{c} ", .{item});
    std.debug.print("\n\n", .{});
}

fn gatherBytes(allocator: std.mem.Allocator, slice: []const u8) ![]u8 {
    var list = try std.ArrayList(u8).initCapacity(allocator, slice.len);
    defer list.deinit();
    for (slice) |byte| list.appendAssumeCapacity(byte);
    return try list.toOwnedSlice();
}
