const std = @import("std");

// This struct is not packed, so it uses 16 bytes (4 bytes added for data padding)
// in a MultiArrayList, it would use 12 bytes (no padding needed)
const NotPackedStruct = struct {
    // 2 bytes -> 2 x u8
    a: u16,
    // 8 bytes -> 8 x u8
    b: u64,
    // 2 bytes -> 2 x u8
    c: u16,
};

// Zig takes care of reordering the struct fields to put the largest fields first.
// so in an Array, the memory layout is : b (8 bytes), a (2 bytes), c (2 bytes) , [padding](4 bytes)

// However, the MultiArrayList will do a Struct of Arrays, putting each fields in its own array, and since each array will have elements of the same size => it won't need any data padding

// MultiArrayList is roughly, Rust's Vec or GO's slice (or ArrayList for Java fan boiis)

pub fn main() !void {

    // initialiaze
    var generalPurposeAllocator = std.heap.GeneralPurposeAllocator(.{}){};
    // deinitialize / cleanup on exit
    defer _ = generalPurposeAllocator.deinit();

    const allocator = generalPurposeAllocator.allocator();

    // initialize
    var multiArrayList = std.MultiArrayList(NotPackedStruct){};
    // deinitialize / cleanup on exit
    defer multiArrayList.deinit(allocator);

    // add an item, allocating if necessary, like GO's append
    try multiArrayList.append(allocator, .{ .a = 1, .b = 1, .c = 1 });

    // pre-allocate to add 2 more items
    try multiArrayList.ensureUnusedCapacity(allocator, 2);

    // the next 2 appends, can be done without the 'try' keyword
    multiArrayList.appendAssumeCapacity(.{ .a = 2, .b = 2, .c = 2 });
    multiArrayList.appendAssumeCapacity(.{ .a = 3, .b = 3, .c = 3 });

    // for performance, it's better to get a slice of all fields first
    // then call items method onto it
    // because .slice(), will pre-compute the slices for the fields

    const sliced = multiArrayList.slice();
    // comptime param : Field
    const a_fields = sliced.items(.a);
    const b_fields = sliced.items(.b);
    const c_fields = sliced.items(.c);

    for (a_fields, 0..) |a, index| std.debug.print("{}: .a = {}\n", .{ index, a });
    for (b_fields, 0..) |b, index| std.debug.print("{}: .a = {}\n", .{ index, b });
    for (c_fields, 0..) |c, index| std.debug.print("{}: .a = {}\n", .{ index, c });
    std.debug.print("\n", .{});

    const head = multiArrayList.pop();

    std.debug.print("head: {any} \n", .{head});
    std.debug.print("\n", .{});

    try multiArrayList.append(allocator, .{ .a = 5, .b = 5, .c = 5 });

    var index: usize = 1;

    while (multiArrayList.popOrNull()) |item| : (index += 1) {
        std.debug.print("items [{}]: {any}\n", .{ index, item });
    }
    std.debug.print("\n", .{});

    // if the backing structure is modified, the slices will not reflect the changes
    // the obtained slices will be invalidated

    // will print 3
    std.debug.print("a_fields.len: {} \n", .{a_fields.len});
    // will print 3
    std.debug.print("b_fields.len: {} \n", .{b_fields.len});
    // will print 3
    std.debug.print("c_fields.len: {} \n", .{c_fields.len});

    // but it's actually 0
    // will print 0
    std.debug.print("list len: {} \n", .{multiArrayList.items(.a).len});
}
