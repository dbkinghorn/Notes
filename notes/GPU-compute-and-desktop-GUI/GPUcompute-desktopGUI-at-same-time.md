## Can you use a single GPU for computing and desktop GUI at the same time?

Just a little more background (and start of a post). You could pass this on to the customer if you like.

Thinking that having a desktop running on the GPU you are using for computation will slow down the GPU compute performance is a common belief. And, it's not wrong!

The thing is, from my observations, it's generally a small impact. Something around 1-3% on a modern high-end GPU with >4GB of memory that is running a "normal" desktop + editor + terminal + browser + a few small utility programs on a "standard" resolution monitor. The impact is usually greater on Windows than Linux because the Windows desktop is generally more "greedy" with resources.

A very heavy, long-running compute load on the GPU can interfere with desktop use, causing mouse lag, slow window movement and things like that. In cases where that becomes annoyingly disruptive to your workflow, having a secondary GPU for display can be a good thing as long as CPU resources are not also being heavily impacted at the same time. If the workstation is just crawling then it's worth considering having a secondary system for temporary desktop use and moving the GPU compute platform to more of a compute-server-with-GUI role.

In the early days of GPU compute only Linux was being used seriously and it was common practice to reboot the machine into a text mode terminal display before starting up a large GPU job. I would have scripts setup to do this automatically. (There was some configuration setup needed to run GPU compute "head-less" in the early days too but that's no longer a problem.)

I'm going to save this little "blab" as the start of a blog post with a title something like
"Can you use a single GPU for computing and desktop GUI at the same time?"
I'll do some performance testing to quantify the impact in different scenarios. :-) --Don
