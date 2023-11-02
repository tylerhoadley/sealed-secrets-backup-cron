# sealed-secrets-backup-cron


## Getting started

Setup your CI pipeline and use the provided `Dockerfile`

## Description
This application runs on a base debian bulleye image with the latest `kubectl` and `p7zip-full` packages at build. Its designed to run as a k8s cron job to backup a single targetted k8s clusters', Sealed Secret `TLS Secrets` to a persistant volume for offsite disaster recovery. Ive also added an extra layer of security with 7zip encryption plus archiving. This can add an additional layer of protection for backups on Networks services like NFS or cloud storage. The longer and more complex the `ENCRYPTION_KEY` the stronger protection you will have if an unwanted actor steals these backup files. This tool was created to recover clusters in a disaster or migrate IaC declaration from one cluster to another without having to reseal an entire clusters sealed secrets. 

Protect these backups!

## Installation

This is a k8s cron job based workload, Run and done. It also requires a persistant volume claim as a backup location for the job. 

## Usage

This image requires `2` environment variables, `1` secret set as an environment variable and `1` secret set then mounted as the `KUBECONFIG`` file content in order to backup the k8s SS Certificate secrets plus encrypt them.


### Secret

This should be set and recorded in a Password Manager or in another safe and secure location. 7zip allows lenghty and complex password schemas.

```
ENCRYPTION_KEY=mcfOnGcJHqJU07llS89dOi4N1rmrXK7pxUV9eEAk2hnFdV6sqdEe0ychjU8lWyUMwLrMYYK5NkaB4XVX1MuwrkjVIWv34ZjGO1gaEJNAOiLlr1QnclEEwbFF4L_TixAe
```

### ENV

This should be set to a persistant volume location. I recommend setting this to a secure and avaiable location in case of disaster. This location should enforce high security access rights. 7Zip encyrption offers some, but not all protection against being compromised. These keys decrypt your Sealed Secrets within your cluster, Protect these backups.

```
BACKUP_DIR=/opt/backup/${clustername}
```

This is not the file, but the location of where the file resides. Create a secret (any env name) then mount that secret to this location. This is required in order to communicate with your cluster. It will query for the `sealedsecrets.bitnami.com/sealed-secrets-key` selectors obkjects.

```
KUBECONFIG=/opt/kube/config
```

### Secret Mount

Mount to `echo $KUBECONFIG`

```
KUBECONFIG_FILECONTENT=CONTENT of cluster config 
```


## Usage

Setup rotation within the backup job, or create another cron based job to clean up backups over X days or until X, then X past that.
