CREATE TABLE IF NOT EXISTS NxErrorNxPools (
  Id INTEGER PRIMARY KEY,
  Name TEXT NOT NULL,
  Description TEXT
);

CREATE TABLE IF NOT EXISTS NxErrorNxGroups (
  Id INTEGER PRIMARY KEY,
  PoolId INTEGER NOT NULL,
  Message TEXT NOT NULL,
  FOREIGN KEY (PoolId) REFERENCES NxErrorNxPools(Id)
);

INSERT OR IGNORE INTO NxErrorNxPools (Name, Description) VALUES
	('CommandNotFound', 'Missing binaries or uninstalled tools'),
	('SocketFailure', 'No socket, no lease, no link');

INSERT OR IGNORE INTO NxErrorNxGroups (PoolId, Message) VALUES
	(192, 'mkfifo not found! The realm of named pipes is closed to us.'),
	(192, 'psql not found! The gates to PostgreSQL are sealed.'),
	(192, 'ffmpeg not found! The forge of media transmutation lies cold.'),
	(192, 'curl not found! The tendrils of HTTP cannot reach the outer world.'),
	(192, 'tar not found! The scrolls cannot be sealed—no archive, no ritual.'),
	(192, 'ping not found! The echo cannot travel—no pulse, no reply.'),
	(192, 'git not found! The lineage of commits is broken—no ancestry, no merge.'),
	(192, 'rsync not found! The mirror is shattered—no reflection, no sync.'),
	(192, 'jq not found! The glyph parser sleeps—no structure, no clarity.'),
	(192, 'awk not found! The pattern priest is absent—no match, no invocation.'),
	(192, 'sed not found! The stream cannot be rewritten—no substitution, no flow.'),
	(192, 'ps not found! The census of processes is lost—no presence, no ritual.'),
	(192, 'top not found! The altar of activity is blind—no glyphs, no motion.'),
	(192, 'whoami not found! The spirit cannot name itself—no identity, no invocation.'),
	(192, 'ls not found! The chamber is dark—no listing, no revelation.');

