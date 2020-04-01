WITH
bad_geometries as (SELECT
  (a.p_geom).path[1] as path,
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
good_geometries as (
  SELECT shape as geom
  FROM us_district_court_jurisdictions
  where
  fid = 58
),
movable_polygon as (select * from bad_geometries where path = 1),
retained_polygon as (select * from bad_geometries where path = 2)

update us_district_court_jurisdictions set shape = CASE
    WHEN fid = 58 THEN st_multi(st_union(shape, m.geom))
    WHEN fid = 57 THEN st_multi(r.geom)
  END
  FROM movable_polygon m, retained_polygon r
  WHERE fid IN (57, 58)

