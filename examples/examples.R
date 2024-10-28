#### Install all required packages ####
#install.packages("admtools")
#install.packages("StratPal")
#install.packages("paleoTS")
# if you followed the setup instructions in the README file, no manual installation is required

#### Load required packages ####
library(admtools)
library(StratPal)
library(paleoTS)
# we prepend the namespaces via "packagename::functionname" to clarify
# from which package the functions come

# For more complex examples, see 
# * https://mindthegap-erc.github.io/StratPal/articles/ (StratPal)
# * https://mindthegap-erc.github.io/admtools/articles/ (admtools)
# * Hohmann, N., Liu, X., & Jarochowska, E. (2024). Materials for workshop on building modeling pipelines in stratigraphic paleobiology (v1.0.0). Zenodo. https://doi.org/10.5281/zenodo.13769443 

#### Piping ####
## We make use of the pipe operator |>, available in base R from v4.2 on
rnorm(100) |>
  hist(xlab = "Value",
       main = "Histogram of standard normal distribution")
## The operator takes what is left of "|>" and uses it as first argument
## of the function to the right of it
## Similar to the %>% operator defined by the magrittr package

#### Age-depth models ####
# Define age-depth models based on example data
adm2km = admtools::tp_to_adm(t = scenarioA$t_myr,
                             h = scenarioA$h_m[, "2km"],
                             T_unit = "Myr",
                             L_unit = "m")
adm12km = admtools::tp_to_adm(t = scenarioA$t_myr,
                              h = scenarioA$h_m[, "12km"],
                              T_unit = "Myr",
                              L_unit = "m")
# for details on example data, see ?StratPal::scenarioA

## Plot age-depth models
adm2km |> 
  plot(lwd_acc = 5,     # thick line for accumulative intervals
       lty_destr = 0)   # don't plot destructive intervals
admtools::T_axis_lab()
admtools::L_axis_lab()
title("Age-depth model 2 km from shore")

adm12km |> 
  plot(lwd_acc = 5,     # thick line for accumulative intervals
       lty_destr = 0)   # don't plot destructive intervals
admtools::T_axis_lab()
admtools::L_axis_lab()
title("Age-depth model 12 km from shore")

## Some analyses on the age-depth models
# distibution of hiatus durations
adm2km |>
  admtools::get_hiat_duration() |>
  hist(main = "Hiatus duration 2 km from shore",
       xlab = paste("Hiatus duration [", get_T_unit(adm2km), "]", sep = ""),
       breaks = seq(0, 0.6, by = 0.05))

#### Event type data: Last occurrences ####
# We simulate last occurrences in the time domain using a constant rate
subdiv = 20 # no. of subdivisions for histogram
rolo = 200 # rate of last occurrences (no. per Myr)

## Time domain
StratPal::p3(rate = rolo, min_time(adm2km), max_time(adm2km)) |>               # simulate last occ. assuming constant rate
  hist(breaks = seq(min_time(adm2km), max_time(adm2km), length.out = subdiv),  # plot histogram
       xlab = "Time [Myr]", 
       main = "Last occurrences (Time domain)")

## Stratigraphic domain, 2 km from shore
StratPal::p3(rate = rolo, min_time(adm2km), max_time(adm2km)) |>               # simulate last occ. assuming constant rate
  admtools::time_to_strat(adm2km, destructive = FALSE) |>                      # transform into strat domain with age-depth model from 2 km 
  hist(breaks = seq(min_height(adm2km), max_height(adm2km), length.out = subdiv), # plot histogram
       xlab = "Stratigraphic position [m]", 
       main = "Last occurrences (2 km from shore, platform top)")

StratPal::p3(rate = rolo, from = min_time(adm12km), to = max_time(adm12km)) |> # simulate last occ. assuming constant rate
  admtools::time_to_strat(adm12km, destructive = FALSE) |>                     # transform into strat domain with age-depth model from 12 km
  hist(xlab = "Stratigraphic position [m]",                                    # plot histogram
       main = "Last occurrences (12 km from shore, proximal slope)",
       breaks = seq(min_height(adm12km), max_height(adm12km), length.out = subdiv))

