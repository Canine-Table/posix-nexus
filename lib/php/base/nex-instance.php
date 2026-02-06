<?php

class NxInstance
{
	public function start()
	{
		$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
		if ($path === '/') {
			readfile(__DIR__ . '/../templates/index.html');
			exit;
		}
		http_response_code(404);
		echo "Not Found";
	}
}

