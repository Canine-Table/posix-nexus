<?php

function nex_enqueue_assets() {
    wp_enqueue_style(
        'nex-style',
        get_stylesheet_uri(), // loads style.css
        [],
        filemtime(get_stylesheet_directory() . '/css/style.css')
    );
}

function my_theme_scripts() {
    wp_enqueue_script(
        'my-module-script',
        get_stylesheet_directory_uri() . '/mjs/script.mjs',
        array(),
        null,
        true
    );
}

add_action('wp_enqueue_scripts', 'my_theme_scripts');
add_action('wp_enqueue_scripts', 'nex_enqueue_assets');


function add_module_type_to_scripts($tag, $handle, $src) {
    if ($handle === 'my-module-script') {
        return '<script type="module" src="' . esc_url($src) . '"></script>';
    }
    return $tag;
}

add_filter('script_loader_tag', 'add_module_type_to_scripts', 10, 3);

