x: f32,
y: f32 = 0,

const Point = @This();

//Named spaced fn
pub fn new(x: f32, y: f32) Point {
    return .{ .x = x, .y = y };
}

//Method
pub fn distance(self: Point, other: Point) f32 {
    const differenceX = other.x - self.x;
    const differenceY = other.y - self.y;

    return @sqrt((differenceX * differenceX) + (differenceY * differenceY));
}
