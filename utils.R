library(sf)
library(sfheaders)
library(lwgeom)

st_linebounds = function(x) {
  coords = sfc_to_df(st_geometry(x))
  first_pair = !duplicated(coords[["sfg_id"]])
  last_pair = !duplicated(coords[["sfg_id"]], fromLast = TRUE)
  idxs = first_pair | last_pair
  pairs = coords[idxs, names(coords) %in% c("x", "y", "z", "m")]
  points = sfc_point(pairs)
  st_crs(points) = st_crs(x)
  points
}

st_displacement = function(x) {
  bounds = st_linebounds(x) 
  sources = bounds[seq(1, length(bounds) - 1, 2)]
  targets = bounds[seq(2, length(bounds), 2)]
  st_distance(sources, targets, by_element = TRUE)
}

st_circuity = function(x) {
  st_length(x) / st_displacement(x)
}

st_bearing = function(x) {
  bounds = st_linebounds(x)
  st_geod_azimuth(bounds)[seq(1, length(bounds), 2)]
}

st_crossings = function(x, y) {
  crosses = st_crosses(x, y)
  xcross = x[lengths(crosses) > 0, ]
  ycross = y[unique(do.call("c", crosses)), ]
  all_intersections = st_intersection(xcross, ycross)
  point_intersections = all_intersections[st_is(all_intersections, "POINT"), ]
  boundaries = c(st_linebounds(x), st_linebounds(y))
  is_boundary = lengths(st_equals(point_intersections, boundaries)) > 0
  point_intersections[!is_boundary, ]
}

st_linepoints = function(x) {
  pts = sfc_to_df(st_geometry(x))
  new_pts = sf_point(pts[names(pts) %in% c("x", "y", "z", "m")])
  new_pts$line_id = pts$linestring_id
  st_crs(new_pts) = st_crs(x)
  new_pts
}

st_lines_to_segments = function(x) {
  pts = sfc_to_df(st_geometry(x))
  is_startpoint = !duplicated(pts[["linestring_id"]])
  is_endpoint = !duplicated(pts[["linestring_id"]], fromLast = TRUE)
  src_pts = pts[!is_endpoint, ]
  trg_pts = pts[!is_startpoint, ]
  src_pts$segment_id = seq_len(nrow(src_pts))
  trg_pts$segment_id = seq_len(nrow(trg_pts))
  new_pts = rbind(src_pts, trg_pts)
  new_pts = new_pts[order(new_pts$segment_id), ]
  coords = new_pts[names(new_pts) %in% c("x", "y", "z", "m", "segment_id")]
  segments = sf_linestring(coords, linestring_id = "segment_id")
  segments$line_id = src_pts$linestring_id
  st_crs(segments) = st_crs(x)
  segments
}

st_points_to_segments = function(x, linestring_id = "linestring_id") {
  pts = sfc_to_df(st_geometry(x))
  pts$linestring_id = x[[linestring_id]]
  is_startpoint = !duplicated(pts[["linestring_id"]])
  is_endpoint = !duplicated(pts[["linestring_id"]], fromLast = TRUE)
  src_pts = pts[!is_endpoint, ]
  trg_pts = pts[!is_startpoint, ]
  src_pts$segment_id = seq_len(nrow(src_pts))
  trg_pts$segment_id = seq_len(nrow(trg_pts))
  new_pts = rbind(src_pts, trg_pts)
  new_pts = new_pts[order(new_pts$segment_id), ]
  coords = new_pts[names(new_pts) %in% c("x", "y", "z", "m", "segment_id")]
  segments = sf_linestring(coords, linestring_id = "segment_id")
  segments[[linestring_id]] = src_pts$linestring_id
  st_crs(segments) = st_crs(x)
  segments
}

st_as_tibble = function(x) {
  if (class(x)[1] != "sf") stop("x should be an sf object") 
  class(x) = c("sf", "tbl_df", "tbl", "data.frame")
  x
}
