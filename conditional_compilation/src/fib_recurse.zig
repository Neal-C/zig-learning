// recursive fibonacci

pub fn fib(n: usize) usize {
    if (n < 2) return n; // exit condition
    return fib(n - 1) + fib(n - 2); // recurse calls
}
