<?php
declare(strict_types=1);

class NexusClient
{
    private string $ttin;
    private string $ttou;
    private $in;
    private $out;

    public function __construct(string $nxPathFile)
    {
        $cfg = parse_ini_file($nxPathFile);
        if (!$cfg || !isset($cfg['G_NEX_TTIN'], $cfg['G_NEX_TTOU'])) {
            throw new RuntimeException("Invalid .nx-path file");
        }

        $this->ttin = $cfg['G_NEX_TTIN'];
        $this->ttou = $cfg['G_NEX_TTOU'];

        // Open TTIN first (writer)
        $this->in = fopen($this->ttin, 'w');
        if (!$this->in) {
            throw new RuntimeException("Failed to open TTIN for writing");
        }

        // Open TTOU second (reader)
        $this->out = fopen($this->ttou, 'r');
        if (!$this->out) {
            throw new RuntimeException("Failed to open TTOU for reading");
        }
    }

    private function send(string $opcode, string $arg = ''): string
    {
        $line = $opcode . '<nx:null/>' . $arg . "\n";
        fwrite($this->in, $line);

        $resp = fgets($this->out);
        if ($resp === false) {
            throw new RuntimeException("Worker closed FIFO unexpectedly");
        }

        return trim($resp);
    }

    public function ping(): bool
    {
        return $this->send("PING") === "PONG";
    }

    public function getEnv(string $key): ?string
    {
        $val = $this->send("ENVIRON", $key);
        return $val === "BOUNCE" ? null : $val;
    }

    public function counter(): int
    {
        return (int)$this->send("COUNTER");
    }

    public function ttin(): string
    {
        return $this->send("TTIN");
    }

    public function ttou(): string
    {
        return $this->send("TTOU");
    }

    public function close(): void
    {
        fclose($this->in);
        fclose($this->out);
    }
}

$nx = new NexusClient(__DIR__ . '/.nx-path');

// Test handshake
if (!$nx->ping()) {
    throw new RuntimeException("Nexus worker not responding");
}

// Get NEXUS_LIB from worker (php-fpm safe)
$nexus_lib = $nx->getEnv("NEXUS_LIB");
if (!$nexus_lib) {
    throw new RuntimeException("NEXUS_LIB not available");
}

require_once $nexus_lib . '/php/nex-init.php';

// Continue with your app
require __DIR__ . '/templates/home.php';

