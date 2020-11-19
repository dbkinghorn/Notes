# Power Limiting NVIDIA RTX30 GPUs on boot with nvidia-smi and systemd

## Introduction 
This is a follow up post to ["Quad RTX3090 GPU Wattage Limited "MaxQ" TensorFlow Performance"](https://www.pugetsystems.com/labs/hpc/Quad-RTX3090-GPU-Wattage-Limited-MaxQ-TensorFlow-Performance-1974/). In that post I presented TensorFlow ResNet50 performance results over a range of GPU wattage limits. The goal there was to find a power limit that would give 95% of the total performance at a system power load that is acceptable with a single PSU running on a US 110V 15A power line. It turns out that limiting the RTX3090's to 270W or 280W does that! The means that it should be reasonable to setup a Quad RTX3090 system for machine learning workloads. Performance was outstanding!

In the testing in the post mentioned above I used the NVIDIA System Management Interface tool, **nvidia-smi**, to set GPU power limits in the testing scripts. This post will show you a way to have GPU power limits set automatically at boot by using a simple script and a **systemd Unit file**  

I used Ubuntu 20.04 server as the OS for the performance testing and for the startup service testing in this post. However, any modern Linux distribution using systemd should be OK.

## nvidia-smi commands and a script to set a power limit on RTX30 GPU's

Here are a nvidia-smi commands,
   