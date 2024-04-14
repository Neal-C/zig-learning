const std = @import("std");
const fmt = std.fmt;
const filesystem = std.fs;
const io = std.io;

fn populate(directory: *filesystem.Dir) !void {
    for (0..3) |i| {

        // format file name.
        var buf: [8]u8 = undefined;
        const filename = try fmt.bufPrint(&buf, "file_{}", .{i});
        // Create a file
        var file = try directory.createFile(filename, .{});
        // close file on exit
        // Operating systems impose limits on the number of files open at the same time
        // and also RAM usage, I guess
        defer file.close();
        // buffer the writes for much better performance
        // batching write syscalls
        var buf_writer = io.bufferedWriter(file.writer());

        const writer = buf_writer.writer();

        _ = try writer.print("This is file_{}", .{i});

        try buf_writer.flush();
    }
}

pub fn main() !void {
    var sub_directory_2 = try filesystem.cwd().makeOpenPath("test_directory/sub_directory_1/sub_directory_2", .{});

    // Cleanup on exit
    defer filesystem.cwd().deleteTree("test_directory") catch |err| {
        std.debug.print("error deleting directory tree: {}", .{err});
    };
    // close directory resource when finished
    defer sub_directory_2.close();

    // populating with files
    try populate(&sub_directory_2);

    var sub_directory_1 = try filesystem.cwd().openDir("test_directory/sub_directory_1", .{});

    defer sub_directory_1.close();

    try populate(&sub_directory_1);

    // an allocator is needed to walk the tree
    const generalPurposeAllocatorType = std.heap.GeneralPurposeAllocator(.{});

    var generalPurposeAllocator = generalPurposeAllocatorType{};

    defer _ = generalPurposeAllocator.deinit();

    const allocator = generalPurposeAllocator.allocator();
    // walk the tree
    // 1. obtain a iterable version of the directory tree
    // var iterableDirectory = try filesystem.cwd().openDir("test_directory", .{});
    // ! newer api => openIterableDir is no longer a thing, pass a config struct instead
    var iterableDirectory = try filesystem.cwd().openDir("test_directory", .{ .iterate = true });
    defer iterableDirectory.close();

    var walker = try iterableDirectory.walk(allocator);
    defer walker.deinit();

    while (try walker.next()) |entry| {
        std.debug.print("Entry: {s}; kinds : {s}: ", .{ entry.path, @tagName(entry.kind) });

        // entry.kind = .file ; would also work, and be shorter to write
        // than std.fs.Dir.Entry.Kind.file
        if (entry.kind == .file) {
            // open file via its parent directory
            var file = try entry.dir.openFile(entry.basename, .{});
            defer file.close();
            // Buffer the reader for better performance
            // Batch read system calls, or "syscalls"
            var buf_reader = io.bufferedReader(file.reader());

            var reader = buf_reader.reader();

            var buffer: [4096]u8 = undefined;

            while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
                // ! Do not ever depend on traversal order, it changes from OS to OS and time to time, and implementation to implementation and futures versions of OS
                std.debug.print("{s}", .{line});
            }
        }

        std.debug.print("\n", .{});
    }
}
