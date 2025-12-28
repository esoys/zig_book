const std = @import("std");

var stdout_buffer: [1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub const User = struct {
    id: u64,
    name: []const u8,
    email: []const u8,


    pub fn init(id: u64, name: []const u8, email: []const u8) User {
        return User {
            .id = id,
            .name = name,
            .email = email,
        };
    }


    pub fn print_name(self: User) !void {
        try stdout.print("struct User name: {s}\n", .{self.name});
        try stdout.flush();
    }
};

pub const Vec3 = struct {
    x: f64,
    y: f64,
    z: f64,


    pub fn distance(self: Vec3, other: Vec3) f64 {
        const xd = std.math.pow(f64, self.x - other.x, 2.0);
        const yd = std.math.pow(f64, self.y - other.y, 2.0);
        const zd = std.math.pow(f64, self.z - other.z, 2.0);
        return std.math.sqrt(xd + yd + zd);
    }

    pub fn double(self: *Vec3) void {
        self.x *= 2;
        self.y *= 2;
        self.z *= 2;
    }

    pub fn triple(self: *Vec3) void {
        self.x *= 3;
        self.y *= 3;
        self.z *= 3;
    }
};

pub const Square = struct{
    x: i32,
    y: i32,

    pub fn area(self: Square) i32 {
        return self.x * self.y;
    }
};  
