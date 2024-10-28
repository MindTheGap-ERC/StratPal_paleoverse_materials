# StratPal_paleoverse_materials

Materials and examples for the [Paleoverse](https://palaeoverse.org) lecture __"Building modeling pipelines for stratigraphic paleobiology in R"__ (Oct 31st 2024)

## Author

__Niklas Hohmann__  
Utrecht University  
email: n.h.hohmann [at] uu.nl  
Web page: [www.uu.nl/staff/NHohmann](https://www.uu.nl/staff/NHHohmann)  
ORCID: [0000-0003-1559-1838](https://orcid.org/0000-0003-1559-1838)

## Usage

Open the `StratPal_paleoverse_materials.Rproj` file in the RStudio IDE. This will automatically set all paths correctly, and install the `renv` package (if not already installed).

Then, run

```{R}
renv::restore()
```

to install all required packages in their correct version. The examples were created in R v4.4.1, but will also run in R versions >= 4.2.

After installing all packages, open the file `examples/examples.R` to examine the code and interact with it.

## Other resources

Other resources mentioned during the lecture are:

* _Publication on the effect of incompleteness on the recognition of the mode of evolution:_ Hohmann, N., Koelewijn, J.R., Burgess, P., Jarochowsk, E. Identification of the mode of evolution in incomplete carbonate successions. BMC Ecol Evo 24, 113 (2024). [DOI: 10.1186/s12862-024-02287-2](https://doi.org/10.1186/s12862-024-02287-2)
* _Interactive web application to explore stratigraphic paleobiology:_
  * Browser version: [DarwinCAT](https://stratigraphicpaleobiology.shinyapps.io/DarwinCAT/)
  * Github: [github.com/MindTheGap-ERC/DarwinCAT](https://github.com/MindTheGap-ERC/DarwinCAT)
* _Open educational resources for a workshop on modeling stratigraphic paleobiology in R:_ Hohmann, N., Liu, X., & Jarochowska, E. (2024). Materials for workshop on building modeling pipelines in stratigraphic paleobiology (v1.0.0). Zenodo. [DOI: 10.5281/zenodo.13769443](https://doi.org/10.5281/zenodo.13769443)
* _Package webpages_:
  * `StratPal`: [mindthegap-erc.github.io/admtools/](https://mindthegap-erc.github.io/admtools/)
  * `admtools`: [mindthegap-erc.github.io/StratPal/](https://mindthegap-erc.github.io/StratPal/)

## Copyright

Copyright 2023-2024 Netherlands eScience Center and Utrecht University

## License

Apache 2.0 License, see LICENSE file for license text.

## Repository structure

* examples:
  * examples.R : coding examples shown during the interactive coding part of the lecture
* renv: folder for `renv` package
* .gitignore: untracked files
* .Rprofile: r session settings
* LICENSE: Apache 2.0 license text
* README.md: Readme file
* renv.lock: lock file for `renv` package
* StratPal_paleoverse_materials.Rproj : R project file

## Funding information

Funded by the European Union (ERC, MindTheGap, StG project no 101041077). Views and opinions expressed are however those of the author(s) only and do not necessarily reflect those of the European Union or the European Research Council. Neither the European Union nor the granting authority can be held responsible for them.
![European Union and European Research Council logos](https://erc.europa.eu/sites/default/files/2023-06/LOGO_ERC-FLAG_FP.png)
