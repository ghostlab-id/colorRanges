# Assign Related Colors to Subcategories

Assign color ranges to subcategories nested within broader categories.
Each parent category is associated with one or two colors, from which
the required number of subtype colors is generated.

## Usage

``` r
assign_color_ranges(
  item_list,
  color_palette,
  fallback_color = NULL,
  single_color = "middle"
)
```

## Arguments

- item_list:

  A named list. Each element contains the names of the subcategories
  belonging to one parent category.

- color_palette:

  A named list of color specifications. Names should correspond to names
  in `item_list`. Each element should contain one or two colors accepted
  by
  [`create_color_range()`](https://ghostlab-id.github.io/colorRanges/reference/create_color_range.md).

- fallback_color:

  Optional, a single color used for items for which no corresponding
  color palette is provided. If `NULL` (default), items without a
  corresponding palette are omitted from the returned list.

- single_color:

  Character string defining which color is returned when `n = 1` and two
  endpoint colors are supplied. One of `"middle"` (default), returning
  the color between both endpoints; `"first"`, returning the first
  endpoint; or `"last"`, returning the second endpoint.

## Value

A named list with one element per parent category. Each element is a
named character vector mapping subcategory names to colors. Items
without a corresponding palette may be omitted depending on
`fallback_color`, and empty items are always omitted.

## Details

For each parent category represented in `color_palette`, the number of
required colors is determined from the corresponding element of
`item_list`, and a color range is generated with
[`create_color_range()`](https://ghostlab-id.github.io/colorRanges/reference/create_color_range.md).

Empty items in `item_list` will be omitted.

If no `fallback_color` is specified items in `item_list` without a
corresponding color specification will be omitted. I a valid color for
`fallback_color` is specified, these items will get assigned this color.

## Examples

``` r
item_set <- list(
  item1 = c("var1", "var2", "var3", "var4"),
  item2 = c("varA", "varB", "varC"))

palettes <- list(
  item1 = c("#FFF7BC", "#D95F0E"),
  item2 = c("#DEEBF7", "#08519C"))

assign_color_ranges(item_list = item_set, color_palette = palettes)
#> $item1
#>      var1      var2      var3      var4 
#> "#FFF7BC" "#F2C482" "#E69248" "#D95F0E" 
#> 
#> $item2
#>      varA      varB      varC 
#> "#DEEBF7" "#739ECA" "#08519C" 
#> 
```
