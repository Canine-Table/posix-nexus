<?php

class NxSocket
{
    public static function host(string $h = '0.0.0.0'): string
    {
        return self::tryBind($h, 0) ? $h : '0.0.0.0';
    }

    public static function port(int $p = 0): int
    {
        return self::tryBind('0.0.0.0', $p) ? $p : 0;
    }

    private static function tryBind(string $host, int $port): bool
    {
        $sock = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);

        if ($sock === false) {
            return false;
        }

        // Equivalent to SO_REUSEADDR
        socket_set_option($sock, SOL_SOCKET, SO_REUSEADDR, 1);

        $ok = @socket_bind($sock, $host, $port);

        socket_close($sock);
        return $ok;
    }
}

