#' Validate Colors
#'
#' @param color A character vector containing colors to validate.
#' @param name_color Optional name of the argument being validated.
#'
#' @return Returns hex codes, if all colors are valid.
#'
#' @keywords internal
validate_color <- function(color, name_color=NULL) {
  
  if (!is.null(name_color) &&
      is.character(name_color) &&
       length(name_color) == 1L &&
       !is.na(name_color)) {
    color_name <- paste0(" provided for `", name_color, "`")
  }else{
      color_name <- ""}
  
  rgb <- tryCatch({
      grDevices::col2rgb(color)},
    error = function(e){
        stop("`", paste(color, collapse = "`, `"), "`", color_name," is no valid color.", call.= FALSE)})
  
  hex_color <- grDevices::rgb(
    red = rgb[1, ],
    green = rgb[2, ],
    blue = rgb[3, ],
    maxColorValue = 255)
  
  return(hex_color)}