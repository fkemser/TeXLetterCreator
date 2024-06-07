<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GNU GPL v3.0 License][license-shield]][license-url]
<!-- [![LinkedIn][linkedin-shield]][linkedin-url] -->



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <!-- <a href="https://github.com/fkemser/TeXLetterCreator">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a> -->

<h3 align="center">TeXLetterCreator</h3>

  <p align="center">
    A collection of shell scripts to interactively create and print TeX-based form letters.
    <br />
    <a href="https://github.com/fkemser/TeXLetterCreator"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/fkemser/TeXLetterCreator">View Demo</a>
    ·
    <a href="https://github.com/fkemser/TeXLetterCreator/issues">Report Bug</a>
    ·
    <a href="https://github.com/fkemser/TeXLetterCreator/issues">Request Feature</a>
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
        <li><a href="#related-projects">Related Projects</a></li>
        <li><a href="#testing-environment">Testing Environment</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#tex-template">TeX Template</a></li>
    <li><a href="#usage-srctexsh">Usage (/src/tex.sh)</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This project provides a `dialog`-based interface to interactively create/print a letter based on a `TeX` (form) letter template by querying individual parameters, e.g. recipient's name and address.

![Screenshot 11][screenshot11]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

[![LaTeX][LaTeX-shield]][LaTeX-url]
[![Shell Script][Shell Script-shield]][Shell Script-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Related Projects

This work includes or is based on other projects:

* [CUPSwrapper](https://github.com/fkemser/CUPSwrapper), a collection of shell scripts to interactively print and manage printers for local usage.
* [GerLaTeXLetter](https://github.com/fkemser/GerLaTeXLetter), a LaTeX template for business letters (mostly) following German DIN 5008 standard, based on KOMA-Script class `scrlttr2`.
* [SHtemplate](https://github.com/fkemser/SHtemplate), a template for POSIX-/Bourne-Shell(sh) projects.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Testing Environment

The project has been developed and tested on the following system:

| Info | Description
---: | ---
OS | Debian GNU/Linux 12 (bookworm)
Kernel | 5.15.90.1-microsoft-standard-WSL2
Packages | [texlive-latex-recommended (2022.20230122-3)](https://packages.debian.org/bookworm/texlive-latex-recommended)
|| [texlive-luatex (2022.20230122-3)](https://packages.debian.org/bookworm/texlive-luatex) 

Please also have a look at the corresponding sections in [CUPSwrapper](https://github.com/fkemser/CUPSwrapper#testing-environment) and [GerLaTeXLetter](https://github.com/fkemser/GerLaTeXLetter#testing-environment).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

> :warning: Please follow each of the following setup instructions **before** continuing:

* [CUPSwrapper](https://github.com/fkemser/CUPSwrapper#prerequisites), 
* [GerLaTeXLetter](https://github.com/fkemser/GerLaTeXLetter#prerequisites)

### Installation

1. Clone the repo
	```sh
   git clone --recurse-submodules https://github.com/fkemser/TeXLetterCreator.git
   ```
2. Edit the repository configuration file. In case it is empty just keep it as it is, **do not delete it**.
	```sh
   nano ./TeXLetterCreator/etc/tex.cfg.sh
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- TEX TEMPLATE -->
## TeX Template

This repository is shipped with a **sample template** (`/test/tex/letter.tex`), a modified version of [GerLaTeXLetter](https://github.com/fkemser/GerLaTeXLetter). **To customize the template** please edit the files within the `/tex` folder. For more information please have a look at [GerLaTeXLetter](https://github.com/fkemser/GerLaTeXLetter#customization).

**In case you use your own TeX template please make sure that it is capable of using the system's environmental variables**. This script will provide the following **additional environmental variables** to the template:

| Variable        | Description                                   | Example                                     |
|-----------------|-----------------------------------------------|---------------------------------------------|
| `arg_recp_addr` | Recipient's address (multiline, without name) | 123 Main Street<br>Anytown, CA 12345<br>USA |
| `arg_recp_name` | Recipient's name (one line)                   | Jane Doe                                    |

**To introduce more variables** just modify the repository's run file `/src/tex.sh` as well as the sample template `/tex/letter.tex` (or your own one). For more information on `tex.sh`'s general structure you may have a look at [SHtemplate](https://github.com/fkemser/SHtemplate#srcrunsh-repository-run-file). For more information on `letter.tex` please have a look at [GerLaTeXLetter](https://github.com/fkemser/GerLaTeXLetter#customization).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage (/src/tex.sh)

To call the script interactively, run `/src/tex.sh` (without further arguments) from your terminal. To get help, run `/src/tex.sh -h`.  

```sh
================================================================================
===============================     SYNOPSIS     ===============================
================================================================================

There are multiple ways to run this script:

Interactive mode (without any args):
> ./tex.sh

Classic (script) mode:
> ./tex.sh [ OPTION ]... ACTION [ <file_in> ]

ACTION := { -h|--help | --create | --print }

OPTION := { [-i|--in <file_in>] | [-o|--out <file_out>] | [-a|--address <address>] | [-n|--name <name>] }

[ <file_in> ] : LaTeX template file (.tex) to use

--------------------------------------------------------------------------------
--------------------------------     ACTION     --------------------------------
--------------------------------------------------------------------------------

-h|--help            Show this help message                                     

--submenu <menu>     Run a certain submenu interactively and exit               
                                                                                
                     <menu> = { create | print }                                

--create             Create letter and save as PDF file                         

--print              Create letter and print                                    

--------------------------------------------------------------------------------
--------------------------------     OPTION     --------------------------------
--------------------------------------------------------------------------------

-i|--in <file_in>          LaTeX template file (.tex) to use                    

-o|--out <file_out>        Output file (.pdf)                                   

-a|--address <address>     Recipient's delivery address (without name)          

-n|--name <name>           Recipient's name                                     

================================================================================
===============================     EXAMPLES     ===============================
================================================================================

______________________ Interactive mode | Call main menu _______________________

> ./tex.sh

________ Interactive mode | Print letter with pre-defined TeX template _________

> ./tex.sh --submenu print "../tex/letter.tex"

_________________________________ Script mode __________________________________

> addr="\
123 Main Street
Anytown, CA 12345
USA"
> name="Jane Doe"
> ./tex.sh --create --address "${addr}" --name "${name}" "../tex/letter.tex"
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>                     



<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/fkemser/TeXLetterCreator/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the **GNU General Public License v3.0 (or later)**. See [`LICENSE`][license-url] for more information.

> :warning: The license above does not apply to the files and folders within the library directory `/lib`. Please have a look at the `LICENSE` file located in the root directory of each library to get more information.

> :warning: The license above may not apply to some files within the TeX sample letter directory `/test/tex`. Please have a look at the `SPDX-FileCopyrightText` and `SPDX-License-Identifier` headers in each file to get more information.

> :warning: The license above does not apply to the sample logo file `/test/tex/logo.png`. For more information please have a look at [Logoipsum's terms of license](https://logoipsum.com/license).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Project Link: [https://github.com/fkemser/TeXLetterCreator](https://github.com/fkemser/TeXLetterCreator)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

###
* [othneildrew/Best-README-Template](https://github.com/othneildrew/Best-README-Template)
* [Ileriayo/markdown-badges](https://github.com/Ileriayo/markdown-badges)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/fkemser/TeXLetterCreator.svg?style=for-the-badge
[contributors-url]: https://github.com/fkemser/TeXLetterCreator/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/fkemser/TeXLetterCreator.svg?style=for-the-badge
[forks-url]: https://github.com/fkemser/TeXLetterCreator/network/members
[stars-shield]: https://img.shields.io/github/stars/fkemser/TeXLetterCreator.svg?style=for-the-badge
[stars-url]: https://github.com/fkemser/TeXLetterCreator/stargazers
[issues-shield]: https://img.shields.io/github/issues/fkemser/TeXLetterCreator.svg?style=for-the-badge
[issues-url]: https://github.com/fkemser/TeXLetterCreator/issues
[license-shield]: https://img.shields.io/github/license/fkemser/TeXLetterCreator.svg?style=for-the-badge
[license-url]: https://github.com/fkemser/TeXLetterCreator/blob/main/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/linkedin_username

[screenshot11]: res/screenshot11.gif

[LaTeX-shield]: https://img.shields.io/badge/latex-%23008080.svg?style=for-the-badge&logo=latex&logoColor=white
[LaTeX-url]: https://www.latex-project.org/
[Shell Script-shield]: https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white
[Shell Script-url]: https://pubs.opengroup.org/onlinepubs/9699919799/