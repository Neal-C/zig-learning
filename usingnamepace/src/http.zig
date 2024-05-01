//! A simple little HTTP library.

/// An HTTP Request.
pub fn Request(comptime timeout: usize) type {
    return struct {
        method: enum { get, post, put, delete },
        path: []const u8,
        body: ?[]const u8,
        timeout: usize = timeout,

        const Self = @This();

        pub usingnamespace if (timeout > 0)
            struct {
                pub fn getTimeout(self: Self) usize {
                    return self.timeout;
                }
            }
        else
            struct {};
    };
}