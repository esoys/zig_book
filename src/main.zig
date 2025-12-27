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


}

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
