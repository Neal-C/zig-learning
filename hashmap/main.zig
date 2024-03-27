const std = @import("std");

// Allocates memory for the email field.
const User = struct {
    allocator: std.mem.Allocator,
    id: usize,
    email: []u8,

    fn init(
        allocator: std.mem.Allocator,
        id: usize,
        email: []const u8,
    ) !User {
        return .{
            .allocator = allocator,
            .id = id,
            .email = try allocator.dupe(u8, email),
        };
    }

    fn deinit(self: *User) void {
        self.allocator.free(self.email);
    }
};

// In Memory Storage
const UserData = struct {
    map: std.AutoHashMap(usize, User),

    fn init(allocator: std.mem.Allocator) UserData {
        return .{ .map = std.AutoHashMap(usize, User).init(allocator) };
    }

    fn deinit(self: *UserData) void {
        self.map.deinit();
    }

    fn put(self: *UserData, user: User) !void {
        try self.map.put(user.id, user);
    }

    fn get(self: UserData, id: usize) ?User {
        return self.map.get(id);
    }

    fn del(self: *UserData, id: usize) ?User {
        return if (self.map.fetchRemove(id)) |kv| kv.value else null;
    }
};

pub fn main() !void {
    var generalPurposeAllocator = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = generalPurposeAllocator.deinit();
    const allocator = generalPurposeAllocator.allocator();

    var users = UserData.init(allocator);
    defer users.deinit();

    var john = try User.init(allocator, 1, "john@zig.io");
    defer john.deinit();
    try users.put(john);

    var alice = try User.init(allocator, 2, "alice@zig.io");
    defer alice.deinit();
    try users.put(alice);

    var bob = try User.init(allocator, 3, "bob@zig.io");
    defer bob.deinit();
    try users.put(bob);

    if (users.get(john.id)) |user| std.debug.print("got id: {}, email: {s}\n", .{ user.id, user.email });
    if (users.get(alice.id)) |user| std.debug.print("got id: {}, email: {s}\n", .{ user.id, user.email });
    if (users.get(bob.id)) |user| std.debug.print("got id: {}, email: {s}\n", .{ user.id, user.email });

    _ = users.del(bob.id);
    if (users.get(bob.id)) |user| std.debug.print("got id: {}, email: {s}\n", .{ user.id, user.email });

    std.debug.print("count: {}\n", .{users.map.count()});

    std.debug.print("contains alice? {}\n", .{users.map.contains(alice.id)});

    var entry_iter = users.map.iterator();
    while (entry_iter.next()) |entry| {
        std.debug.print("id: {}, email: {s}\n", .{ entry.key_ptr.*, entry.value_ptr.email });
    }

    const getOrPutResultUnion = try users.map.getOrPut(bob.id);
    if (!getOrPutResultUnion.found_existing) getOrPutResultUnion.value_ptr.* = bob;

    std.debug.print("contains bob? {}\n", .{users.map.contains(bob.id)});
    if (users.get(bob.id)) |user| std.debug.print("got id: {}, email: {s}\n", .{ user.id, user.email });

    // If you need a set of unique items, you can create a
    // hash map with void value type.
	// And it will effectively be a Set, 
	// So it's why there's no built-in Set data structure in Zig
    var primes = std.AutoHashMap(usize, void).init(allocator);
    defer primes.deinit();

    try primes.put(5, {});
    try primes.put(7, {});
    try primes.put(7, {});
    try primes.put(5, {});

    std.debug.print("primes in map: {}\n", .{primes.count()});
    std.debug.print("primes contains 5? {}\n", .{primes.contains(5)});
}