#### Event type data: fossil abundance ####
foss_per_myr = 200 # fossil abundance (fossils per Myr)
# we model fossil abundance of a taxon with a niche model
# assumption: taxon has preffered water depth 100 m and is tolerant to water depth fluctuations
niche = StratPal::snd_niche(opt = 100, tol = 30, cutoff_val = 0) # define niche with optimum at 100 m

# function that describes how water depth changes with time
gc = approxfun(scenarioA$t_myr, scenarioA$wd_m[,"12km"])
plot(scenarioA$t_myr, gc(scenarioA$t_myr),
     type = "l",
     xlab = "Time [Myr]",
     ylab = "Water depth [m]",
     main = "Water depth on the proximal slope",
     lwd = 3)

StratPal::p3(rate = foss_per_myr, min_time(adm12km), max_time(adm12km)) |>   # simulate fossil ages assuming constant rate
  StratPal::apply_niche(niche_def = niche, gc = gc) |>                       # apply niche model
  admtools::time_to_strat(adm12km, destructive = TRUE) |>                    # transform into stratigraphic domain
  hist(breaks = seq(min_height(adm12km), max_height(adm12km), length.out = subdiv), # plot histogram of fossil abundance
       xlab = "Stratigraphic position [m]", 
       main = "Fossil abundance (12 km, proximal slope)")

## without niche model
StratPal::p3(rate = foss_per_myr, min_time(adm12km), max_time(adm12km)) |>   # simulate fossil ages assuming constant rate
  admtools::time_to_strat(adm12km, destructive = TRUE) |>                    # transform into stratigraphic domain
  hist(breaks = seq(min_height(adm12km), max_height(adm12km), length.out = subdiv), # plot histogram of fossil abundance
       xlab = "Stratigraphic position [m]", 
       main = "Fossil abundance (12 km, proximal slope)")


#### Trait evolution and time series ####
## Simulate trait evolution following a biased random walk model:
# other available models are (strict) stasis, unbiased random walk, and Ornstein-Uhlenbeck
set.seed(1) # for reproducibility
temp_res_myr = 0.01 # temporal resolution in Myr

seq(from = min_time(adm2km),to = max_time(adm2km), by = temp_res_myr) |> # times where time series are simulated
  StratPal::random_walk_sl(mu = 2) |>                                    # simulate directional random walk
  StratPal::reduce_to_paleoTS() |>                                       # transform into paleoTS format
  plot(xlab = paste("Time [", get_T_unit(adm2km), "]", sep = ""))

## Introduce stratigraphic distortions
seq(from = min_time(adm2km), to = max_time(adm2km), by = temp_res_myr) |> # times where time series are simulated
  StratPal::random_walk_sl(mu = 2) |>                                     # simulate directional random walk
  admtools::time_to_strat(adm2km, destructive = TRUE) |>                  # transform into stratigraphic domain
  StratPal::reduce_to_paleoTS() |>                                        # transform into paleoTS format
  plot(xlab = paste("Stratigraphic position [", get_L_unit(adm2km), "]", sep = ""))

## fit model to results
seq(from = min_time(adm2km), to = max_time(adm2km), by = temp_res_myr) |> # times where time series are simulated
  StratPal::random_walk_sl() |>                                           # simulate directional random walk
  admtools::time_to_strat(adm2km, destructive = TRUE) |>                  # transform into stratigraphic domain
  StratPal::reduce_to_paleoTS() |>                                        # transform into paleoTS format
  paleoTS::fit4models()                                                   # fit models to results

## taphonomy and ecology can also be incorporated into the pipeline using
## `StratPal::apply_ecology` and `StratPal::apply_taphonomy`
  