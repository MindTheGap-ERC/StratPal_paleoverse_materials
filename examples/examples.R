install.packages("admtools")
install.packages("StratPal")
install.packages("paleoTS")

library(admtools)
library(StratPal)
library(paleoTS)

adm = admtools::tp_to_adm(t = scenarioA$t_myr, h = scenarioA$h_m[, "2km"],
                T_unit = "Myr",
                L_unit = "m")

random_walk(1:5) |> plot()

sim.GRW() |> plot()
