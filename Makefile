.SECONDARY:

data/gpkg/%.gpkg:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar --exclude="._*" -xzm -C $(basename $@) -f $<

	for file in `find $(basename $@) -name '*.gdb'`; do \
		ogr2ogr -nlt PROMOTE_TO_MULTI -f GPKG -t_srs EPSG:4326 $(basename $@).gpkg $$file; \
		chmod 644 $(basename $@).gpkg; \
	done
	rm -rf $(basename $@)

data/gz/us-district-court-jurisdictions.zip:
	curl -L --remote-time "https://opendata.arcgis.com/datasets/ed086b05d8dc46eab574e0fecdcf0f1f_0.gdb?outSR=%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D" -o $@.download
	mv $@.download $@

data/gz/acs_2017_5yr_county.zip:
	curl -L "https://www2.census.gov/geo/tiger/TIGER_DP/2017ACS/ACS_2017_5YR_COUNTY.gdb.zip" -o $@.download
	mv $@.download $@

data/gpkg/judicial-districts.gpkg: data/gz/us-district-court-jurisdictions.zip

