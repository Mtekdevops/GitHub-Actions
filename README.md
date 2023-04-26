## GitHub-Actions

These Actions will deploy the EKS cluster terraform that is in my other repository. again this isn't supposed to be a perfect production setup, but is intended to provide reference materials and association patterns for future learning and customisation. 

### Actions Workflow

1.  When a pull request is opened on the main branch, the actions will perform a Checkov security scan on the code and then run Terraform plan and put the output of that plan into a pull request comment.
    
2. once the pull request has been approved, Another action will run the Terraform apply and put the results of the apply operation into the same pull request.

Branch Protection is enabled that should stop a PR being merged if its not up to date with the 
main branch. 

### Setup

The Actions use Short-lived AWS Role Credentials that are provided through GitHub's OpenID Token service.

The AWS OIDC Identity Provider and associated IAM role can be setup automatically by Applying the Terraform script in the `SetupOIDC` folder.
