const std = @import("std");

var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();
const literal = "Ela <3";

pub fn changeStringLiteral() ![]const u8 {
    try stdout.print("Literal before allocPrint: {s}\n", .{literal});
    const res = try std.fmt.allocPrint(
        allocator,
        "New literal formatted with allocPrint -> old literal as input: {s}\n",
        .{literal},
    );
    try stdout.print("{s}", .{res});
    try stdout.flush();

    return res;
}

pub fn gpAllocator(input_num: u32) !*u32 {
    const p_num = try allocator.create(u32);
    p_num.* = @as(u32, input_num);
    return p_num;
} 

pub fn freeAlloc(ptr: *u32) void {
    allocator.destroy(ptr);
}
