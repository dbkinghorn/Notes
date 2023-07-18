# Can You Run A State-Of-The-Art LLM On-Prem For A Reasonable Cost?

## Introduction
Since the release of OpenAI ChatGPT, and the ensuing mania/hype, a question that's been on everyone's mind is; **can you run a state-of-the-art Large Language Model on-prem?** With *your* data and *your* hardware? At a reasonable cost? The reasons for these questions include, 

- the cost of running a private access large language model on the cloud is prohibitively expensive
- paying for an LLM service access by-the-token can be expensive for large-scale use
- High-end GPU computing hardware is expensive and may not be justifiable for in-house exploratory research.
- **many companies do not want or cannot have their internal data posted to a cloud service!**

That last point is a serious barrier. LLMs' most interesting usage possibilities involve integration with your private data stores and internal communication/content. 

**So, can you run a large language model on-prem? Yes, you can!** 

I've been learning about and experimenting with LLM usage on a nicely configured quad GPU system here at Puget Systems for several weeks. My goal was to find out how much you can do on a system whose cost is within reach of many organizations and research groups (and some individuals). Let's see how it went!

## The Hardware
The system I've been experimenting with is configured as follows:
- CPU: Intel Xeon w9-3475X 36-core Sapphire Rapids
- RAM: 512GB DDR5 4800MHz Reg ECC
- Motherboard: ASUS PRO WS W790E-SAGE SE
- 2 x Sabrent Rocket 4 Plus 2TB PCIe Gen 4 M.2 SSD
- GPUs: 4 x NVIDIA RTX 6000 Ada Generation 48GB
- Ubuntu 22.04 LTS

This is a nice system and it's not cheap! But it's also not out of reach for many organizations and research groups. From my experiments, I think you could get away with 2 x RTX 6000Ada (or 2 x A6000) for research and development work and internal application testing. 2 x 48GB GPUs may be enough for some internal production use cases too. 

I'm using a variation of the [Puget Systems "Workstations for Machine Learning / AI"](https://www.pugetsystems.com/solutions/scientific-computing-workstations/machine-learning-ai/). We are currently qualifying the 4 x RTX 6000 Ada version of these systems with higher load power supplies.

## State of the art open source LLMs

The open-source and research community quickly accelerated progress on open LLMs and developer tools after the release of ChatGPT. The infamous leaked Google memo titled "We have no moat, and neither does OpenAI" (search for that) was an insightful reflection on how rapidly open research development would make progress on LLMs. For the past several months, new models and tools released almost every week. It's been a challenge trying to keep up! Better data curation more efficient training methods, and community efforts at instruct tuning have been increasing the quality and reducing the size of LLMs.

An interesting resource to keep track of open LLM development is the [HuggingFace Open LLM Leaderboard](https://huggingface.co/spaces/HuggingFaceH4/open_llm_leaderboard)

## Falcon-40b

Falcon-40b (instruct) is the current top LLM on the HuggingFace leaderboard. This model was developed at [Technology Innovation Institute](https://www.tii.ae/) in Abu Dhabi, United Arab Emirates. I find it delightful that this model was developed at an institution that may not be well-known to many people. Their [HuggingFace organization card](https://huggingface.co/tiiuae) is a good starting point for information on their LLM work. 

Falcon-40b is a 40 billion parameter LLM that performs better than many larger models. It's a good example of open-source innovation and improvement in this domain. It is licensed under the Apache 2.0 license. 

There is also an instruct-tuned model, falcon-40b-instruct, useful as a chat type of LLM. Others have also fine-tuned this model with other datasets. It's worth searching on HuggingFace for "falcon-40b" to see what's available.

### Inference 
The inference performance of falcon-40b-instruct on two RTX 6000Ada GPUs is good. Just a few seconds for a typical response to a prompt. The model is sharded across the two GPUs using nearly 90GB of GPU memory when using its native bfloat16 trained precision. (This model will not load on a single 80GB A100!)

The quality of the responses is very good, approaching that of ChatGPT for many prompts. I have tested responses using prompts from the [Deeplearning.ai short course ChatGPT Prompt Engineering for Developers](https://www.deeplearning.ai/short-courses/) (recommended!). Note that the model is trained on a different corpus than ChatGPT, and it is a much smaller model so the responses are different. However, a little prompt engineering can produce very good results.

I have also used this model and some other fine-tuned variants with the [HuggingFace Text-Generation-Inference server](https://github.com/huggingface/text-generation-inference). With the addition of a front web GUI this is suitable for production use! 

### Fine-tuning

Falcon 40b is available on HuggingFace with a base and instruct version. The base version is a good starting point for fine-tuning. [There are over 200 Falcon 40b and 7b models on HuggingFace](https://huggingface.co/models?pipeline_tag=text-generation&sort=trending&search=falcon) fine-tuned with various methods and datasets including sever tuned with the [Open-Assistant](https://github.com/LAION-AI/Open-Assistant) datasets. 

I have done fine-tuning testing with [Tim Dettmers openassistant-guanaco dataset](https://huggingface.co/datasets/timdettmers/openassistant-guanaco). 

**Note: 4 x RTX6000Ada does not provide enough GPU memory to do LoRA fine-tuning of falcon-40b using model native precision of bfloat16. I have been able to do fine-tuning using QLoRA 4-bit with [Tim Dettmers bitsandbytes](https://github.com/TimDettmers/bitsandbytes). That will train using 2 x RTX 6000Ada GPUs.**

## Conclusion and Recommendations

My primary recommendation is to **start!** The frenzy of development activity with open LLMs and associated tools is not going to slow down. The quality and diversity of the models and the tools are improving rapidly. 

I feel that a system with 2-4 RTX 6000Ada GPUs is an acceptable platform for useful work. Having a system on-prem for development work and experimentation is a good entry point for the new AI era. It may be all you need! It is possible to do research using smaller models with a more modest system configuration. I would say a system with an RTX 4090 or 3090 is minimal. If that's what you have, then use it! You could evaluate the feasibility of in-house application development and research, which would help you decide if you can justify a larger investment. 

I am certainly biased toward owning your hardware. I use the cloud too. But, I much prefer to have a system I can completely control, customize and use with in-house proprietary data.

I am really enjoying learning and working with this stuff! Expect to see related posts soon.

**Happy Computing! --dbk @dbkinghorn** 