
make_test_plot <- function(){
  test_coords <-
    expand.grid(x = c(1:30), y = c(1:60))
  test_coords$color <- rbinom(n = nrow(test_coords),
                              size = 1, prob = 0.4)
  test_coords$color <- as.factor(ifelse(test_coords$color == 1, "black","white"))
  test_coords |>
    ggplot2::ggplot(ggplot2::aes(fill = color, x = x, y = y)) +
    ggplot2::geom_tile() +
    ggplot2::scale_fill_manual(values = c("black","white"))
}

make_test_plot_complex <- function(){
  nile_flow <- data.frame(flow = as.matrix(Nile),
                          year = time(Nile))
  nile_flow$crocodiles <- sample(c("big","small","none"),
                                 size = nrow(nile_flow),
                                 replace = TRUE)
  ggplot2::ggplot(nile_flow, ggplot2::aes(x = year, y = flow, color = crocodiles)) +
    ggplot2::geom_point(size = 5)
}

make_test_plot_complex_lines <- function(){
  nile_flow <- data.frame(flow = as.matrix(Nile),
                          year = stats::time(Nile))
  nile_flow$crocodiles <- sample(c("big","small","none"),
                                 size = nrow(nile_flow),
                                 replace = TRUE)
  ggplot2::ggplot(nile_flow, ggplot2::aes(x = year, y = flow, color = crocodiles)) +
    ggplot2::geom_line(linewidth = 2)
}

ggplot_void <- function(p){
  p_void <-
    p +
    ggplot2::scale_x_continuous(expand = c(0, 0)) +
    ggplot2::scale_y_continuous(expand = c(0, 0)) +
    ggplot2::theme_void() +
    ggplot2::theme(legend.position="none")
  return(p_void)
}

make_text_img <- function(input_text){
  magick::image_read(glue::glue("label:{input_text}"))
}

magick_ayab <- function(fig,
                        width = NULL,
                        height = NULL,
                        bw_method = NULL){
  BW_METHODS <- c("quantize","threshold")
  if(is.null(bw_method) || !(bw_method %in% BW_METHODS)){
    logger::log_info(glue::glue('bw_method must be one of {glue::glue_collapse(BW_METHODS, sep = "; ")}.
                                Setting to default (quantize)'))
    bw_method = "quantize"
  }
  if(is.null(width)){
    logger::log_info("Using 60px as default width conversion")
    width <- 60
  }
  info <- magick::image_info(fig)
  img_scale <- info$width/info$height
  # set output height by default based on ratio of orginal image
  if (is.null(height)){
    height <- info$width*img_scale
  }
  logger::log_info(glue::glue("Using {height} as height conversion"))
  # scale and make black and white
  if (bw_method == "quantize"){
    fig_scaled_bw <-
      magick::image_scale(fig,glue::glue("{width}x{height}")) |>
      magick::image_quantize(max = 2, colorspace = "Gray")
  }
  if (bw_method == "threshold"){
    fig_scaled_bw <-
      magick::image_scale(fig,glue::glue("{width}x{height}")) |>
      magick::image_convert(type = "Bilevel") |>
      magick::image_threshold(type = "black", threshold = "50%") |>
      magick::image_threshold(type = "white", threshold = "50%")
  }
  # upscale again to make pixelated, if original image was larger
  if(info$width > width | info$height > height){
    fig_pixelated <- magick::image_scale(fig_scaled_bw,
                                         glue::glue("{info$width}x{info$height}"))
  }
  # else, just keep enlarged
  else{
    fig_pixelated <- fig_scaled_bw
  }
  # and now, output with the given dimensions (force with !):
  fig_pixelated |>
    magick::image_scale(geometry = glue::glue("{width}x{height}!"))
}

ggplot_to_magick <- function(p){
  fig <- magick::image_graph(width = 300)
  print(p)
  dev.off()
  return(fig)
}

ggplot_to_ayab <- function(p,
                           width = NULL,
                           height = NULL,
                           bw_method = NULL){
  p |>
    ggplot_void() |>
    ggplot_to_magick() |>
    magick_ayab(width = width,
                height = height,
                bw_method = bw_method)
}

text_to_ayab <- function(input_text,
                         width = NULL,
                         height = NULL){
  input_text |>
    make_text_img() |>
    magick_ayab(width = width,
                height = height)
}

save_ayab_png <- function(fig, filename){
  magick::image_write(fig,
                      path = filename,
                      format = "png")
}

