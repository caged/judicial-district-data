WITH
bad_geometries AS (SELECT
  (a.p_geom).path[1] AS path,
  (a.p_geom).geom
FROM
  (
    SELECT
      st_dump(shape) AS p_geom
    FROM
      us_district_court_jurisdictions
    WHERE
      fid = 57
  ) a),
good_geometries AS (
  SELECT shape AS geom
  FROM us_district_court_jurisdictions
  WHERE
  fid = 58
),
movable_polygon AS (SELECT * FROM bad_geometries WHERE path = 1),
retained_polygon AS (SELECT * FROM bad_geometries WHERE path = 2)

UPDATE us_district_court_jurisdictions set shape = CASE
    WHEN fid = 58 THEN st_multi(st_union(shape, m.geom))
    WHEN fid = 57 THEN st_multi(r.geom)
  END
  FROM movable_polygon m, retained_polygon r
  WHERE fid IN (57, 58)

