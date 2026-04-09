<?php
	global $wpdb;
	$posts = $wpdb->get_results("
		SELECT *
		FROM $wpdb->posts
		WHERE post_status='publish' AND post_type='post'
		ORDER BY post_date DESC
		LIMIT 10
	");
?>

<!DOCTYPE html>
<html>
	<head>
		<title>Home</title>
		<link rel="stylesheet" href="<?= get_stylesheet_directory_uri(); ?>/css/style.css">
	</head>
	<body>
		<div class="nx-table-wrapper">
			<table class="nx-table">
				<caption class="nx-caption">SQL‑Driven Home</caption>
				<thead>
					<tr>
						<td>ID</td>
						<td>Title</td>
						<td>Name</td>
						<td>Author</td>
						<td>Content</td>
						<td>Status</td>
						<td>Date</td>
					</tr>
				</thead>
				<?php foreach ($GLOBALS['posts'] as $p): ?>
					<tbody>
					<tr>
						<td>
								<?= esc_html($p->ID) ?>
						</td>
						<td>
							<a href="/<?= $p->post_name ?>">
								<?= esc_html($p->post_title) ?>
							</a>
						</td>
						<td>
								<?= esc_html($p->post_name) ?>
						</td>
						<td>
								<?= esc_html($p->post_author) ?>
						</td>
						<td>
								<?= esc_html($p->post_content) ?>
						</td>
						<td>
								<?= esc_html($p->post_status) ?>
						</td>
						<td>
								<?= esc_html($p->post_date) ?>
						</td>
					</tr>
					</tbody>
				<?php endforeach; ?>
			</table>
			<img src="https://raw.githubusercontent.com/Canine-Table/posix-nexus/refs/heads/main/img/posix-nexus-icon.png"/>
		</div>
	</body>
</html>

