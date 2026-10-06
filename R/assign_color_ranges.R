#' Assign Related Colors to Subcategories
#'
#' Assign color ranges to subcategories nested within broader categories.
#' Each parent category is associated with one or two colors, from which the
#' required number of subtype colors is generated.
#'
#' @param item_list A named list. Each element contains the names of
#'   the subcategories belonging to one parent category.
#' @param color_palette A named list of color specifications. Names should 
#'   correspond to names in `item_list`. Each element should contain one or 
#'   two colors accepted by [create_color_range()].
#' @param fallback_color Optional, a single color used for items for which no
#'   corresponding color palette is provided. If `NULL` (default), items
#'   without a corresponding palette are omitted from the returned list.
#' @param single_color Character string defining which color is returned when
#'   `n = 1` and two endpoint colors are supplied. One of `"middle"` (default),
#'   returning the color between both endpoints; `"first"`, returning the 
#'   first endpoint; or `"last"`, returning the second endpoint.
#'   
#' @return A named list with one element per parent category. Each element is
#'   a named character vector mapping subcategory names to colors. Items 
#'   without a corresponding palette may be omitted depending on 
#'   `fallback_color`, and empty items are always omitted.
#'
#' @details
#' For each parent category represented in `color_palette`, the number of required
#' colors is determined from the corresponding element of
#' `item_list`, and a color range is generated with [create_color_range()].
#'
#' Empty items in `item_list` will be omitted. 
#' 
#' If no `fallback_color` is specified items in `item_list` without a 
#' corresponding color specification will be omitted. I a valid color for 
#' `fallback_color` is specified, these items will get assigned this color.
#'
#' @examples
#' item_set <- list(
#'   item1 = c("var1", "var2", "var3", "var4"),
#'   item2 = c("varA", "varB", "varC"))
#'
#' palettes <- list(
#'   item1 = c("#FFF7BC", "#D95F0E"),
#'   item2 = c("#DEEBF7", "#08519C"))
#' 
#' assign_color_ranges(item_list = item_set, color_palette = palettes)
#'
#' @export
assign_color_ranges <- function(item_list, color_palette, 
                                fallback_color=NULL, single_color = "middle") {
  
  # validate single_color
  single_color <- match.arg(single_color, choices = c("first", "last", "middle"))
  
  # validate item_list & color_palette
  if (!is.list(item_list) || !is.list(color_palette)){
    stop("`item_list` and `color_palette` are expected to be named list objects.")}
  
  names_list <- names(item_list)
  if (is.null(names_list) || anyNA(names_list) || any(names_list == "") || anyDuplicated(names_list)){
    stop("`item_list` must contain unique & non-empty names for all elements.", call. = FALSE)}
  names_list <- names(color_palette)
  if (is.null(names_list) || anyNA(names_list) || any(names_list == "") || anyDuplicated(names_list)){
    stop("`color_palette` must contain unique & non-empty names for all elements.", call. = FALSE)}
  
  # Validate fallback color
  if (!is.null(fallback_color)){
    
    if (!is.character(fallback_color) ||
       length(fallback_color) != 1L ||
       is.na(fallback_color)) {
    stop("`fallback_color` must be `NULL` or a single color.", call. = FALSE)}

  fallback_color <- validate_colors(color = fallback_color, name_color = "fallback_color")}
    
  # Remove empty items
  empty_items <- names(item_list)[lengths(item_list) == 0L]
  
  if (length(empty_items) > 0L) {
    warning("Dropping empty items: ", paste(empty_items, collapse = ", "), ".", call. = FALSE)
    item_list <- item_list[lengths(item_list) > 0L]}
  
  if (length(item_list) == 0L){
    stop("Empty item list.")}

  # items without color palette
  missing_colors <- setdiff(names(item_list), names(color_palette))
  if (length(missing_colors) > 0L){
    if (!is.null(fallback_color)){
      warning("No `color_palette` specified for: ",
        paste(missing_colors, collapse = ", "), ". 
        \nUsing fallback color ", fallback_color, ".", call. = FALSE)}
    if (is.null(fallback_color)){
      warning("Dropping items without a `color_palette` specification: ", 
        paste(missing_colors, collapse = ", "), ".", call. = FALSE)
      
      item_list <- item_list[!names(item_list) %in% missing_colors]}}

  # Assign colors
  item_colors <- lapply(names(item_list), function(item_name) {
    item_ID <- item_list[[item_name]]
    if (item_name %in% names(color_palette)) {
      cols <- create_color_range(
        color_palette = color_palette[[item_name]],
        n = length(item_ID), single_color = single_color)
    }else{
      cols <- rep(fallback_color, length(item_ID))}
    
    stats::setNames(cols, item_ID)})
  
  names(item_colors) <- names(item_list)
  
  return(item_colors)}
