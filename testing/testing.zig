const std = @import("std");

const testing = std.testing;

fn add(a: i32, b: i32) i32 {
    return a +| b;
}
// builtin testing, with tests close to the source
test "can add 2 and 2 " {
    try testing.expect(add(2, 2) == 4);
}

fn sub(a: i32, b: i32) i32 {
    return a -| b;
}

test "can substract 2 and 2 correctly" {
    try testing.expect(sub(2, 2) == 0);
}

const MyCustomError = error{WillForSureError};
fn failForSure() MyCustomError!void {
    return error.WillForSureError;
}
test "we want to make sure it can error and with the custom error" {
    try testing.expectError(error.WillForSureError, failForSure());
}

const StructAreContainers = struct {
    test "inside a struct, very close to source code" {
        try testing.expect(true);
    }
};

test "assertion library is builtin" {
	const one: u8 = 1;
	const usize_array = [3]usize{1, 2, 3};
	try testing.expectEqual(@as(u8, 1), one);
    try testing.expectEqualSlices(usize, &[_]usize{ 1, 2, 3 }, &usize_array);
    try testing.expectEqualStrings("Hello", "Hello");
}

test "skipping a test because testing is doubting" {
	return error.SkipZigTest;
}
