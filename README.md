<!-- Place this tag in your head or just before your close body tag. -->
[![Medium Badge](https://img.shields.io/badge/Blog-black?style=flat&logo=medium&logoColor=white&link=https://medium.com/@roni-dover)](https://medium.com/@roni-dover)
[![Twitter Badge](https://badgen.net/badge/icon/twitter?icon=twitter&label)](https://twitter.com/doppleware)
[![made with love by digma-ai](https://img.shields.io/badge/made%20with%20%E2%99%A5%20by-digma-ff1414.svg?style=flat-square)](https://github.com/digma-ai)

<p align="center">
<img src="/images/bg.jpg" >
</p>

# What is Digma and why are we building it?	

## :man_technologist::woman_technologist:	 Digma is about *Developer Observability*

We believe that understanding code, real-world requirements, and behavior is critical to making better software. Something that can be done only if we connect the dots between design time and runtime.

There are many observability tools out there, they all take a very monitoring centric - 'live events capture' approach to observability. We feel they have managed to miss what developers care about when writing their code. 

Our goal is to create an **open platform** for interpreting and analyzing the information collected via observability. Traces, logs, metrics are great! But additional effort is needed in order to take them that last mile into the development process.

## :bat: The Digma way: 

So how do we do that? How do we make observability relevant? Digma has three main design principles that we think are key in unlocking the potential of observability data.


> ###### **Code Insights and analytics** *over* Raw data

Because, if it takes time and manual work to check, aggregate, correlate, and understand the significance of raw logs and traces, you'll probably not do it a lot :beach_umbrella:	

> ###### **Proactive** *over* Reactive

Otherwise you won't know what to look for unless its already on  :fire:

> ###### **Integrated** *over* external

Because context switching is already an issue. Going back and forth between dashboards and charts is guaranteed to slow you down. 
## :gear: How does Digma work?

It is a pipeline. A continuous feedback pipeline that injects data from your observability :telescope: sources and generates feedback.

![Digma HL Architecture](/images/architecture_light.png#gh-light-mode-only)![Digma HL Architecture](/images/architecture_dark.png#gh-dark-mode-only)


## How are you different from...

Well we don't compete with any tool existing today because... There isn't any tool that aims to generate this type of feedback. We do work very well together with other tools looking at the same data, like Jaeger, Prometheus, even traditional observability tools like Datadog or Splunk. There are plenty of tools that try to offer troubleshooting/debugging capabilities (once an issue is already identified) or give some raw realtime data. This is not where our headspace is at.

At the time of this writing, most of the data Digma collects is OpenTelemetry based. In the future we will definitely be able to ingest data from other technologies as well such as eBPF or even CloudWatch.

<p align="center">
<img src="/images/digmaloveotel.png" width="500" height="200">
</p>

## Can you give me some examples?

We understand that Digma may sound abstract :art: 
We have created a short video that demonstrates what the product does which you can find here:

<p align="center">

[![Digma in practice](/images/video-s.png)](https://youtu.be/MnJIyVVqPDU "Digma in Practice")

</p>

In short, we can use existing logs, traces and metrics to answer questions such as:

* Where is this function called from? Is it even used?
* Is this a problematic area of the code? Where are my bottlenecks? 
* What type of errors does this code raise in runtime? What issues are escalating? Which are affecting the end user?

More importantly, all of these insights should be directly accessible in the IDE so we can use them while writing code.. 

## Running Digma Locally 

Digma is not yet released but you can already download and play around with it.  There are three steps to get Digma up and running:

1. Install the IDE Plugin from the [marketplace](https://marketplace.visualstudio.com/items?itemName=digma.digma), as of now vscode is supported but other IDEs plugin are in progress
2. Start the Digma backend locally via the Docker Compose file included [here](https://github.com/digma-ai/digma/blob/main/docker/docker-compose.yml).
```bash
curl https://raw.githubusercontent.com/digma-ai/digma/main/docker/docker-compose.yml --output docker-compose.yml
docker compose up -d
```
3. Add 1-2 lines of code to add Digma to your OTEL exporters, Digma also adds a few attributes to your spans to align them with code locations. 
You can find detailed instructions for [Python](https://github.com/digma-ai/opentelemetry-instrumentation-digma), [Django](https://github.com/digma-ai/opentelemetry-instrumentation-digma-django) and [.NET](https://github.com/digma-ai/OpenTelemetry.Instrumentation.Digma). More guides will be updated soon.

That's it! As you start using you application and accumulating trace data, Digma will start showing insights in the IDE sidepane.

<img width="485" alt="image" src="https://user-images.githubusercontent.com/93863/170363819-8343fc49-3791-4c9b-afee-a4af9d55e11d.png">


## Do you have any example applications I can clone?

We have a few listed here, we are working on adding more!

* [DotNet Sample Application](https://github.com/digma-ai/otel-sample-application-dotnet)
* [Django Sample Application](https://github.com/digma-ai/otel-sample-django-application)
* [FastAPI Sample Application](https://github.com/doppleware/gringotts-vault-api)

## How can I learn more about Digma?

We started publishing some more detailed blog posts explaining what we are trying to accomplish. Here are some examples:

[CI-CD-CF The Devops Toolchain Missing Link](https://levelup.gitconnected.com/ci-cd-cf-the-devops-toolchains-missing-link-b5c88caf6282)

[You're never done. By definition.](https://betterprogramming.pub/youre-never-done-by-definition-c04ac77c616b)

[The Observant Developer](https://betterprogramming.pub/the-observant-developer-part-1-1939d53fd5a4)


### :tada: Join our Beta waitlist!

Visit our [beta invite page](https://www.digma.ai/) to be a part of our early access beta. 

## How do I contribute or get involved, and are you guys even open-sourcing this?

We are committed to making Digma an Open Source platform. However, we are just getting started, and some of the code is not yet finalized enough yet to accept contributors. Currently we've made our [vscode plugin repo](https://github.com/digma-ai/digma-vscode-plugin)
public with an MIT license. We'll continue to add the additional repos as they become formalized enough to start working on them jointly.

## ⏲️ In the meantime...
### Consider :star: this repo! It helps us know you care!

### Join our community :classical_building:	

We are still debating where we want to host our community and which platform to use. In the meanwhile, if you want to get involved in the discussion please message us at community@digma.ai and we'll be happy to include you in some of our early discussion forums.

### Join as a contributor :octocat:	

If you are interested in being a contributor at this time, drop us a line!
We'll definitely be interested in talking to you and see how to get you more involved!


## FAQ

* **Is this going to instrument my code and change it in creepy ways in production?** Absolutely not! We rely on the OpenTelemetry vanilla instrumentation with a few added attributes of our own. We leave your code untouched.
* **Do I need to make code changes to use Digma?** If you're already using OpenTelemetry, you're good to go. If you are not yet using it, we should be a part of your stack if you're considering adding observability to your code!
* **Can I use Digma right now?** We haven't opened the flood gates just yet, but you are welcome to sign on to our beta program (via [this link](https://wwww.digma.ai)) or drop us a line if you want to be a part of the alpha.
* **Which platforms/stacks do you currently support?** We have a limited set of language specific components, but, for the sake of focus, we currently support [**.NET**](https://dotnet.microsoft.com/en-us/) and [**Python**](https://www.python.org/) over [**Visual Studio Code**](https://code.visualstudio.com/). Over the next month, we'll add [**Jetbrains IDEs**](https://www.jetbrains.com/) and [**GoLang**](https://go.dev/) which are already in progress. If you're using other stacks you wish to see supported, please sign on to the beta and fill our survey - we're definitely taking your responses into consideration.

<br>

<p align="center">
<img src="/images/digma_logo_wingz.png" width="400" height="486">
</p>






