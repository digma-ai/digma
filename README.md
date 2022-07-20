<p align="center">
<img src="/images/bg.jpg" >
</p>
<h1 align="center">
 Continuous Feedback for Developers
</h1>

<!-- Place this tag in your head or just before your close body tag. -->
[![Medium Badge](https://img.shields.io/badge/Blog-black?style=flat&logo=medium&logoColor=white&link=https://medium.com/@roni-dover)](https://medium.com/@roni-dover)
[![Twitter Badge](https://badgen.net/badge/icon/twitter?icon=twitter&label)](https://twitter.com/doppleware)
[![made with love by digma-ai](https://img.shields.io/badge/made%20with%20%E2%99%A5%20by-digma-ff1414.svg?style=flat-square)](https://github.com/digma-ai)

## :raised_eyebrow:	What is Digma

Digma is a Continuous Feedback pipeline, comprised of an analysis backend and an IDE plugin with the goal of continually analyzing observability sources and providing feedback during development. 

Digma makes observability relevant in dev, empowering developers to own their code all the way to production, improving code quality and preventing critical issues before they escalate. 

## :gear: How Digma works

The Digma IDE plugin provides code-level insights related to performance, errors and usage, available as you are making code changes. The insights are continually generated from your OpenTelemetry traces and metrics which are collected and analyzed by the Digma backend. 

## 🚀 Getting started in three steps


### 1. Install the IDE Plugin
Get the Digma plugin from the vsCode [marketplace](https://marketplace.visualstudio.com/items?itemName=digma.digma), additional IDEs support coming soon.

### 2. Start the Digma backend locally via the Docker Compose file
If you're already using OpenTelemetry, awesome! We'll fit right into your stack. If you haven't had a chance yet to test out OTEL, don't worry! we've included everything you need in the quick setup process.

Install [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) if you don't have it set up already.

Run the following from termina/commmand line:

Linux/MacOS
```bash
curl https://raw.githubusercontent.com/digma-ai/digma/main/docker/docker-compose.yml --output docker-compose.yml
docker compose up -d
```
Windows:
```bash
iwr https://raw.githubusercontent.com/digma-ai/digma/main/docker/docker-compose.yml -outfile docker-compose.yml
docker compose up -d
```

### 3. Add a few lines of code to instrument Digma.

* [Python](https://github.com/digma-ai/opentelemetry-instrumentation-digma), 
* [.NET](https://github.com/digma-ai/OpenTelemetry.Instrumentation.Digma). 
* [GOLang](https://github.com/digma-ai/otel-go-instrumentation).


**That's it!** As you start using you application and accumulating trace data, Digma will start showing insights in the IDE sidepane.

### Once you're up and running:
* ##### Consider :star: this repo! It helps us know you care!
* Having issues? Questions? Want to suggest new ideas or discuss Digma with us? Join the [Digma community](https://community.digma.ai)
* Try one of the sample projects we've already set up with data. You can find sampels for [.NET](https://github.com/digma-ai/otel-sample-application-dotnet), [Golang](https://github.com/digma-ai/otel-sample-application-go) and [Python](https://github.com/doppleware/gringotts-vault-api) with more coming soon

##### :tada: Join the Digma Cloud waitlist! 
If continuous feedback is something you'd like to try but don't want to set up everything yourself, [sign up](https://www.digma.ai/) for Digma Cloud beta program. 

## What does Digma look like?

We understand that Digma may sound abstract :art: 
We have created a short video that demonstrates what the product does which you can find here:

<p align="center">

[![Digma in practice](/images/video-s.png)](https://youtu.be/oXSpZ4Jrya8 "Digma in Practice")

</p>

In short, we can use existing logs, traces and metrics to answer questions such as:

* Where is this function called from? Is it even used?
* Is this a problematic area of the code? Where are my bottlenecks? 
* What type of errors does this code raise in runtime? What issues are escalating? Which are affecting the end user?

More importantly, all of these insights should be directly accessible in the IDE so we can use them while coding. 

![Digma HL Architecture](/images/architecture_light.png#gh-light-mode-only)![Digma HL Architecture](/images/architecture_dark.png#gh-dark-mode-only)

## The story behind Digma: :man_technologist::woman_technologist:

We believe that understanding code, real-world requirements and behavior is critical to making better software. It empowers developers to own their code all the way to production. 

There are many observability tools out there, However, we feel they have managed to miss what developers care about when writing their code. Their focus is dashboards, whereas we think observability should be integrated into the dev process itself. 

Our goal is to create an **open platform** for interpreting and analyzing the information collected via observability. Traces, logs, metrics are great! But additional effort is needed in order to take them that last mile and make them impactful.


## How are you different from...

Well we don't compete with any tool existing today because... There isn't any tool that aims to generate this type of feedback. We do work very well together with other tools looking at the same data, like Jaeger, Prometheus, even traditional observability tools like Datadog or Splunk. There are plenty of tools that try to offer troubleshooting/debugging capabilities (once an issue is already identified) or give some raw realtime data. This is not where our headspace is at.

At the time of this writing, most of the data Digma collects is OpenTelemetry based. In the future we will definitely be able to ingest data from other technologies as well such as eBPF or even CloudWatch.

<p align="center">
<img src="/images/digmaloveotel.png" width="500" height="200">
</p>

## How can I learn more about Digma?

We started publishing some more detailed blog posts explaining what we are trying to accomplish. Here are some examples:

[CI-CD-CF The Devops Toolchain Missing Link](https://levelup.gitconnected.com/ci-cd-cf-the-devops-toolchains-missing-link-b5c88caf6282)

[You're never done. By definition.](https://betterprogramming.pub/youre-never-done-by-definition-c04ac77c616b)

[The Observant Developer](https://betterprogramming.pub/the-observant-developer-part-1-1939d53fd5a4)


## How do I contribute or get involved, and are you guys even open-sourcing this?

We are committed to making Digma an Open Source platform. However, we are just getting started, and some of the code is not yet finalized enough yet to accept contributors. Currently we've made our [vscode plugin repo](https://github.com/digma-ai/digma-vscode-plugin)
public with an MIT license. We'll continue to add the additional repos as they become formalized enough to start working on them jointly.

## FAQ

* **Is this going to instrument my code and change it in creepy ways in production?** Absolutely not! We rely on the OpenTelemetry vanilla instrumentation with a few added attributes of our own. We leave your code untouched.
* **Do I need to make code changes to use Digma?** If you're already using OpenTelemetry, you're good to go. If you are not yet using it, we should be a part of your stack if you're considering adding observability to your code!
* **Can I use Digma right now?** We haven't opened the flood gates just yet, but you are welcome to sign on to our beta program (via [this link](https://wwww.digma.ai)) or drop us a line if you want to be a part of the alpha.
* **Which platforms/stacks do you currently support?** We have a limited set of language specific components, but, for the sake of focus, we currently support [**.NET**](https://dotnet.microsoft.com/en-us/), [**GoLang**](https://go.dev/) and [**Python**](https://www.python.org/) over [**Visual Studio Code**](https://code.visualstudio.com/). Over the next month, we'll add [**Jetbrains IDEs**](https://www.jetbrains.com/) and [NodeJS](https://nodejs.org/en/) which are already in progress. If you're using other stacks you wish to see supported, please sign on to the beta and fill our survey - we're definitely taking your responses into consideration.

<br>

<p align="center">
<img src="/images/digma_logo_wingz.png" width="400" height="486">
</p>






