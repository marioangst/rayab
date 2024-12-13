% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/core.R
\name{magick_to_ayab}
\alias{magick_to_ayab}
\title{Process magick image object for ayab knitting}
\usage{
magick_to_ayab(fig, width = NULL, height = NULL, bw_method = NULL)
}
\arguments{
\item{fig}{A magick image object}

\item{width}{The desired output width in pixels}

\item{height}{The desired output height in pixels}

\item{bw_method}{One of "threshold" or "quantize" (default).
There are two black and white conversion methods, because
how well the conversion works depends a bit on the properties of the image
given as input (especially colors). The two methods are "quantize" and
"threshold".}
}
\value{
A magick image object
}
\description{
This function processes a magick image object to be suitable for knitting
with ayab. It pixelates the image and then converts it to the desired
width and height. Remember, one pixel is one stitch.
}
