<p style="text-align: center;">
  <img src="/images/bg.jpg" >
</p>
<h1 style="text-align: center;">
  Continuous Feedback for Developers
</h1>

<!-- Place this tag in your head or just before your close body tag. -->
[![Medium Badge](https://img.shields.io/badge/Blog-black?style=flat&logo=medium&logoColor=white&link=https://medium.com/@roni-dover)](https://medium.com/@roni-dover)
[![Twitter Badge](https://badgen.net/badge/icon/twitter?icon=twitter&label)](https://twitter.com/doppleware)
[![made with love by digma-ai](https://img.shields.io/badge/made%20with%20%E2%99%A5%20by-digma-ff1414.svg?style=flat-square)](https://github.com/digma-ai)

<p style="text-align: center;">
  <a href="https://bit.ly/3bKtdxU" target="_blank">
    <img src="https://img.shields.io/badge/Slack-4A154B?logo=slack&color=black&logoColor=white&style=for-the-badge alt="Join our Slack!" width="80" height="30">
  </a> 
</p>

## :raised_eyebrow:	What is Digma

Digma is a Continuous Feedback pipeline, comprised of an analysis backend and an IDE plugin with the goal of continually analyzing observability sources and providing feedback during development.

Digma makes observability relevant in dev, empowering developers to own their code all the way to production, improving code quality and preventing critical issues before they escalate.

## :gear: How Digma works

The Digma IDE plugin provides code-level insights related to performance, errors and usage, available as you edit your code. The insights are continually generated from your OpenTelemetry traces and metrics which are collected and analyzed by the Digma backend.

## 🚀 Getting started in three steps

### 1. Install the IDE Plugin
Get the Digma plugin from the [vscode marketplace](https://marketplace.visualstudio.com/items?itemName=digma.digma), or from the [JetBrains marketplace](https://plugins.jetbrains.com/plugin/19470-digma-continuous-feedback) for Rider. Support for additional IDEs is coming soon.

### 2. Start the Digma backend locally using the Docker Compose file
Already using OpenTelemetry? Awesome! We'll fit right into your stack. Otherwise - don't worry! everything you need is included in the quick setup.

Run the following command in your terminal/commmand line:

- _Linux & MacOS:_ `curl -L https://get.digma.ai/ --output docker-compose.yml`

- _Windows (PowerShell):_ `iwr https://get.digma.ai/ -outfile docker-compose.yml`

Then run `docker compose up -d` to start the Digma backend. (You'll have to install [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) first, if you haven't installed them yet.)

### 3. Add a few lines of code to instrument Digma.

Check out these simple instructions for your tech stack:
- [Python](https://github.com/digma-ai/opentelemetry-instrumentation-digma)
- [.NET](https://github.com/digma-ai/OpenTelemetry.Instrumentation.Digma)
- [GOLang](https://github.com/digma-ai/otel-go-instrumentation)
- [Node.js](https://github.com/digma-ai/otel-js-instrumentation)
- [Express](https://github.com/digma-ai/digma-instrumentation-express) (also requires the Node.js instrumentation)
- [Java](https://github.com/digma-ai/otel-java-instrumentation)

**That's it!**  :tada:  As you start using your application and accumulating trace data, Digma will start showing insights in the IDE sidepane.

### Once you're up and running:
* #### Consider :star: this repo! It helps us know you care!
* Having issues? Questions? Want to suggest new ideas or discuss Digma with us? Join the [Digma community](https://community.digma.ai)
* Try one of the sample projects we've already set up with data. You can find samples for [.NET](https://github.com/digma-ai/otel-sample-application-dotnet), [Golang](https://github.com/digma-ai/otel-sample-application-go), [Python](https://github.com/doppleware/gringotts-vault-api), [JavaScript](https://github.com/digma-ai/otel-sample-application-js) and [Java with SpringBoot](https://github.com/digma-ai/java-sample-app-spring-petclinic) with more coming soon.

### Join the Digma Cloud waitlist! 
If continuous feedback is something you'd like to try but don't want to set everything up yourself, [sign up](https://digma.ai/get-digma/) and get Digma.

## What does Digma look like?

We understand that Digma might sound a bit abstract :art:, so we created a short demonstration video to show you what it does.
Check it out:

<p style="text-align: center;">

  [![Digma in practice](/images/video-s.png)](https://youtu.be/oXSpZ4Jrya8 "Watch the demo video &quot;Digma in Practice&quot;")

</p>

In short, we can use existing logs, traces and metrics to answer questions such as:

* Where is this function called from? Is it even used?
* Is this a problematic area of the code? Where are my bottlenecks? 
* What type of errors does this code raise during run time? Which issues are escalating? Which are affecting the end users?

More importantly, all of these insights should be directly accessible in the IDE so we can use them while coding. 

![Digma HL Architecture](/images/architecture_light.png#gh-light-mode-only)![Digma HL Architecture](/images/architecture_dark.png#gh-dark-mode-only)

## The story behind Digma: :man_technologist::woman_technologist:

We believe that understanding code, real-world requirements and behavior is critical to making better software. It empowers developers to own their code all the way to production. 

There are many observability tools out there, However, we feel they have managed to miss what developers care about when writing their code. Their focus is on dashboards, whereas we think observability should be integrated into the dev process itself.

Our goal is to create an **open platform** for interpreting and analyzing the information collected via observability. Traces, logs, metrics are great! But additional effort is needed in order to take them that last mile and make them impactful.

## How are you different from...

Well we don't compete with any tool existing today because... There isn't any tool that aims to generate this type of feedback. We do work very well together with other tools looking at the same data, like Jaeger, Prometheus, even traditional observability tools like Datadog or Splunk. There are plenty of tools that try to offer troubleshooting/debugging capabilities (once an issue is already identified) or give some raw realtime data. This is not where our headspace is at.

At the time of this writing, most of the data Digma collects is based on OpenTelemetry. In the future we will definitely be able to ingest data from other technologies as well (such as eBPF or CloudWatch).

<p style="text-align: center;">
  <img src="/images/digmaloveotel.png" width="500" height="200">
</p>

## How can I learn more about Digma?

We started publishing some more detailed blog posts explaining what we are trying to accomplish. Here are a few examples:

- [CI/CD/CF? — The DevOps toolchain’s “missing-link”](https://levelup.gitconnected.com/ci-cd-cf-the-devops-toolchains-missing-link-b5c88caf6282)

- [You're never done. By definition.](https://betterprogramming.pub/youre-never-done-by-definition-c04ac77c616b)

- [The Observant Developer](https://betterprogramming.pub/the-observant-developer-part-1-1939d53fd5a4)

## How do I contribute or get involved, and are you guys even open-sourcing this?

We are committed to making Digma an Open Source platform. However, we are just getting started, and some of the code is not yet finalized enough to accept contributors. We've made our [vscode plugin repo](https://github.com/digma-ai/digma-vscode-plugin) public with an MIT license. We'll continue to add repos as they become formalized enough to start working on them jointly.

## FAQ

* **Is this going to instrument my code and change it in creepy ways in production?** Absolutely not! We rely on the OpenTelemetry vanilla instrumentation with a few added attributes of our own. We leave your code untouched.
* **Do I need to make code changes to use Digma?** If you're already using OpenTelemetry, you're good to go. If you are not yet using it, we should be a part of your stack if you're considering adding observability to your code!
* **Can I use Digma right now?** We haven't opened the flood gates just yet, but you are welcome to [sign up for our beta program](https://www.digma.ai/get-digma/) or drop us a line if you want to be a part of the alpha.
* **Which platforms/stacks do you currently support?** We have a limited set of language specific components, but, for the sake of focus, we currently support [**.NET**](https://dotnet.microsoft.com/en-us/), [**GoLang**](https://go.dev/), [**Python**](https://www.python.org/) and [**Node.js**](https://nodejs.org/en/) (and [**Express**](https://expressjs.com/)) on [**Visual Studio Code**](https://code.visualstudio.com/). We also support the [**Rider IDE**](https://www.jetbrains.com/rider/) and support for the other [**Jetbrains IDEs**](https://www.jetbrains.com/) is already in progress. If you're using other stacks you wish to see supported, please sign up for the beta and fill out our survey - we're definitely taking your responses into consideration.

<p style="text-align: center; margin-top: 2em;">
  <img src="/images/digma_logo_wingz.png" width="400" height="486">
</p>
