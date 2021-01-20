# Does Enabling WSL2 Affect Performance of Windows 10 Applications

## Introduction

The "Windows Subsystem for Linux", WSL, is one of the most interesting projects that Microsoft has ever implemented (in my opinion). Version 2 of WSL (WSL2) is even using a Linux kernel put together by Microsoft. You could probably call this "Microsoft Linux" without too much stretch of the imagination. This kernel replaces the kernel used in the Linux distributions that are installed into WSL2. 

WSL2 offers improved performance over version 1 by providing more direct access to the host hardware drivers. Network and storage system performance in particular is greatly improved. Recent "Insider Dev Channel" builds of Win10 even allows access to the Windows NVIDIA display driver for GPU computing applications for WSL2 Linux applications! The performance improvements with WSL2 are largely because this version is running as a privileged virtual machine on to of MS Hyper-V. This means that at least low level support for the Hyper-V virtualization layer needs to be enabled to use it. In particular, **the Windows feature "VirtualMachinePlatform" must be enabled for WSL2**.

**So what? Why would enabling "VirtualMachinePlatform" for WSL2 support be a concern?**

Here's why;  

When you enable "VirtualMachinePlatform" you have to reboot... After the reboot your Windows system is now a privileged virtual machine, VM-0, running on top of Hyper-V. Hyper-V is a "type 1" hypervisor. That means it is running as a virtualization layer directly on the bare-metal hardware. (like VMware ESXi for example) Your "host" Windows OS is running in a special Virtual Machine on top of that. This "could" potentially have negative effects on application performance on the host.  

Note: "VirtualMachinePlatform" is not "full" Hyper-V. To completely enable Hyper-V, so that you could create and manage VM's, you also need to enable the feature, ...you guessed it, "Hyper-V".

 This leads to the question...

## Does enabling WSL2 have a negative impact on Windows 10 applications caused by the need to enable "VirtualMachinePlatform"?

... **essentially NO**, but read on to see what we actually looked at with our tests.

I have been using a WSL2 a lot when I am working on a Windows 10 system. I find it makes development work MUCH more pleasant. I connect to it from the new Windows Terminal application and from VScode using an extension specifically for that purpose. ... I like it!

I don't notice any negative effects on "native" application performance. However, I was curious to see if "not noticing any effect" would hold up to actually application benchmark testing.  

**My "Puget Systems Labs" colleague William George graciously agreed to run our Windows test/benchmark suite on a Windows 10 system with and without WSL2 enabled and active.** 

## Test platform
...
**William I need your input here**

## Results

The following table lists "summary results" for the various benchmarks that were run. (There were 367 individual benchmark "Result Types" in the original spreadsheet!) There were 2 test runs, both without WSL2 and VirtualMachinePlatform enabled (and active). The finial performance evaluation is the percent difference of the "with" and "without" result averages.

**Note: The testing runs do not "use" WSL2. It's just that WSL2 and VirtualMachinePlatform is enabled for comparison.** 

<style>
  table.blogtable {
    width: 95%;
    font-size: 14px;
    font-family: Helvetica, Arial, sans-serif;
    border-collapse: collapse;
    table-layout: fixed;
    margin: 4px 0 ;
    border-bottom: 2px solid #333;
  }

  h3.tableheading {
    margin-bottom: 20px;
  }

  table.blogtable thead th {
    background: #333;
    color: #fff;
  }

  table.blogtable th,td {
    padding: 8px 4px;
  }

  table.blogtable thead th {
    text-align: left;
  }

  table.blogtable tbody th {
    text-align: left;
  }

  table.blogtable tbody tr {
    color: #333;
  }
  table.blogtable tbody tr:hover {
    color: #960;
  }

  table.blogtable tbody tr:nth-child( even ) {
    background: #eee;
  }

  table.blogtable tbody col:nth-child(1) {
    white-space: nowrap;
  }
  </style>

<table class="blogtable">
<thead>

