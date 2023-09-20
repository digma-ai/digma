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
  <a href="https://join.slack.com/t/continuous-feedback/shared_invite/zt-1hk5rbjow-yXOIxyyYOLSXpCZ4RXstgA" target="_blank">
    <img src="https://img.shields.io/badge/Slack-4A154B?logo=slack&color=black&logoColor=white&style=for-the-badge alt="Join our Slack!" width="80" height="30">
  </a> 
</p>

## :raised_eyebrow:	What is Digma

Digma is a Continuous Feedback platform, comprised of an analysis backend and an IDE plugin with the goal of continually analyzing observability sources and providing feedback during development.

Digma makes observability relevant in dev, empowering developers to own their code all the way to production, improving code quality and preventing critical issues before they escalate.

## :gear: How Digma works

The Digma IDE plugin provides code-level insights related to performance, errors and usage, available as you edit your code. The insights are continually generated from your OpenTelemetry traces and metrics which are collected and analyzed by the Digma backend.

## 🚀 Getting started

### 1. Install the IDE Plugin
Get the Digma plugin from the [JetBrains marketplace](https://plugins.jetbrains.com/plugin/19470-digma-continuous-feedback). We currently support IntelliJ and Java, support for additional IDEs is coming soon.

### 2. Follow the installation instructions in the plugin to get Digma up and running

**That's it!**  :tada:  As you start using your application and accumulating trace data, Digma will start showing insights in the IDE sidepane.

### Once you're up and running:
* #### Consider :star: this repo! It helps us know you care!
* Having issues? Questions? Want to suggest new ideas or discuss Digma with us? Join the [Digma community](https://join.slack.com/t/continuous-feedback/shared_invite/zt-1hk5rbjow-yXOIxyyYOLSXpCZ4RXstgA)

## What does Digma look like?

You can check out some videos and more info on our [Youtube Channel]([https://digma.ai](https://www.youtube.com/channel/UCEIvE7BBynMll4tEUL5eKfA))! 

In short, we can use existing logs, traces, and metrics to answer questions such as:

* Where is this function called from? Is it even used?
* Is this a problematic area of the code? Where are the bottlenecks? 
* What type of errors does this code raise during run time? Which issues are escalating? Which are affecting the end users?
* Is this code scalable?

More importantly, all of these insights should be directly accessible in the IDE so we can use them while coding. 

![Digma HL Architecture](/images/architecture_light.png#gh-light-mode-only)![Digma HL Architecture](/images/architecture_dark.png#gh-dark-mode-only)

## The story behind Digma: :man_technologist::woman_technologist:

We believe that understanding code, real-world requirements, and behavior is critical to making better software. It empowers developers to own their code all the way to production. 

There are many observability tools out there, However, we feel they have managed to miss what developers care about when writing their code. Their focus is on dashboards, whereas we think observability should be integrated into the dev process itself.

Our goal is to create an **developer platform** for interpreting and analyzing the information collected via observability. Traces, logs, metrics are great! But additional effort is needed in order to take them that last mile and make them impactful.

## How are you different from...

Well, we don't compete with any tool existing today because... There isn't any tool that aims to generate this type of feedback. We do work very well together with other tools looking at the same data, like Jaeger, Prometheus, and even traditional observability APMs like Datadog or Splunk. There are plenty of tools that try to offer troubleshooting/debugging capabilities (once an issue is already identified) or give some raw real-time data. This is not where our headspace is at.

At the time of this writing, most of the data Digma collects is based on OpenTelemetry. In the future, we will definitely be able to ingest data from other technologies as well (such as eBPF or CloudWatch).

<p style="text-align: center;">
  <img src="/images/digmaloveotel.png" width="500" height="200">
</p>

## How can I learn more about Digma?

We started publishing some more detailed blog posts explaining what we are trying to accomplish. Here are a few examples:

- [CI/CD/CF? — The DevOps toolchain’s “missing-link”](https://digma.ai/blog/ci-cd-cf-the-devops-toolchains-missing-link-continuous-feedback/)

- [Effective Java Observability](https://digma.ai/blog/coding-with-java-observability/))

- [The Observant Developer](https://digma.ai/blog/the-observant-developer-part-1/)

## How do I contribute or get involved, and are you guys even open-sourcing this?

We are committed to making Digma a platform that is free for developers. We've made much of our code open-source including our [vscode plugin repo](https://github.com/digma-ai/digma-vscode-plugin) (still under development) and our [Jetbrains plugin repo](https://github.com/digma-ai/digma-intellij-plugin) with an MIT license. 

## FAQ

* **Is this going to instrument my code and change it in creepy ways in production?** Absolutely not! We rely on the OpenTelemetry vanilla instrumentation with a few added attributes of our own. We leave your code untouched.
* **Do I need to make code changes to use Digma?** No! Digma will take care of collecting the observability data without any code changes.
* **Which platforms/stacks do you currently support?** We currently focus on [Java](https://www.java.com/en/) and [IntelliJ](https://www.jetbrains.com/idea/). Support for [**.NET**](https://dotnet.microsoft.com/en-us/) using [**Rider IDE**](https://www.jetbrains.com/rider/) is currently in early access mode. We'll expand to additional IDEs and languages later this year. If you'd like to be informed when Digma is available for your Stack the best way to do so is to [sign up](https://digma.ai/get-digma/) on our website for notification. 

<p style="text-align: center; margin-top: 2em;">
  <img src="/images/digma_logo_wingz.png" width="400" height="486">
</p>
