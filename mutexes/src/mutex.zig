const std = @import("std");
const debug = std.debug;
const Mutex = std.Thread.Mutex;
const Thread = std.Thread;
const time = std.time;

const Counter = struct {
    lock: Mutex = .{},
    count: u8 = 0,

    fn increment(self: *Counter) void {
        self.lock.lock();
        defer self.lock.unlock();

        const before = self.count;
        time.sleep(250 * time.ns_per_ms);
        self.count +%= 1;
        debug.print("write count: {} -> {}\n, ", .{ before, self.count });
    }

    fn print(self: *Counter) void {
        self.lock.lock();
        defer self.lock.unlock();

        debug.print("read count: {}, ", .{self.count});
    }
};

fn incrementCounter(counter: *Counter) void {
    while (true) {
        time.sleep(500 * time.ns_per_ms);
        counter.increment();
    }
}

fn printCounter(counter: *Counter) void {
    while (true) {
        time.sleep(250 * time.ns_per_ms);
        counter.print();
    }
}

pub fn main() !void {
    var counter = Counter{};

    for (0..5) |_| {
        var thread = try Thread.spawn(.{}, incrementCounter, .{&counter});
        thread.detach();
    }
    for (0..100) |_| {
        var thread = try Thread.spawn(.{}, printCounter, .{&counter});
        thread.detach();
    }

    time.sleep(3 * time.ns_per_s);
    debug.print("\n", .{});
}