<tr><th>Benchmark Application                                   </th><th>Result Type                        </th><th> Win10 #1</th><th> Win10 #2</th><th> Win10 w/<br> WSL2 #1</th><th> Win10 w/<br> WSL2 #2</th><th> Average Difference <br> WSL2 enabled</th></tr>
</thead>
<tbody>
<tr><td>PugetBench for Photoshop 0.9 (Photoshop 21.1.3)         </td><td> Overall Score                     </td><td> 995     </td><td> 993     </td><td> 999             </td><td> 999             </td><td> +0.50%</td></tr>
<tr><td>PugetBench for Lightroom Classic 0.91 (LR Classic 9.2)  </td><td> Overall Score                     </td><td> 1122    </td><td> 1118    </td><td> 1116.5          </td><td> 1121.5          </td><td> -0.09%</td></tr>
<tr><td>PugetBench for Premiere Pro 0.9 (Premiere Pro 14.2.0)   </td><td> Standard Overall Score            </td><td> 862     </td><td> 874     </td><td> 861             </td><td> 859             </td><td> -0.93%</td></tr>
<tr><td>PugetBench for Premiere Pro 0.9 (Premiere Pro 14.2.0)   </td><td> Standard Export Score             </td><td> 96.1    </td><td> 98      </td><td> 95              </td><td> 95.2            </td><td> -2.03%</td></tr>
<tr><td>PugetBench for Premiere Pro 0.9 (Premiere Pro 14.2.0)   </td><td> Standard Live Playback Score      </td><td> 76.3    </td><td> 76.8    </td><td> 77.1            </td><td> 76.6            </td><td> +0.39%</td></tr>
<tr><td>PugetBench for After Effects 0.9 (After Effects 17.1x72)</td><td> Overall Score                     </td><td> 1056    </td><td> 1064    </td><td> 985             </td><td> 1082            </td><td> -2.53%</td></tr>
<tr><td>PugetBench for AERender 0.9 (After Effects 17.1x72)     </td><td> Overall Score                     </td><td> 1024    </td><td> 1007    </td><td> 999             </td><td> 985             </td><td> -2.34%</td></tr>
<tr><td>PugetBench for DaVinci Resolve V0.8 BETA (DR 16.0.0.60) </td><td> 4K Overall Score                  </td><td> 1118    </td><td> 1118    </td><td> 1111            </td><td> 1120            </td><td> -0.22%</td></tr>
<tr><td>GeekBench3                                              </td><td> GeekBench Score Overall Multi Core</td><td> 55310   </td><td> 55377   </td><td> 55487           </td><td> 55480           </td><td> +0.25%</td></tr>
<tr><td>NeatBench (Neat Image 8.5.0 - Neat Video 5.1.0)         </td><td> Max CPU and GPU Result            </td><td> 39.9    </td><td> 39.4    </td><td> 39.8            </td><td> 39.3            </td><td> -0.25%</td></tr>
<tr><td>NeatBench (Neat Image 8.5.0 - Neat Video 5.1.0)         </td><td> Max Peak CPU Only Result          </td><td> 25.6    </td><td> 25.5    </td><td> 25.6            </td><td> 25.6            </td><td> +0.20%</td></tr>
<tr><td>CineBench R15.038                                       </td><td> CPU Render Multi Core             </td><td> 3118.4  </td><td> 3118.2  </td><td> 3122.3          </td><td> 3132.3          </td><td> +0.29%</td></tr>
<tr><td>Cinebench R20.060                                       </td><td> CPU Render CB Score               </td><td> 7058.77 </td><td> 7060.13 </td><td> 7074.5          </td><td> 7072.27         </td><td> +0.20%</td></tr>
<tr><td>OctaneBench 4.02.1                                      </td><td> Total score                       </td><td> 311.9   </td><td> 310.6   </td><td> 311.2           </td><td> 310.2           </td><td> -0.18%</td></tr>
<tr><td>OctaneBench 2019                                        </td><td> Total Score RTX On                </td><td> 1020    </td><td> 1020.8  </td><td> 1016.5          </td><td> 1017            </td><td> -0.36%</td></tr>
<tr><td>OctaneBench 2019                                        </td><td> Total Score RTX Off               </td><td> 309.1   </td><td> 309     </td><td> 309.2           </td><td> 309.4           </td><td> +0.08%</td></tr>
<tr><td>V-Ray Benchmark 1.0.8                                   </td><td> CPU                               </td><td> 47      </td><td> 47      </td><td> 47              </td><td> 47              </td><td> +0.00%</td></tr>
<tr><td>V-Ray Benchmark 1.0.8                                   </td><td> GPU                               </td><td> 49      </td><td> 49      </td><td> 48              </td><td> 48              </td><td> -2.06%</td></tr>
<tr><td>V-Ray Next Benchmark 4.10.06                            </td><td> CPU Mode All CPUs                 </td><td> 19744   </td><td> 19379   </td><td> 19627           </td><td> 19553           </td><td> +0.15%</td></tr>
<tr><td>Pix4D 4.5.6                                             </td><td> Rock Model Total                  </td><td> 264     </td><td> 265     </td><td> 265             </td><td> 263             </td><td> -0.19%</td></tr>
<tr><td>Pix4D 4.5.6                                             </td><td> School Map Total                  </td><td> 736     </td><td> 737     </td><td> 732             </td><td> 730             </td><td> -0.75%</td></tr>
<tr><td>Redshift 2.6.41                                         </td><td> Render Time Age of Vultures Scene </td><td> 489     </td><td> 497     </td><td> 489             </td><td> 491             </td><td> -0.61%</td></tr>
<tr><td>RealityCapture 1.0.3.10403                              </td><td> Rock Model Total                  </td><td> 179.5   </td><td> 179.7   </td><td> 180             </td><td> 181             </td><td> +0.50%</td></tr>
<tr><td>RealityCapture 1.0.3.10403                              </td><td> School Map Total                  </td><td> 416.7   </td><td> 417.4   </td><td> 421.7           </td><td> 415.9           </td><td> +0.42%</td></tr>

</tbody>
</table>
<br>

**Notes:**
- The results with (+) are where the test with WSL2 enabled was faster and (-) where the test was slower.
- You can see from the testing that there was negligible impact on performance. 
- There are a few places where there was a performance drop around 2%. That could be a "real" performance drop or just normal variation. However, all of the results greater than 2% were negative.    

## Conclusion

Again, I'd like to thank William George for running the test suite! 

The testing results should ease worries about native application performance degradation caused by enabling WSL2. Even if there is a small drop in performance for some applications it is worth the trade-off in my opinion. However, **we did not do any direct gaming performance testing!** It is *not* because we are not gamers, most of us are, including myself, we just don't do that kind of testing at Puget Systems. If any **objective** gaming testing conducted in a similar way to what we did in this post then put a link in the comments.        



