test_that("magick to ayab creates desired width and length transformation", {
  expect_equal(
    magick::rose |>
    rayab::magick_to_ayab(width = 10) |>
    magick::image_info() |>
    dplyr::pull(width)
    , 10)
  expect_equal(
    magick::rose |>
      rayab::magick_to_ayab(height = 20) |>
      magick::image_info() |>
      dplyr::pull(height)
    , 20)
  expect_equal(
    magick::rose |>
      rayab::magick_to_ayab(width = 10, height = 20) |>
      magick::image_info() |>
      dplyr::pull(height)
    , 20)
  expect_equal(
    magick::rose |>
      rayab::magick_to_ayab(width = 10, height = 20) |>
      magick::image_info() |>
      dplyr::pull(width)
    , 10)
})

test_that("ggplot to ayab creates desired width and length transformation", {
  expect_equal(
    make_test_plot() |>
      rayab::ggplot_to_ayab(width = 10) |>
      magick::image_info() |>
      dplyr::pull(width)
    , 10)
  expect_equal(
    make_test_plot() |>
      rayab::ggplot_to_ayab(height = 20) |>
      magick::image_info() |>
      dplyr::pull(height)
    , 20)
  expect_equal(
    make_test_plot() |>
      rayab::ggplot_to_ayab(width = 10, height = 20) |>
      magick::image_info() |>
      dplyr::pull(height)
    , 20)
  expect_equal(
    make_test_plot() |>
      rayab::ggplot_to_ayab(width = 10, height = 20) |>
      magick::image_info() |>
      dplyr::pull(width)
    , 10)
})
