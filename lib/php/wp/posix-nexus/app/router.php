<?php

global $wpdb;

// Normalize the request path
$path = trim(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH), '/');

// Fetch latest posts (with date!)
$posts = $wpdb->get_results("
    SELECT ID, post_title, post_name, post_date
    FROM $wpdb->posts
    WHERE post_status='publish'
    AND post_type='post'
    ORDER BY post_date DESC
    LIMIT 20
");

$GLOBALS['posts'] = $posts;

// Try to load a single post by slug
$post = $wpdb->get_row(
    $wpdb->prepare(
        "SELECT * FROM $wpdb->posts WHERE post_name = %s AND post_status = 'publish'",
        $path
    )
);

// Home page
if ($path === '') {
    require __DIR__ . '/../templates/home.php';
    return;
}

// Add Post page
if ($path === 'add-post') {

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {

        $title   = sanitize_text_field($_POST['title']);
        $content = wp_kses_post($_POST['content']);

        // timestamps
        $now     = current_time('mysql');
        $now_gmt = current_time('mysql', 1);

        // Insert post
        $wpdb->insert(
            $wpdb->posts,
            [
                'post_title'        => $title,
                'post_content'      => $content,
                'post_status'       => 'publish',
                'post_type'         => 'post',
                'post_author'       => get_current_user_id(),

                'post_date'         => $now,
                'post_date_gmt'     => $now_gmt,
                'post_modified'     => $now,
                'post_modified_gmt' => $now_gmt,
            ]
        );

        header("Location: /");
        exit;
    }

    require __DIR__ . '/../views/add-post.php';
    return;
}

// Single post
if ($post) {
    $GLOBALS['current_post'] = $post;
    require __DIR__ . '/../views/single.php';
    return;
}

// 404
http_response_code(404);
require __DIR__ . '/../views/404.php';
