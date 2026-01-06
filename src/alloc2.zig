const std = @import("std");
const io = std.testing.io;

var stdin_buffer: [1024]u8 = undefined;
var stdin_reader = std.fs.File.stdin().reader(io, &stdin_buffer);
const stdin = &stdin_reader.interface;


//pub fn allocAndFree() !void {
//    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
//    const allocator = gpa.allocator();
//
//   var input = try allocator.alloc(u8, 50); 
     defer allocator.free(input);
    //@memset(input[0..], 0);
//
//
    //const stream = try stdin.takeDelimiterExclusive('\n');
    //@memcpy(input[0..stream.len], stream[0..]);
//
    //std.debug.print("allocAndFree input: {s}\n", .{input});
//}
