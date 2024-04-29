const std = @import("std");

pub fn main() !void {
    // Vectors can only be booleans, integers, floats, or pointers
    // Vectors are created with the @Vector builtin

    const vector_of_booleans: @Vector(3, bool) = @Vector(3, bool){ true, false, true };
    // tuple initialization
    std.debug.print("vector of booleans : {} \n\n", .{vector_of_booleans});

    // Supports array indexing
    std.debug.print("vector_of_booleans[0] : {} \n\n", .{vector_of_booleans[0]});

    const anoter_vector_of_booleans: @Vector(3, bool) = .{ true, false, true };
    std.debug.print("another vector of booleans : {} \n\n", .{anoter_vector_of_booleans});

    const array_of_booleans: [3]bool = [_]bool{ true, false, true };
    std.debug.print("array of booleans : {any} \n\n", .{array_of_booleans});

    // array coercion
    const coerced_array_into_vector: @Vector(3, bool) = array_of_booleans;

    // How does this not resul into a bool ?
    // results into a @Vector(3, bool) that is the result of comparing each
    // element to its index counterpart in the other vector
    // vector_of_booleans[n] == coerced_array_into_vector
    // where n is the index
    // If the CPU supports SIMD, then it's performed with SIMD (parrallel computation)
    const mystery = vector_of_booleans == coerced_array_into_vector;

    std.debug.print("mystery ? {} : {any} \n\n", .{
        @TypeOf(mystery),
        mystery,
    });

    const coerced_back_into_array: [3]bool = mystery;

    std.debug.print("coerced_back_into_array ? {} : {any} \n\n", .{
        @TypeOf(coerced_back_into_array),
        coerced_back_into_array,
    });

    // Arithmetic operations on vectors

    const below_five_complements = @Vector(3, u8){ 2, 3, 4 };
    const above_five_complements = @Vector(3, u8){ 8, 7, 6 };

    // 2 + 8
    // 3 + 7
    // 4 + 6
    const all_tens = below_five_complements + above_five_complements;

    std.debug.print("all tens: {any} \n\n", .{all_tens});

    // Use @splat to turn a scalar into a vector
    // @Vector(3, u8){2,2,2}
    const vector_of_twos: @Vector(3, u8) = @splat(2);

    // 10 * 2
    // 10 * 2
    // 10 * 2
    const vector_of_twenty = all_tens * vector_of_twos;

    std.debug.print("all twenties : {any} \n\n", .{vector_of_twenty});

    // Use @reduce to obtain a scalar from a vector
    // Supported operations : .Or , .And, .Xor, .Min, .Max, .Mul

    const all_true = @reduce(std.builtin.ReduceOp.And, vector_of_booleans);
    std.debug.print("all true : {any} \n\n", .{all_true});

    const any_true = @reduce(.Or, vector_of_booleans);
    std.debug.print("any true : {any} \n\n", .{any_true});

    // To shuffle within a single vector, pass undefined as the second vector argument
    // Notice that we can re-order, duplicate, omit elements in the input vector

    const a = @Vector(7, u8){ 'o', 'l', 'h', 'e', 'r', 'z', 'w' };

    // they're basically indexes
    const mask1 = @Vector(5, i32){ 2, 3, 1, 1, 0 };

    const result1: @Vector(5, u8) = @shuffle(u8, a, undefined, mask1);

    // coercing into a const [5]u8
    // then taking a reference to it, effectively turning it into a slice of u8
    // and slice of u8 in zig land, are strings
    // hence the {s} format specifier
    std.debug.print("result1 : {s} \n\n", .{&@as([5]u8, result1)});

    // combining 2 vectors
    const b = @Vector(4, u8){ 'w', 'd', '!', 'x' };

    // They're basically indexes,
    // if positive value => select from the 1st vector
    // if negative value => select from the 2nd vector
    // -1 = 1st element of the 2nd vector !
    // -3 = 3rd element of the 2nd vector
    // 0 counts as positive
    // 0 = 1st element of the 1st vector
    // 4 = 5th element of the 1st vector
    const mask2 = @Vector(6, i32){ -1, 0, 4, 1, -2, -3 };

    const result2: @Vector(6, u8) = @shuffle(u8, a, b, mask2);
    std.debug.print("result2 : {s} \n\n", .{&@as([6]u8, result2)});

    // @select works like shuffle, but with booleans
    // true => select from 1st vector
    // false => selects from 2nd vector

    const c = @Vector(4, u8){ 'x', 'i', 'j', 'd' };
    const d = @Vector(4, u8){ 's', 'b', 'm', 'z' };

    // s , i, m, d
    const mask_of_booleans = @Vector(4, bool){ false, true, false, true };

    // s, i, m, d
    const result3: @Vector(4, u8) = @select(u8, mask_of_booleans, c, d);
    std.debug.print("result3 : {s} \n\n", .{&@as([4]u8, result3)});

    // SIMD asciiCaselessEqualityCheck
    std.debug.print("a == A: {} \n\n", .{asciiCaselessEql('a', 'A')});
}

fn asciiCaselessEql(a: u8, b: u8) bool {
    // check if ascii letters
    std.debug.assert(std.ascii.isAlphabetic(a) and std.ascii.isAlphabetic(b));

    // check if exact equality
    if (a == b) return true;

    // Create vectors for comparison
    const a_vector: @Vector(2, u8) = .{ a, a };
    // ^ 0x20 flips the case
    const b_vector: @Vector(2, u8) = .{ b, b ^ 0x20 };

    // Compare
    const table = a_vector == b_vector;

    // Reduce to scalar value
    return @reduce(.Or, table);
}
