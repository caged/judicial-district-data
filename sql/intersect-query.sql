CREATE TABLE intersections_with_threshold AS (SELECT p.geoid, p.namelsad, n.fid, n.abbr, n.district, n.district_n
 , CASE
   WHEN ST_CoveredBy(p.shape, n.geom)
   THEN p.shape
   ELSE
    ST_Multi(
      ST_Intersection(p.shape,n.geom)
      ) END AS geom
 FROM acs_2017_5yr_county AS p
   INNER JOIN us_district_court_fixed AS n
    ON (ST_Intersects(p.shape, n.geom)
      AND NOT ST_Touches(p.shape, n.geom) )
  WHERE ST_Area(ST_Intersection(p.shape, n.geom)) > 0.00261)