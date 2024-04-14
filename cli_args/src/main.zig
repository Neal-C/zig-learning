const std = @import("std");
const io = std.io;
const process = std.process;
// zig fetch --save git+https://github.com/Hejsil/zig-clap/#HEAD
// zig fetch --save https://github.com/Hejsil/zig-clap/archive/refs/tags/0.7.0.tar.gz
const clap = @import("clap");
// zig build-exe --name zig-clap.exe src/main.zig

// error: no module named 'clap' available within module main
// const clap = @import("clap");


pub fn main() !void {
    var no_alloc_needed_process_args_iterator = process.args();

    // the 1st arg is the name of the binary
    std.debug.print("binary name: {s}\n", .{no_alloc_needed_process_args_iterator.next().?});

    var index: usize = 1;

    // The rest of the arguments, are the ones passed to the program
    // as strings
    while (no_alloc_needed_process_args_iterator.next()) |arg| : (index += 1) {
        std.debug.print("arg n°{}: {s}\n", .{ index, arg });
    }

    std.debug.print("windows code", .{});

    // Windows requires memory allocation for command line arguments
    var buffer: [1024]u8 = undefined;
    var fixedBufferAllocator = std.heap.FixedBufferAllocator.init(&buffer);
    // fixedBufferAllocator is stack memory, so it doesn't need to be deinit
    // it's cleaned up when stackframe returns

    const allocator = fixedBufferAllocator.allocator();

    var allocated_process_args_iterator = try process.argsWithAllocator(allocator);
    // free allocated resources when finished
    defer allocated_process_args_iterator.deinit();

    std.debug.print("windows binary name {s}", .{allocated_process_args_iterator.next().?});

    var windows_index: usize = 1;

    while (allocated_process_args_iterator.next()) |arg| : (windows_index += 1) {
        std.debug.print("windows arg n°{}: {s}", .{ windows_index, arg });
    }

    std.debug.print("zig-clap code, inspired by the Clap crate of rust ecosystem", .{});

    // Specify the flags that the program can take
    const params = comptime clap.parseParamsComptime(
        \\-h --help                 Display this help message and explicit
        \\-n --number <usize>       An option parameter, which takes a value
        \\-s --string <str> ...     A flag/option parameter, which can be specified multiple times
        \\<str> ...
        \\
    );

    // clap.parsers.default is used, but it's possible to make its own parser
    var response = clap.parse(clap.Help, &params, clap.parsers.default, .{
        .diagnostic = null,
        // text/string parsing requires allocation, cuz strings costs memory
        .allocator = allocator,
    }) catch {
        clap.help(io.getStdErr().writer(), clap.Help, &params, .{});
    };

    defer response.deinit();

    if (response.args.help != 0)
        std.debug.print("--help\n", .{});
    if (response.args.number) |n|
        std.debug.print("--number = {}\n", .{n});
    for (response.args.string) |s|
        std.debug.print("--string = {s}\n", .{s});
    for (response.positionals) |pos|
        std.debug.print("{s}\n", .{pos});
}
