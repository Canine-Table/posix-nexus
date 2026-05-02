<?php
declare(strict_types=1);

// 1. Load FIFO paths from .nx-path
$cfg = parse_ini_file(__DIR__ . '/.nx-path');
$ttin = $cfg['G_NEX_TTIN'];
$ttou = $cfg['G_NEX_TTOU'];

// 2. Open FIFOs
$in  = fopen($ttin, 'w');   // write commands
$out = fopen($ttou, 'r');   // read responses

// 3. Ask for NEXUS_LIB
fwrite($in, "ENVIRON<nx:null/>NEXUS_LIB\n");

// 4. Read the response
$nexus_lib = trim(fgets($out));

// 5. Load Nexus PHP runtime
require_once $nexus_lib . '/php/nex-init.php';

// 6. Continue with your app
require __DIR__ . '/templates/home.php';

