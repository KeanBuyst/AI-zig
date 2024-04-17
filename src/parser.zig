const zigimg = @import("zigimg");
const std = @import("std");

pub fn ParseImg(path: []const u8,allocator: std.mem.Allocator) ![]const u8 {
    const file = try std.fs.openFileAbsolute(path, .{});
    const image = try zigimg.Image.fromFile(allocator, &file);
    const interator = image.iterator();

    const bytes = [image.width * image.height]u8;

    const index = 0;
    while (interator.next()) |colour| : (index += 1) {
        const grayscale = 1.0 - (colour.r + colour.g + colour.b) / 3; // black is 1 now and 0 is white
        bytes[index] = @as(u8,@intFromFloat(std.math.pow(f32, grayscale, 4) * 255));
    }
    return bytes;
}