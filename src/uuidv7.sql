-- SQLite
select
  -- timestamp
  format('%08x', ((strftime('%s') * 1000) >> 16)) || '-' ||
  format('%04x', ((strftime('%s') * 1000)
    + ((strftime('%f') * 1000) % 1000)) & 0xffff) || '-' ||
  -- version / rand_a
  format('%04x', 0x7000 + abs(random()) % 0x0fff) || '-' ||
  -- variant / rand_b
  format('%04x', 0x8000 + abs(random()) % 0x3fff) || '-' ||
  -- rand_b
  format('%012x', abs(random()) >> 16) as value;

-- PostgreSQL
select
  -- timestamp
  lpad(to_hex(((extract(epoch from now()) * 1000)::bigint >> 16)), 8, '0') || '-' ||
  lpad(to_hex(((extract(epoch from now()) * 1000
    + (date_part('milliseconds', now())::bigint % 1000))::bigint & 0xffff)), 4, '0') || '-' ||
  -- version / rand_a
  lpad(to_hex((0x7000 + (random() * 0x0fff)::int)), 4, '0') || '-' ||
  -- variant / rand_b
  lpad(to_hex((0x8000 + (random() * 0x3fff)::int)), 4, '0') || '-' ||
  -- rand_b
  lpad(to_hex((floor(random() * (2^48))::bigint >> 16)), 12, '0') AS value;
