<?php
declare(strict_types=1);

namespace Nx;

function get_asset_paths(string $baseUri, string $basePath): array {
	return [
		'css' => [
			'handle' => 'nx-style',
			'uri' => $baseUri . 'style.css',
			'ver' => filemtime($basePath . 'style.css')
		],
		'js' => [
			'handle' => 'nx-script',
			'uri' => $baseUri . 'script.mjs',
			'ver' => filemtime($basePath . 'script.mjs'),
			'type' => 'module'
		],
	];
}

