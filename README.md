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
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]
[![CircleCI](https://circleci.com/github/Pakoke/learn-terraform-circleci/tree/master.svg?style=svg)](https://circleci.com/github/Pakoke/learn-terraform-circleci/?branch=master)


<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/Pakoke/learn-terraform-circleci">
    <img src="images/terraformaws.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Blue Green Deployment</h3>

  <p align="center">
    This project is going to build our entire infrastructure to deploy an ECS Cluster with a dotnetapi container on it
    <br />
    <a href="https://github.com/Pakoke/learn-terraform-circleci"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Pakoke/learn-terraform-circleci#demo">View Demo</a>
    ·
    <a href="https://github.com/Pakoke/learn-terraform-circleci/issues">Report Bug</a>
    ·
    <a href="https://github.com/Pakoke/learn-terraform-circleci/issues">Request Feature</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <!-- <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul> -->
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This project is about showing how to fully an AWS insfrastructure usingd a Circle pipeline through Terraform, Docker, Dotnet and CircleCI Orbs.
On this project, we are going to build diferents AWS components which it will end up having an ECS cluster with a Dotnet api service on it. In addition to that and thanks to CircleCI, we are going to do a CodeDeploy deployment which it is going to help us deploy the latest version of the code without interrupting the any service of our apps.
At the of this Blue Green deployment, we are going destroy all of our resource in our AWS to save all the cost.

Here's a blank template to get started:
**To avoid retyping too much info. Do a search and replace with your text editor for the following:**
`Pakoke`, `learn-terraform-circleci`, `twitter_handle`, `email`, `project_title`, `project_description`


### Built With

* [Terraform](https://www.terraform.io/)
* [AWS](https://aws.amazon.com/es/)
* [CircleCI](https://circleci.com/)
* [Docker](https://www.docker.com/)
* [Dotnet](https://dotnet.microsoft.com/)

<!-- GETTING STARTED -->
## Getting Started

This project and all the resources will help you to build and deploy the infrastructure.

### Prerequisites

This is what you need to initialize to set your pipeline on CircleCI.
* Git

    Windows
    ```powershell
    choco install git -y
    ```
    Ubuntu
    ```sh
    sudo apt-get update
    sudo apt-get install git -y
    ``` 

* AWS Account
* AWS Client

    Windows
    ```powershell
    choco install awscli -y
    ```
    Ubuntu
    ```sh
    sudo apt-get update
    sudo apt-get install awscli -y
    ``` 

* Terraform

    Windows
    ```powershell
    choco install terraform -y
    ```
    Ubuntu
    ```sh
    sudo wget https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip
    sudo unzip terraform_0.14.7_linux_amd64.zip
    sudo mv terraform /usr/local/bin/
    ```

### Installation

1. Clone the repo
    ```
    git clone https://github.com/Pakoke/learn-terraform-circleci.git
    ```
2. Go to the folder ``infrastructure.init``
    ```
    cd /learn-terraform-circleci/infrastructure.init
    ```
3. Configure your AWS credentials. For the sake of this example, I recommend to create an user with Admin permissions.
    ```
    aws configure
    ```
4. Initialize the Terraform project and apply the plan to get all the information that we will need for set up our pipeline.
    ```
    terraform init
    terraform apply --auto-approve
    ```
5. Get all the outputs that it shows Terraform at the end of plan.
    ```
    account_id = "xxxxxxxxxx"
    aws_region = "xx-xxxx-2"
    s3_terraform_state = "circle-ci-backend-xxxxxxxxxxxx"

    ```




<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_



<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/Pakoke/learn-terraform-circleci/issues) for a list of proposed features (and known issues).



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

Your Name - [@twitter_handle](https://twitter.com/twitter_handle) - email

Project Link: [https://github.com/Pakoke/learn-terraform-circleci](https://github.com/Pakoke/learn-terraform-circleci)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

* []()
* []()
* []()





<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/Pakoke/repo.svg?style=for-the-badge
[contributors-url]: https://github.com/Pakoke/repo/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Pakoke/repo.svg?style=for-the-badge
[forks-url]: https://github.com/Pakoke/repo/network/members
[stars-shield]: https://img.shields.io/github/stars/Pakoke/repo.svg?style=for-the-badge
[stars-url]: https://github.com/Pakoke/repo/stargazers
[issues-shield]: https://img.shields.io/github/issues/Pakoke/repo.svg?style=for-the-badge
[issues-url]: https://github.com/Pakoke/repo/issues
[license-shield]: https://img.shields.io/github/license/Pakoke/repo.svg?style=for-the-badge
[license-url]: https://github.com/Pakoke/repo/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/Pakoke
