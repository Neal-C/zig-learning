// iterative loop fibonacci

pub fn fib(n: usize) usize {
    if (n < 2) return n;

    var a: usize = 0;
    var b: usize = 1;
    var index: usize = 0;

    while (index < n) : (index += 1) {
        const tmp = a;
        a = b;
        b = tmp + b;
    }

	return a;
}
