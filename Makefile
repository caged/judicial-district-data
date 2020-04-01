.SECONDARY:

data/gdb/%.gdb:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar --exclude="._*" -xzm -C $(basename $@) -f $<

# Dataset provided by Homeland Infrastructure Foundation-Level Data site.
# See https://hifld-geoplatform.opendata.arcgis.com/datasets/us-district-court-jurisdictions
data/gz/us-district-court-jurisdictions.zip:
	curl -L --remote-time "https://opendata.arcgis.com/datasets/ed086b05d8dc46eab574e0fecdcf0f1f_0.gdb?outSR=%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D" -o $@.download
	mv $@.download $@

# American Community Survey Data - Five year data
# See https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-data.html
data/gz/acs_2017_5yr_county.zip:
	curl -L "https://www2.census.gov/geo/tiger/TIGER_DP/2017ACS/ACS_2017_5YR_COUNTY.gdb.zip" -o $@.download
	mv $@.download $@

data/gdb/judicial_districts.gdb: data/gz/us-district-court-jurisdictions.zip
data/gdb/acs_2017_5yr_county.gdb: data/gz/acs_2017_5yr_county.zip
