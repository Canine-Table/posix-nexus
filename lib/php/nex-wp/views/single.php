<?php $post = $GLOBALS['current_post']; ?>
<!DOCTYPE html>
<html>
<head><title><?= esc_html($post->post_title) ?></title></head>
<body>
<h1><?= esc_html($post->post_title) ?></h1>
<div><?= apply_filters('the_content', $post->post_content) ?></div>
</body>
</html>

