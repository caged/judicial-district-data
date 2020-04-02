DROP TABLE IF EXISTS intersections_with_threshold;

CREATE TABLE intersections_with_threshold AS (
  SELECT
    p.geoid,
    p.name,
    p.namelsad,
    p.countyfp,
    p.statefp,
    n.fid,
    n.abbr,
    n.district,
    n.district_n
 , CASE
   WHEN ST_CoveredBy(p.shape, n.shape)
   THEN ST_SetSRID(p.shape, 4269)
   ELSE
    ST_SetSRID(ST_Multi(
      ST_Intersection(p.shape,n.shape)
      ), 4269) END AS geom
 FROM acs_2017_5yr_county AS p
   INNER JOIN us_district_court_jurisdictions AS n
    ON (ST_Intersects(p.shape, n.shape)
      AND NOT ST_Touches(p.shape, n.shape) )
  WHERE ST_Area(ST_Intersection(p.shape, n.shape)) > 0.00261)