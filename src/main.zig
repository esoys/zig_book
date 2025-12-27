const std = @import("std");

pub fn main() !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;
    
    try stdout.print("--- Welcome to the zig book {s} ---\n", .{"codealong!"});
    try stdout.flush();

    try stdout.print("1. labled scope\n", .{});
    try stdout.flush();

    var y: i32 = 120;
    // durch break statemant wird der wert nach ende des scopes (in dem fall y) wie nach funktion returned
    const x: i32 = add_one: {
        y += 1;
    break :add_one y;
    };

    try stdout.print("  x: {d}, y: {d}\n", .{x, y});
    try stdout.flush();

    const arr = [2]u8 {1, 2};
    const p_arr: *const [2]u8 = &arr;
    try stdout.print("type of i32: {}, type of arr: {}, typeof p_arr: {}, val of p_arr (hex): {X}\n", .{@TypeOf(x), @TypeOf(arr), @TypeOf(p_arr), p_arr});
    try stdout.flush();

    // CHAPTER 2: Control Flow
    try stdout.print("2. Control FLow\n", .{});
    try stdout.flush();
}
