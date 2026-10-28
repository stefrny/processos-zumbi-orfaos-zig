const std = @import("std");

extern "c" fn fork() c_int;
extern "c" fn sleep(seconds: c_uint) c_uint;
extern "c" fn getpid() c_int;
extern "c" fn getppid() c_int;
extern "c" fn _exit(status: c_int) noreturn;

pub fn main() void {
    const pid = fork();

    if (pid < 0) {
        std.debug.print("Erro ao criar processo.\n", .{});
        return;
    }

    if (pid == 0) {
        // Processo filho
        std.debug.print(
            "Filho iniciado: PID = {d}, PPID = {d}.\n",
            .{ getpid(), getppid() },
        );

        std.debug.print(
            "Filho aguardando 5 segundos.\n",
            .{},
        );

        _ = sleep(5);

        std.debug.print(
            "Filho após a espera: PID = {d}, novo PPID = {d}.\n",
            .{ getpid(), getppid() },
        );

        _exit(0);
    } else {
        // Processo pai
        std.debug.print(
            "Pai: PID = {d}, filho PID = {d}.\n",
            .{ getpid(), pid },
        );

        std.debug.print(
            "Pai terminando antes do filho.\n",
            .{},
        );

        _exit(0);
    }
}
