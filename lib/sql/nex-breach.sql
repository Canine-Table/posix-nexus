CREATE TABLE IF NOT EXISTS NxBreachRelay (
  LogLevel TEXT NOT NULL,
  ErrorGroup TEXT NOT NULL,
  ToneGroup TEXT NOT NULL,
  PRIMARY KEY (LogLevel, ErrorGroup, ToneGroup)
);

