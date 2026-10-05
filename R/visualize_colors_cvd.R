#' Visualize Colors Under Color Vision Deficiency
#'
#' Display a color palette as perceived with normal color vision and under
#' simulated protanopia, deuteranopia, and tritanopia.
#'
#' @param color_palette A character vector of colors in a format accepted by
#'   [grDevices::col2rgb()].
#' @param cvd_severity Numeric between 0 and 1 defining the severity of the 
#'   color vision deficiency.
#'
#' @return Invisibly returns a named list containing the original colors and
#'   their simulated appearance under protanopia, deuteranopia, and
#'   tritanopia.
#'
#' @details
#' Color vision deficiencies are simulated using the physiologically based
#' transformations implemented by the \pkg{colorspace} package.
#'
#' The function produces four horizontal color-bar plots showing the original
#' colors and their appearance under the three simulated color vision
#' deficiencies.
#'
#' @examples
#' color_palette <- create_color_range(c("#2166AC", "#B2182B"), 6)
#' visualize_colors_cvd(color_palette)
#'
#' @seealso
#' [colorspace::protan()], [colorspace::deutan()], [colorspace::tritan()]
#'
#' @export
visualize_colors_cvd <- function(color_palette, cvd_severity=1) {
  
  if (!is.character(color_palette) ||
      length(color_palette) < 1L ||
      anyNA(color_palette)) {
    stop("`color_palette` must be a non-empty character vector of colors.", call. = FALSE)}
  
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
  
  graphics::par(mfrow = c(4, 1), mar = c(1, 1, 2, 1))
  
  for (nm in names(cvd_color_palette)) {
    graphics::barplot(
      rep(1, length(color_palette)),
      col = cvd_color_palette[[nm]],
      border = NA,
      main = nm)}
  
  invisible(cvd_color_palette)}
