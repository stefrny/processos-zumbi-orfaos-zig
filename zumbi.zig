const std = @import("std");
	
extern "c" fn fork() c_int;
extern "c" fn sleep(seconds: c_uint) c_uint;
extern "c" fn waitpid(pid: c_int, status: ?*c_int, options: c_int) c_int;
extern "c" fn getpid() c_int;
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
            "Filho: PID = {d}. Vou terminar agora.\n",
            .{getpid()},
        );

        _exit(0);
    } else {
        // Processo pai
        std.debug.print(
            "Pai: PID = {d}, filho PID = {d}.\n",
            .{ getpid(), pid },
        );

        std.debug.print(
            "Pai aguardando 20 segundos sem coletar o estado do filho.\n",
            .{},
        );

        // Permite observar o filho zumbi.
        _ = sleep(20);

        var status: c_int = 0;
	const resultado = waitpid(pid, &status, 0);

	if (resultado == pid) {
    		std.debug.print("Filho coletado com sucesso.\n", .{});
	} else {
    		std.debug.print(
        	"Erro em waitpid: retorno = {d}.\n",
        	.{resultado},
    		);
	}

        std.debug.print(
           "Pai coletou o estado de saída do filho.\n",
            .{},
        );
    }
}
