const std = @import("std");

var stdout_buffer: [1024]u8 = undefined; 
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;    

pub fn floatDiv(a: f64, b: f64) !void {
    try stdout.print("floatDiv result: {d}\n", .{a / b});
    try stdout.flush();
} 
