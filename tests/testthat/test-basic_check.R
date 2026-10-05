########################
# create_color_range() #
########################

# number of colors
test_that("create_color_range() creates the requested number of colors", {
  
  expect_equal(create_color_range("#FF0000", 3), rep("#FF0000", 3))
  
  expect_length(create_color_range(c("#000000", "#FFFFFF"), 10), 10)})

# single_color
test_that("single_color resolves & selects the requested position", {
  
  color_palette <- c("#000000", "#FFFFFF")
expect_equal(create_color_range(color_palette, 1, single_color = "first"), "#000000")

expect_equal(create_color_range(color_palette, 1, single_color = "last"), "#FFFFFF")

expect_equal(create_color_range(color_palette, 1),
  colorspace::hex(colorspace::mixcolor(0.5,
                         colorspace::hex2RGB("#000000"),
                         colorspace::hex2RGB("#FFFFFF"))))

expect_error(create_color_range(color_palette, 1, single_color = "abc"))})

# invalid input
test_that("create_color_range() rejects invalid inputs", {
  color_palette <- c("#000000", "#FFFFFF")
  expect_error(create_color_range(c("red", "green", "blue"), 3))
  expect_error(create_color_range(color_palette, 0))
  expect_error(create_color_range(color_palette, -1))
  expect_error(create_color_range(color_palette, 1.5))
  expect_error(create_color_range(color_palette, NA))
  expect_error(create_color_range(color_palette, c(2, 3)))})

#########################
# assign_color_ranges() #
#########################

# correct number of colors
test_that("Set of variables is assigned to correct number of colors", {
  item_set <- list(
    item1 = c("var1", "var2", "var3", "var4"),
    item2 = c("varA", "varB", "varC"))
  
  palettes <- list(
    item1 = c("#FFF7BC", "#D95F0E"),
    item2 = c("#DEEBF7", "#08519C"))
  
  item_colors <- assign_color_ranges(item_list = item_set, color_palette = palettes)
  
  expect_length(item_colors, length(item_set))
  expect_equal(names(item_colors), names(item_set))
  
  expect_length(item_colors[["item1"]], length(item_set[["item1"]]))
  expect_length(item_colors[["item2"]], length(item_set[["item2"]]))
  
  expect_equal(names(item_colors[["item1"]]), item_set[["item1"]])
  
  expect_equal(names(item_colors[["item2"]]), item_set[["item2"]])})

# resolves 1 and 2 items 
test_that("assign_color_ranges() resolves 1 and 2 items as expected", {
  color_palette <- c("#000000", "#FFFFFF")
  item_set <- list(A = "a",
                B = c("a", "b"))
  
  palettes <- list(A = color_palette,
                   B = color_palette)
  
  first <- assign_color_ranges(item_list = item_set, color_palette = palettes, single_color = "first")
  middle <- assign_color_ranges(item_list = item_set, color_palette = palettes, single_color = "middle")
  last <- assign_color_ranges(item_list = item_set, color_palette = palettes, single_color = "last")
  
  expect_equal(first$A, c(a = "#000000"))
  expect_equal(middle$A, c(a = colorspace::hex(
    colorspace::mixcolor(0.5, colorspace::hex2RGB("#000000"),colorspace::hex2RGB("#FFFFFF")))))
  expect_equal(last$A, c(a = "#FFFFFF"))
  
  b_cols <- c(a = "#000000",
              b = "#FFFFFF")
  
  expect_equal(first$B, b_cols)
  expect_equal(middle$B, b_cols)
  expect_equal(last$B, b_cols)})

# fallback_color
test_that("assign_color_ranges() uses fallback colors", {
  
  item_set <- list(
    A = c("a", "b"),
    B = c("c", "d"))
  
  palettes <- list(
    A = c("#000000", "#FFFFFF"))
  
  expect_warning(
    result <- assign_color_ranges(
      item_list = item_set,
      color_palette = palettes,
      fallback_color = "#FF0000"))
  
  expect_equal(result$B, c(c = "#FF0000", d = "#FF0000"))
  
  expect_warning(
    result <- assign_color_ranges(item_set, palettes),
    "Dropping items")
  
  expect_named(result, "A")
  expect_false("B" %in% names(result))})

test_that("Empty items are dropped & colors are converted to hex codes", {
  
  item_set <- list(
    A = character(0),
    B = c("b1", "b2"))
  
  palettes <- list(
    A = c("red", "blue"),
    B = c("black", "white"))
  
  expect_warning(
    result <- assign_color_ranges(
      item_set,
      palettes,
      fallback_color = "grey"),
    "empty items")
  
  expect_false("A" %in% names(result))
  expect_true("B" %in% names(result))
  
  expect_equal(result$B,
    c(b1 = "#000000", 
      b2= "#FFFFFF"))})

##########################
# visualize_colors_cvd() #
##########################

# availibility of cvd simulations
test_that("visualize_colors_cvd() returns all CVD simulations", {
  color_palette <- c("#000000", "#FFFFFF")
  
  result <- visualize_colors_cvd(color_palette= color_palette)
  expect_type(result, "list")
  
  expect_named(
    result,
    c("Original",
      "Protanopia",
      "Deuteranopia",
      "Tritanopia"))
  
  expect_equal(result$Original, color_palette)
  
  expect_true(all(lengths(result) == length(color_palette)))})

# cvd_severity examples
test_that("CVD severity rejects invalid values & zero retains original colors", {
  
  color_palette <- c("#FF0000", "#0000FF")
    
  expect_error(visualize_colors_cvd(color_palette = color_palette, cvd_severity = -0.1))
  
  expect_error(visualize_colors_cvd(color_palette = color_palette, cvd_severity = 1.1))
  
  result <- visualize_colors_cvd(color_palette = color_palette, cvd_severity = 0)
  
  expect_equal(result$Protanopia, color_palette)
  expect_equal(result$Deuteranopia, color_palette)
  expect_equal(result$Tritanopia, color_palette)})
