const std = @import("std");
const oop = @import("oop.zig");
const typ = @import("type.zig");
const allocs = @import("allocators.zig");

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
    try stdout.print("  type of i32: {}, type of arr: {}, typeof p_arr: {}, val of p_arr (hex): {X}\n", .{@TypeOf(x), @TypeOf(arr), @TypeOf(p_arr), p_arr});
    try stdout.flush();

    // CHAPTER 2: Control Flow
    try stdout.print("2. Control FLow\n", .{});
    try stdout.flush();

    // switch:
    const Role = enum {
        SE, DPE, DE, DA, PM, PO, KS
    };
    var area: []const u8 = undefined;
    const role: Role = Role.DE;

    // man kann mehrere Möglichkeiten in ein case packen und mit komma trennen
    // man muss das enum nicht spezifisch für jeden case nennen (kann man aber), zig inferred diesen automatisch -> . schreibweise reicht
    // alle möglichkeiten müssen betrachtet werden! in dem fall werden alle möglichkeiten des enums in betracht gezogen, ansonsten braucht man ein else statement
    switch (role) {
        .PM, .SE, .DPE, Role.PO => {
            area = "Platform";
        },
        .DE, .DA => {
            area = "Data & Analytics";
        },
        .KS => {
            area = "Sales";
        },
    }
    try stdout.print("  switch: {s}\n", .{area});
    try stdout.flush();

    const sw1: i32 = 69;
    var swO: []const u8 = undefined;

    swO = switch (sw1) {
        420, 69 => "cool",
        else => "not cool",
    };
    try stdout.print("  switch2: {s}\n", .{swO});
    try stdout.flush();

    const sw2: i32 = 25;
    const swO2 = switch (sw2) {
        0...25 => "low",
        26...50 => "medium",
        51...100 => "high",
        else => @panic("too high"),
    };
    try stdout.print("  switch3: {s}\n", .{swO2});
    try stdout.flush();


    //labeled switch statement
    // mit continue kann man den switch von vorne durchgehen mit dem neuen wert (der nach Endstatement des Labels ausgegeben wird)
    switch_label: switch (@as(u8, 1)) {
        1 => {
            try stdout.print("Labeled switch first branch\n", .{});
            continue :switch_label 2;
        },
        2 => {
            try stdout.print("Labeled switch second branch\n", .{});
            continue :switch_label 3;
        },
        else => {
            try stdout.print("Labeled switch umatched case, value: {d}\n", .{@as(u8, 3)});
            try stdout.flush();
        },
    }

    try deferCheck();
    errdefer std.debug.print(">>errdefer<<\n", .{});
    //try errdeferCheck();
    
    const name: []const u8 = "'Erik'";
    try stdout.print("{s}...\n", .{name});
    try stdout.print("  - in Hex: ", .{});

    for (name) |char| {
        try stdout.print("{X} ", .{char});
    }

    try stdout.print("\n", .{});

    try stdout.print("  - index:  ", .{});

    for (name, 0..) |_, i| {
        try stdout.print(" {d} ", .{i});
    }

    try stdout.print("\n", .{});
    try stdout.flush();


    var test_num: i32 = 4;
    p_add2(&test_num);
    try stdout.print("before add: 4, after: {d}\n", .{test_num});
    try stdout.flush();

    const new_user: oop.User = oop.User.init(1, "Erik", "e@mail.com");
    try new_user.print_name();

    // mit der punktschreibweise ".{...} erklärt man ein anonymes struct literal. durch den punkt davor wird der datatype durch den compiler inferred"
    // der compiler braucht aber hinweise auf den type, wie etwa die return signatur einer function, oder die anotation eines objekts (wie hier)
    const user_wo_init: oop.User = .{
        .id = 10,
        .name = "Soysal",
        .email = "mail@e.com",
    };
    try user_wo_init.print_name();

    const other_user = oop.User {
        .id = 2,
        .name = "kek",
        .email = "kek@mail.com",
    };
    try other_user.print_name();

    var vec1: oop.Vec3 = .{
        .x = 3,
        .y = 3,
        .z = 3,
    };

    const vec2: oop.Vec3 = .{
        .x = 1,
        .y = 1,
        .z = 1,
    };

    const sqr = oop.Square {
        .x = 5,
        .y = 6,
    };

    const sqr2: oop.Square = .{
        .x = 125,
        .y = 8,
    };

    try stdout.print("Square area 1: {d} | Square area 2: {d} | ", .{sqr.area(), sqr2.area()});
    try stdout.print("Distance Vectors: {d}\n", .{vec1.distance(vec2)});
    vec1.double();
    try stdout.print("Distance Vectors after double: {d}\n", .{vec1.distance(vec2)});
    vec1.triple();
    try stdout.print("Distance Vectors after triple: {d}\n", .{vec1.distance(vec2)});
    try stdout.flush();


    try typ.floatDiv(@as(f64, 20), @as(f64, 3));

    _ = try allocs.changeStringLiteral();

    const ptr: *u32 = try allocs.gpAllocator(25);
    const val_ptr: u32 = ptr.*;
    try stdout.print("Pointer adress: {*}, Pointer value: {d}\n", .{@as(*u32, ptr), val_ptr});
    try stdout.flush();

    allocs.freeAlloc(ptr);
    try allocs.bufferAlloc();
    try allocs.arenaAlloc();
}





////////////////////////////////////////////////////////////////////////////////////////////
fn deferCheck() !void {
    defer std.debug.print(">>function defer<<\n", .{});
    var i: i32 = 4;
    while (i > 0) : (i -= 1) {
        defer std.debug.print(">>loop defer<<\n", .{});
        std.debug.print("{d}...| ", .{i});
    }
    //expect function checkt ob der logische test (i == 0) true ist. Falls ja, macht die function nichts. ansonsten raised sie ein assertion error
    try std.testing.expect(i == 0);
}

fn errdeferCheck() !void { return error.TestError; }


// function params sind immutable, man kann sie aber verändern, wenn man stattdessen ein pointer weiter gibt
fn p_add2(x: *i32) void {
    x.* = x.* + 2;
}
