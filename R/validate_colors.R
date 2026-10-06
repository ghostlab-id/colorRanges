#' Validate a Color Vector 
#'
#' @param color A character vector containing colors to validate.
#' @param name_color Optional name of the argument being validated.
#'
#' @return Returns hex codes, if all colors are valid.
#'
#' @export
validate_colors <- function(color, name_color=NULL) {
  
  if (!is.character(color) ||
      length(color) < 1L ||
      anyNA(color)) {
    stop("`color` must be a non-empty character vector without missing values.", call. = FALSE)}
  
  color_names <- names(color)
  
  if (!is.null(name_color) &&
      is.character(name_color) &&
       length(name_color) == 1L &&
       !is.na(name_color)) {
    color_info <- paste0(" provided for `", name_color, "`")
  }else{
      color_info <- ""}
  
  rgb <- tryCatch({
      grDevices::col2rgb(color)},
    error = function(e){
        stop("`", paste(color, collapse = "`, `"), "`", color_info," contains an invalid color specification.", call.= FALSE)})
  
  hex_color <- grDevices::rgb(
    red = rgb[1, ],
    green = rgb[2, ],
    blue = rgb[3, ],
    maxColorValue = 255)
  
  names(hex_color) <- color_names
  
  return(hex_color)}