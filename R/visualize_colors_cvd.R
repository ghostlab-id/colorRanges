#' Visualize Colors along with Color Vision Deficiency Simulations
#'
#' Display a original color palette and the simulated palettes under
#' protanopia, deuteranopia, and tritanopia.
#'
#' @param color_palette A character vector of colors in a format accepted by
#'   [grDevices::col2rgb()].
#' @param cvd_severity Numeric between 0 and 1 defining the severity of the 
#'   color vision deficiency.
#' @param show_names Logical scalar indicating whether names of a named
#'   `color_palette` should be displayed below the color bars. Defaults to
#'   `TRUE`.
#'
#' @return Invisibly returns a named list containing the original colors and
#'   their simulated appearance under protanopia, deuteranopia, and
#'   tritanopia.
#'
#' @details
#' Color vision deficiencies are simulated using the transformations 
#' implemented by the \pkg{colorspace} package.
#'
#' The function produces four horizontal color-bar plots showing the original
#' colors and their appearance under the three simulated color vision
#' deficiencies. If a named `color_palette` is provided and `show_names = TRUE`, 
#' the color names are displayed below the corresponding color bars
#'
#' @examples
#' color_palette <- create_color_range(c("#2166AC", "#B2182B"), 6)
#' visualize_colors_cvd(color_palette)
#'
#' @seealso
#' [colorspace::protan()], [colorspace::deutan()], [colorspace::tritan()]
#'
#' @export
visualize_colors_cvd <- function(color_palette, cvd_severity=1, show_names =TRUE) {
  
  if (!is.logical(show_names) ||
      length(show_names) != 1L ||
      is.na(show_names)){
    stop("`show_names` must be `TRUE` or `FALSE`.", call. = FALSE)}
  
  if (!is.character(color_palette) ||
      length(color_palette) < 1L ||
      anyNA(color_palette)){
    stop("`color_palette` must be a non-empty character vector of colors.", call. = FALSE)}
  
  color_names <- names(color_palette)
  got_names <- show_names && !is.null(color_names) && any(nzchar(color_names))
      
  if (got_names){
      color_label <- color_names
      margins <- c(2, 1, 2, 1)
      label_positions <- c(3, 0.3, 0)
  }else{
      color_label <- rep("", length(color_palette))
      margins <- c(1, 1, 2, 1)
      label_positions <- c(3, 1, 0)}
  
  if (!is.numeric(cvd_severity) ||
      length(cvd_severity) != 1L ||
      is.na(cvd_severity) ||
      cvd_severity < 0 ||
      cvd_severity > 1) {
    stop("`cvd_severity` must be a single number between 0 and 1.", call. = FALSE)}
  
  old_par <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(old_par), add = TRUE)
  
  cvd_color_palette <- list(
    Original = color_palette,
    Protanopia = colorspace::protan(color_palette, severity = cvd_severity),
    Deuteranopia = colorspace::deutan(color_palette, severity = cvd_severity),
    Tritanopia = colorspace::tritan(color_palette, severity = cvd_severity))
  
  graphics::par(mfrow = c(4, 1), mar = margins, mgp=label_positions)
  
  for (nm in names(cvd_color_palette)){
    
    graphics::barplot(
      rep(1, length(color_palette)),
      col = cvd_color_palette[[nm]],
      border = NA,
      main = nm,
      names.arg = color_label,
      axes=FALSE)}
  
  invisible(cvd_color_palette)}
