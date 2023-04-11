<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->
<div align="center">
  
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]
[![Twitter][twitter-shield]][twitter-url] 

</div>

<h3 align="center">Serve Pass Analysis with Shiny</h3>

  <p align="center">
    Visualizing projected serve and pass win percentages in a web app with the help of R and Shiny.
    <br />
    <br />
    <a href="https://github.com/keatonrproud/serve_pass_analysis/issues">Report Bug</a>
    ·
    <a href="https://github.com/keatonrproud/serve_pass_analysis/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This project was used from the 2019-20 season onwards with the Queen's Men's Volleyball team to better understand and train our team's serving. Speed and outcome data was collected across all practices and matches. 

Expected win percentages based on pass quality are used to predict overall win percentage in velocity bins for a server. You can input your own data, roster, and/or expected win percentages after cloning the repo.

Here's an example of the output:

![Serve PSP analysis](/ZG_Analysis.png)

<br />

### Built With

[![R][r-shield]][r-url]
[![RStudio][rstudio-shield]][rstudio-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

If you want to view the web app, [click here](https://www.keatonrproud.shinyapps.io/ServePassAnalysis). There is a warning about connection privacy, however the web app asks for no personal information to be inputted.
You can also clone the repo to edit the app and the data to make it your own.

### Prerequisites

You'll need to install several libraries to run the scripts directly -- the most important are _[tidyverse](https://www.tidyverse.org/)_ (providing access to ggplot2 and dplyr as well), _[shiny](https://shiny.rstudio.com/)_ for building the web app, and _[googlesheets4](https://googlesheets4.tidyverse.org/)_ to access data online.

Ensure you have all packages installed. 


### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/keatonrproud/serve_pass_analysis.git
   ```
2. Install any missing packages

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- CONTRIBUTING -->
## Contributing

If you have a suggestion, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement". All feedback is appreciated!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [Queen's Men's Volleyball](https://gogaelsgo.com/sports/mens-volleyball/roster) for the opportunity to dive into the project.
* [Shiny](https://scikit-learn.org/) for making deploying interactive web apps so simple.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Keaton Proud - [Twitter](https://twitter.com/keatonrproud) - [LinkedIn](https://linkedin.com/in/keatonrproud)- keatonrproud@gmail.com

Project Link: [https://github.com/keatonrproud/serve_pass_analysis](https://github.com/keatonrproud/serve_pass_analysis)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/keatonrproud/serve_pass_analysis.svg?style=for-the-badge
[contributors-url]: https://github.com/keatonrproud/serve_pass_analysis/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/keatonrproud/serve_pass_analysis.svg?style=for-the-badge
[forks-url]: https://github.com/keatonrproud/serve_pass_analysis/network/members
[stars-shield]: https://img.shields.io/github/stars/keatonrproud/serve_pass_analysis.svg?style=for-the-badge
[stars-url]: https://github.com/keatonrproud/serve_pass_analysis/stargazers
[issues-shield]: https://img.shields.io/github/issues/keatonrproud/serve_pass_analysis.svg?style=for-the-badge
[issues-url]: https://github.com/keatonrproud/serve_pass_analysis/issues
[license-shield]: https://img.shields.io/github/license/keatonrproud/serve_pass_analysis.svg?style=for-the-badge
[license-url]: https://github.com/keatonrproud/serve_pass_analysis/blob/main/license
[linkedin-shield]: https://img.shields.io/badge/linkedin-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white
[linkedin-url]: https://linkedin.com/in/keatonrproud
[twitter-shield]: https://img.shields.io/badge/Twitter-%231DA1F2.svg?style=for-the-badge&logo=Twitter&logoColor=white
[twitter-url]: https://twitter.com/keatonrproud
[r-shield]: https://img.shields.io/badge/r-%23276DC3.svg?style=for-the-badge&logo=r&logoColor=white
[r-url]: https://www.r-project.org/
[shiny-shield]: https://img.shields.io/badge/Shiny-shinyapps.io-blue?style=flat&labelColor=white&logo=RStudio&logoColor=blue
[shiny-url]: https://shiny.rstudio.com/
[rstudio-shield]: https://img.shields.io/badge/RStudio-4285F4?style=for-the-badge&logo=rstudio&logoColor=white
[rstudio-url]: https://posit.co/download/rstudio-desktop/
