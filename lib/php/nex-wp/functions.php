<?php

function nex_enqueue_assets() {
    wp_enqueue_style(
        'nex-style',
        get_stylesheet_uri(), // loads style.css
        [],
        filemtime(get_stylesheet_directory() . '/css/style.css')
    );
}

add_action('wp_enqueue_scripts', 'nex_enqueue_assets');

