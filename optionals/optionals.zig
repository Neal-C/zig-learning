const std = @import("std");

pub fn main() anyerror!void {
	var maybe : ?u8 = null;
	
	std.debug.print("maybe: {?} \n", .{maybe});
	maybe = 42;
	std.debug.print("maybe: {?} \n", .{maybe});

	// using ? to assert the optional is not null and extract its payload
	// will return an error if null
	const i_retrieve_it_yolo = maybe.?;
	_ = i_retrieve_it_yolo;

	const i_retrieve_the_value_will_null_safety_sealbet = maybe orelse 28;
	_ = i_retrieve_the_value_will_null_safety_sealbet;


	if (maybe) |_| {
		std.debug.print("maybe is not null \n", .{});
	}


	if (maybe == null){
		std.debug.print("maybe is null :'( \n", .{});
	}

	if (maybe != null) std.debug.print("one liner \n", .{});

	const retrieved_with_if_expression :u8 = if (maybe) |value| value else 24;
	_ = retrieved_with_if_expression;

	const one_liner_check: u8 = if (maybe != null and maybe != 42 ) 22 + 22 else 100;
	_ = one_liner_check;
}