const std = @import("std");

var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const gpa_allocator = gpa.allocator();
const literal = "Ela <3";

pub fn changeStringLiteral() ![]const u8 {
    try stdout.print("Literal before allocPrint: {s}\n", .{literal});
    const res = try std.fmt.allocPrint(
        gpa_allocator,
        "New literal formatted with allocPrint -> old literal as input: {s}\n",
        .{literal},
    );
    try stdout.print("{s}", .{res});
    try stdout.flush();

    return res;
}

pub fn gpAllocator(input_num: u32) !*u32 {
    const p_num = try gpa_allocator.create(u32);
    p_num.* = @as(u32, input_num);
    return p_num;
} 

pub fn freeAlloc(ptr: *u32) void {
    gpa_allocator.destroy(ptr);
}


pub fn bufferAlloc() !void {
    var buffer: [5]u8 = undefined;
    for (0..buffer.len) |i| {
        buffer[i] = 0;
    }
    std.debug.print("Fixed Buffer Allocator:\n -- Buffer size: {d}\n", .{buffer.len});
    
    for (0..buffer.len) |i| { 
        std.debug.print(" -- Buffer[{d}] before alloc: {X}\n", .{i, buffer[i]});
    }

    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    var fba_allocator = fba.allocator();

    const input = try fba_allocator.alloc(u8, 5);
    for (0..buffer.len) |i| { 
        std.debug.print(" -- Buffer[{d}] after alloc: {X}\n", .{i, buffer[i]});
    }
    defer fba_allocator.free(input);
}
