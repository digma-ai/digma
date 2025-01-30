<p style="text-align: center;">
  <img src="/images/bg.jpg" >
</p>
<h1 style="text-align: center;">
  Use preemptive observability to nip production issues in the bud
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

Digma is a tool that profiles your application execution in runtime and identifies critical performance issues. Digma is comprised of an analysis backend (running locally on containers) and an IDE plugin as the main front end (Jetbrains only for now). The plugin provides code-level insights related to performance, query issues, bottlenecks scaling problems, and more. 

## :gear: How Digma works

Digma's backend receives OTEL data from your application (collected automatically when you run it locally), analyzes it, and identifies specific issues in the code execution. All of the data is handled locally in order to support compliance requirements and no code changes are required. Digma cam profile data from multiple environments, including dev, test, staging, production etc.

## 🚀 Getting started

### 1. Install the IDE Plugin
Get the Digma plugin from the [JetBrains marketplace](https://plugins.jetbrains.com/plugin/19470-digma-continuous-feedback). We currently support IntelliJ with either Java or Kotlin, support for additional IDEs is coming soon.

### 2. Follow the installation instructions in the plugin to get Digma up and running

**That's it!**  :tada:  As you start using your application and running your code, Digma will provide feedback and highlight issues over the code itself.

### Once you're up and running:
* #### Consider :star: this repo! It helps us know you care!
* Having issues? Questions? Want to suggest new ideas or discuss Digma with us? Join the [Digma community](https://continuous-feedback.slack.com/join/shared_invite/zt-2ebkq5qxs-Hpep2BFMfpxYTE9xq45w8A#/shared-invite/email)

## What does Digma look like?

You can check out some videos and more info on our [YouTube Channel](https://www.youtube.com/@digma1769/videos)! 

In short, we can use existing logs, traces, and metrics to answer questions such as:

* What are the top bottlenecks slowing this code down?
* How will this function scale?
* Which slow queries have the most impact on my application performance?
* Are there any issues introduced by the ORMs or 3rd party libraries

More importantly, all of these insights should be directly accessible in the IDE so we can use them while coding. 

![Digma HL Architecture](/images/architecture_light.png#gh-light-mode-only)![Digma HL Architecture](/images/architecture_dark.png#gh-dark-mode-only)

## The story behind Digma: :man_technologist::woman_technologist:

We believe that unless the application profiling is **continuous** and **automatic** - much like testing it won't be effective. There are many observability tools out there, however, they all require actively and manually spending time, attention, and expertise to get results. It is not surprising that they are used only reactively when something terrible happens. The end goal of observability should not be creating dashboards but improving our application and code. 

## How are you different from...

Well, we don't compete with any tool existing today because... There isn't any tool that aims to generate this type of feedback. We do work very well together with other tools looking at the same data, like Jaeger, Prometheus, and even traditional observability APMs like Datadog or Splunk. 

We are also not a static analysis tool. We profile the application execution in runtime rather than looking at the code and generating a ton of styling and rule-based issues.


## How can I learn more about Digma?

We started publishing some more detailed blog posts explaining what we are trying to accomplish. Here are a few examples:

- [CI/CD/CF? — The DevOps toolchain’s “missing-link”](https://digma.ai/blog/ci-cd-cf-the-devops-toolchains-missing-link-continuous-feedback/)

- [Effective Java Observability](https://digma.ai/blog/coding-with-java-observability/)

- [The Observant Developer](https://digma.ai/blog/the-observant-developer-part-1/)

For the full list, you can check out our [website blog](https://digma.ai/blog/)

If you're interested in the specific capabilities, product features, and technical specifications - check out our [docs](https://docs.digma.ai/)!

## FAQ

* **Is this going to instrument my code and change it in creepy ways in production?** Absolutely not! We rely on the OpenTelemetry vanilla instrumentation with a few added attributes of our own. We leave your code untouched.
* **Do I need to make code changes to use Digma?** No! Digma will take care of collecting the observability data without any code changes.
* **Does Digma send data to the cloud** No! We purposely run everything locally to avoid any issues with compliance policies.
* **Which platforms/stacks do you currently support?** We currently focus on [Java](https://www.java.com/en/) and [Kotlin](https://kotlinlang.org/) with [IntelliJ](https://www.jetbrains.com/idea/). Support for [**.NET**](https://dotnet.microsoft.com/en-us/) using [**Rider IDE**](https://www.jetbrains.com/rider/) is currently in early access mode. We'll expand to additional IDEs and languages later this year. 

