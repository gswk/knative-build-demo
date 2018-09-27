knative-build-demo
===

Shows how to leverage Knative Builds to build the [hello-knative](https://github.com/BrianMMcClain/knative-helloworld) demo server-side.

Rather than building and pushing the container image manually ahead of creating the service, this will leverage [server-side builds in Knative](https://github.com/knative/docs/tree/master/build) to automatically pull down the code from GitHub, build the container image, push it to Dockerhub and then create the service as normal.

Configure the Service Account
---
A service account is required to authenticate against Docker Hub to push up our container image. Before we create our service, we'll need to define a secret and service account.

The [secret.yaml](https://github.com/BrianMMcClain/knative-build-demo/blob/master/secret.yaml.example) file defines a secret (set of credentials) named "basic-user-pass", and for Docker Hub expects the username and password to be Base64 encoded.  

The [serviceaccount.yaml](https://github.com/BrianMMcClain/knative-build-demo/blob/master/serviceaccount.yaml) is basic boilerplate that creates a service account named "build-bot" and tells it to use the secrets we created earlier named "basic-user-pass". 

In the build configuration in the [service.yaml](https://github.com/BrianMMcClain/knative-build-demo/blob/master/service.yml) we then say to use the "build-bot" service account (along with the "basic-user-pass" secret) to perform our build, which will allow us to authenticate against Docker Hub.

```
spec:
  runLatest:
    configuration:
      build:
        serviceAccountName: build-bot
```

Next, we'll apply the two YAML files and create the secret and service account in Kubernetes.

```
kubectl apply -f secret.yaml
kubectl apply -f serviceaccount.yaml
```

Create the Service
---

You may have noticed the new "build" section in our service configuration:

```
build:
        serviceAccountName: build-bot
        source:
          git:
            url: https://github.com/BrianMMcClain/knative-helloworld.git
            revision: master
        template:
          name: kaniko
          arguments:
          - name: IMAGE
            value: docker.io/brianmmcclain/knative-build-demo:latest
```

There's a few things we're configuring here:

1. The service account we created above, "build-bot"
2. The source to pull our service from, in this case we've defined a git repo
3. Which build template to use ([kaniko](https://github.com/knative/build-templates/tree/master/kaniko) in our case), along with any arguments the build template requires. In our case, we need to proved where to upload the image, and we've chosed Docker Hub.

Other than this section, everything is as expected. We tell Knative to pull down the image from the same location we're uploading to, since at this point the image will have been uploaded and ready to be used:

```
container:
            image: docker.io/brianmmcclain/knative-build-demo:latest
```            