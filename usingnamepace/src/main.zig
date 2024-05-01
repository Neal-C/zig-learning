const std = @import("std");

// usingnamespace is basically Go's struct embedding

// Import all the libraries in a unified namespace
// called `libs`. Here we use a struct to do the same.
// const libs = struct {
//     usingnamespace @import("math.zig");
//     usingnamespace @import("gui.zig");
//     usingnamespace @import("http.zig");
// };

// Here we use a dedicated file to expose the unified API.
const libs = @import("libs.zig");

pub fn main() !void {
    // Use the math lib add function.
    std.debug.print("1 + 2 == {}\n", .{libs.add(1, 2)});

    // Use the gui lib widgets.
    const widgets = [_]libs.Widget{
        .{ .window = .{
            .title = "Gorillas",
            .width = 640,
            .height = 480,
        } },
        .{ .button = .{
            .label = "Fire!",
            .width = 100,
            .height = 40,
        } },
    };

    for (widgets) |widget| widget.draw();

    // Use the http lib request type.
    const RequestType = libs.Request(10);
    const req_with_timeout = RequestType{
        .method = .get,
        .path = "/index.html",
        .body = null,
    };

    if (@hasDecl(RequestType, "getTimeout")) {
        std.debug.print("timeout: {}\n", .{req_with_timeout.getTimeout()});
    }
}
