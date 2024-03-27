const std = @import("std");

// the length of an array must be known at compile time / "comptime"

pub fn main() !void {

	const array_1 = [5]u8{0,1,2,3,4};
	std.debug.print("array_1: {any}, array_1.len: {} \n\n", .{ array_1, array_1.len});

	
	const inferred_array = [_]u8{ 0,1,2,3,4};
	std.debug.print("inferred_array: {any}, inferred_array.len: {} \n\n", .{ inferred_array, inferred_array.len});

	const repeated_array = [_]u8{0} ** 5;
	std.debug.print("repeated_array: {any}, repeated_array.len: {} \n\n", .{ repeated_array, repeated_array.len});

	// unknown values before hand, preparing memory space for later use
	var unkwon_values: [2]u8 = undefined;

	unkwon_values[0] = 0;
	unkwon_values[1] = 1;
	std.debug.print("unkwon_values: {any}, unkwon_values.len: {} \n\n", .{ unkwon_values, unkwon_values.len});

	// Matrixes

	const matrix : [2][2]u8 = .{ 
		.{1,2}, 
		.{3,4},
	};
	std.debug.print("matrix: {any}, matrix.len: {} \n\n", .{ matrix, matrix.len});

	// Sentinel termination
	const sentinel : [2:0]u8 = .{1,2};
	std.debug.print("sentinel: {any}, sentinel.len: {} \n", .{ sentinel, sentinel.len});


}