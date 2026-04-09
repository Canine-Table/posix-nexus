<?php

// WordPress is already loaded, so $wpdb exists.
global $wpdb;


require __DIR__ . '/../views/home.php';
/*
// Normalize the request path
$path = trim(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH), '/');

// Home page
if ($path === '') {
    require __DIR__ . '/views/home.php';
    return;
}

// Single post by slug
$post = $wpdb->get_row(
    $wpdb->prepare(
        "SELECT * FROM $wpdb->posts WHERE post_name = %s AND post_status = 'publish'",
        $path
    )
);

if ($post) {
    $GLOBALS['current_post'] = $post;
    require __DIR__ . '../views/single.php';
    return;
}

// 404 fallback
http_response_code(404);
require __DIR__ . '../views/404.php';

 */
