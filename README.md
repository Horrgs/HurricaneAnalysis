# HurricaneAnalysis
Analyzing tropical storms and hurricanes in the HURDAT2 dataset (1850-2020).

## Purpose

The purpose of this repo was a midterm project on a research question. My research was focused on the change in tropical storms
and hurricanes over the span of the HURDAT2 dataset. Of particular importance was the change in frequency and intensity. That is,
how did the distribution of tropical storms (& thus hurricanes) change on the Saffir-Simpson scale over the span of the HURDAT2 dataset.

## Files

The files of importance are `fetch_data.py` and `backend.m`. The former fetches the HURDAT2 dataset from the National Oceanic and Atmospherics
Administration and puts the data into a parseable .csv file.

`backend.m` takes the .csv file created from the python script and analyzes the data, such as the frequency of tropical storms, hurricanes,
length of tropical/hurricane season, and more.

## Side Note

`fetch_data.py` can be used for your own purposes to get your own .csv file as the NOAA doesn't upload a .csv file, but is uploaded in an
unparsable .html format. In order to do this, you'll need the python libraries listed in `environment.yml` such as `numpy, pandas, and requests`.
See the license for compliance.

If you use Anaconda, you'll be able to create an environment with using the `environment.yml` file. See Anaconda documentation.
# Outcome of Analysis


