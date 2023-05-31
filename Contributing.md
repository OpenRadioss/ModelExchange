# How to contribute to ModelExchange

## Prerequisites

### License

* You must be aware of the CC/NC 4.0 [license](LICENSE.md)
* The CC/NC 4.0 License header with your information must be in the header of all the input deck files. 
  The license header has following template :

        #---1----|----2----|----3----|----4----|----5----|----6----|----7----|----8----|----9----|---10----|
        # <Insert Model Name> ("Model")
        # Copyright (C) <Insert Copyright Year> <Insert Copyright Holder> ("Holder")
        # Model is licensed by Holder under CC BY-NC 4.0
        # (https://creativecommons.org/licenses/by-nc/4.0/legalcode).  
        #---1----|----2----|----3----|----4----|----5----|----6----|----7----|----8----|----9----|---10----|

### GitHub File size limit

GitHub has a limitation on file size of 50 MB. If  model or components are bigger, contact the owner of the Repository, the files can be published differently.

## GitHub tasks

* Create your github account
* Review your account setting, in particular: email, 2FA
* Fork the OpenRadioss/Tools repository
* If you want to clone the entire repository on your local machine :
  * Setup your git user name and email.
  * If you don't want to expose your email address: Check Email Settings boxes Keep my email addresses private and Block command line pushes that expose my email here
  * Add your ssh key in your GitHub account settings.

## To add a Model in the repository

* Create a Dev Branch from main

          git checkout -b [dev Branch]

* Add a Folder and place the Model in it
* Create a Readme.md file in the directory to explain briefly what the model does. Check here for the [Template](Template.md)

* Commit your files, upload them on GitHub

        git commit -m ' My new Model'
        git push -f origin main

* On GitHub, create a "Pull Request" to bring your changes into the main repository

## To modify a model

* Create a Dev Branch from main

          git checkout -b [dev Branch]

* Modifiy the Model
* Commit your files, upload them on GitHub

        git commit -m ' My new Model'
        git push -f origin main
* On GitHub, create a "Pull Request" to bring your changes into the main repository

## Acceptance of Pull Request

Maintainer will review the changes, and merge the Pull request in the code.
