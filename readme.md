[](./preview.png)

This is a set of god awful hacks to generate county-level data for judicial districts. See [this observable notebook](https://observablehq.com/@caged/the-united-states-courts-of-appeals-and-district-courts) for an interactive version.

### Old fragile stuff below

```shell
# Install system dependencies
brew install gdal postgis

# Install project dependencies
yarn

# Download datasets
make

# Import geodatabasess
./bin/import -d usa -g ./data/gdb/acs_2017_5yr_county/ACS_2017_5YR_COUNTY.gdb
./bin/import -d usa -g ./data/gdb/judicial_districts/7c787be41fc04bf6a4f47c3332367adc.gdb

# Fix bad data in jurisdictions
psql -f sql/fix-bad-polygon-in-jurisdictions.sql -d usa
psql -f sql/fix-bad-jurisdiction-data.sql -d usa

# Generate composite dataset with counties and jurisdictions
psql -f sql/intersect-query.sql -d usa

# Export data to new-line-delimited GeoJSON
./bin/export -d usa -t intersections_with_threshold -o counties-raw-ndjson.json

# Process into simplified TopoJSON
yarn topo
```
