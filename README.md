<!-- Place this tag in your head or just before your close body tag. -->
[![Medium Badge](https://img.shields.io/badge/Blog-black?style=flat&logo=medium&logoColor=white&link=https://medium.com/@roni-dover)](https://medium.com/@roni-dover)
[![Twitter Badge](https://badgen.net/badge/icon/twitter?icon=twitter&label)](https://twitter.com/doppleware)
[![made with love by digma-ai](https://img.shields.io/badge/made%20with%20%E2%99%A5%20by-digma-ff1414.svg?style=flat-square)](https://github.com/digma-ai)

<p align="center">
<img src="/images/bg.jpg" >
</p>

# What is Digma and why are we building it?	

## :man_technologist::woman_technologist:	 Digma is about *Developer Observability*

We believe that understanding code real-world requirements and behavior is critical to making better software. Something that can be done only if we connect the dots between design time and runtime.

There are many observability tools out there, they all take a very monitoring centric - 'live events capture' approach to observabilty. We feel they have managed to miss what developers care about when writing their code. 

Our goal is to create an **open platform** for interpreting and analyzing the information collected via observablity. Traces, logs, metrics are great! But additional effort is needed in order to take them that last mile into the development process.

## :bat: The Digma way: 

So how do we do that? How do we make observability relevant? Digma has three main design principles that we think are key in unlocking the potentional of observablity data.


> <p align="center"> <strong>Code Insights and analytics</strong> <em>over</emc> <strong>raw data</strong> </p>

Because if it takes time and manual work to check aggregate  correlate and understand the significance of raw logs and traces you'll probably not do it a lot :beach_umbrella:	

> <p align="center"> <strong>Proactive</strong> <em>over</em> <strong>Reactive</strong> </p>

Otherwise you won't know what to look for unless its already on  :fire:

> <p align="center"><strong>Integrated</strong> <em>over</em> <strong>external</strong> </p>

Because context switching is already an issue. Going back and forth between dashborts and :chart: is guaranteed to slow you down. 
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

* Where is this function called from, is it even used?
* Is this a problematic area of the code? Where are my bottlnecks? 
* What type of errors does this code raise in runtime, what issues are escalating? Which are affecting the end user?

More improtantly know whether sommething is important about the code we don't need to hop on another system, we can see that directly in the IDE as we are interactive with it. 

## How can I learn more about Digma?

We started publishing some more detailed blog posts explaining what we are trying to accomplish:

[CI-CD-CF The Devops Toolchain Missing Link](https://levelup.gitconnected.com/ci-cd-cf-the-devops-toolchains-missing-link-b5c88caf6282)

[Breaking the Fourth Wall in Coding](https://levelup.gitconnected.com/breaking-the-fourth-wall-in-coding-189055955c85)

### :tada: Join our Beta waitlist!

Visit our [beta invite page](https://lucent-biscochitos-0ce778.netlify.app/) to be a part of our early access beta. 

## How do I contribute or get involved, and are you guys even open-sourcing this?

We are committed to making Digma an Open Source platform. However, we are just getting started, and some of the code is not yet finalized enough yet to accept contributors. Currently we've made our [vscode plugin repo](https://github.com/digma-ai/digma-vscode-plugin)
public with an MIT license. We'll continue to add the additional repos as they become formalized enough to start working on them jointly.

## In the meantime...
### Consider :star: this repo! It helps us know you care!

### Join our community :classical_building:	

We are still debating where we want to host our community and which platform to use. In the meanwhile, if you want to get involved in the discussion please message us at community@digma.ai and we'll be happy to include you in some of our early discussion forums.

### Join as a contributor :octocat:	

If you are interested in being a contributor at this time, drop us a line!
We'll definitely be interested in talking to you and see how to get you more involved!

<p align="center">
<img src="/images/digma_logo_wingz.png" width="400" height="486">
</p>





