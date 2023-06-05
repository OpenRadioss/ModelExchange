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

### General tasks

* Create your github account
* Review your account setting, in particular: email, 2FA
* Fork the OpenRadioss/ModelExchange repository

### On your local machine

* Install git
  * On Linux 
  
        RHEL / CentOS   : yum install git
        Ubuntu / Debian : atp-get install git
        
  * On Windows : Installation package can be found on Git Web site. The package come with some usefull tools like ssh
  
         Download and install the package with yout browser
         [https://git-scm.com/download/win](https://git-scm.com/download/win)
         
    Git will be available in command line shells : cmd.exe or Linux terminal
  
* Setup your git user, name, and email
  
         git config --global user.name=[git user name]
         git config --global user.email=[git email]
     
  * If you don't want to expose your email address: On gitHub, In [GitHub Accounts] / Settings / Emails :
    * Check Email Settings box "Keep my email addresses private" 
    * Select "Block command line pushes that expose my email here"
  
* Create and Add your ssh key in your GitHub account settings / ssh.
  Check [Add SSH key in gitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) for further information. 
        
* Forks can be updated with main repository :
    * In your GitHub page : Select your ModelExchange Fork :  "<> Code"
    * Select "Update Fork"

* On your local machine : you can clone your fork to access to the Model : In a shell terminal / Linux or cmd.exe / Windows

        git clone git@github.com:[GitHub Account login]/ModelExchange

* Link your Fork with the Official Repository "Upstream"

        * Enter in ModelExchange directory
        * Type : git remote add upstream git@github.com:OpenRadioss/ModelExchange.git

## To add or Modify a Model in the repository

* Enter your clone on your local machine

* Create a Dev Branch from main

          git checkout -b [dev Branch]

Following tasks must be done:

1. Add a Folder and place the Model in it

2. Create a **Readme.md** file in the directory to explain briefly what the model does and present some results. Check here for the [Template](Template.md)

3. work on your files : Iterate over:  

    * Open and edit files  
    * `git status` to see which files has been edited  
    * `git add <filename>` each file
    * `git commit -m “<message>” `  with a [good](https://openpbs.atlassian.net/wiki/spaces/DG/pages/6193155/How+To+Write+a+Good+Git+Commit+Message) message.

4. If you have done several commits, do the rebase task to merge them into one :

        git rebase -i main
    
    To squash all your commits into your first one: replace `pick` by `squash` on for all your commits except your first one. Do not squash your commits into someone else's commit. Do not embed someone else's commit into your squashed commit. 

5. Rebase your work on the latest version of OpenRadioss/ModelExchange (you can also follow [this](https://openpbs.atlassian.net/wiki/spaces/DG/pages/1183744006/Rebasing+Your+Dev+Branch))
    * `git pull --rebase upstream main`  
    * Solve conflicts, loop over:  
       * Edit conflicting files and resolve conflicts 
       * `git add <filename>` to mark files as resolved (do not commit)
       * `git rebase --continue`  
 
6. If GitHub ModelExchange repository is more recent than your main, you need to rebase your development branch with upstream.

       git rebase upstream main

7. upload them on GitHub

        git push -f origin main 

* On GitHub Web, create a "Pull Request" with your branch and commit to bring your changes into the main repository


## Acceptance of Pull Request

Maintainers will review the changes. They may require changes , and merge the Pull request in the code.

