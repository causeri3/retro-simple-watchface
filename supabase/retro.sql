CREATE TABLE retro (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  device_id TEXT NOT NULL,
  part_no TEXT DEFAULT 'unknown',
  event TEXT NOT NULL,
  ts TIMESTAMPTZ NOT NULL,
  data JSONB DEFAULT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX ON retro (device_id);
CREATE INDEX ON retro (event);
CREATE INDEX ON retro (ts);
CREATE UNIQUE INDEX ON retro (device_id, event, ts);