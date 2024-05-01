const std = @import("std");

pub fn main() !void {
    // Not using mutexes for values across Threads, can cause:
    // - dirty reads
    // - phantom reads

    // Mutexes are a synchronisation mechanism for multithreading
    // they're also called 'Exclusive locks'

    // As opposed to
    // RwLocks
    // RwLocks have a little bit of a performance cost compared to Mutexes
    // because they need to keep state
    // but it's compensated when you know your read/write patterns
    // example: a lot of readers, for a few writes

    // RwLocks can save speed performance and avoid 'lock retention', where a thread could read
    // but does not because an exclusive lock is used
    // So RwLocks allow threads that are exclusively reading to share their readLock
}

