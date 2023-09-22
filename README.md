# Replication: When to Use and When Not to Use BBR

This repository contains the artifacts for 

> Soumyadeep Datta and Fraida Fund. 2023. Replication: “When to Use and When Not to Use BBR”. In Proceedings of the 2023 ACM Internet Measurement Conference (IMC ’23), October 24–26, 2023,
Montreal, QC, Canada. ACM, New York, NY, USA. https://doi.org/10.1145/3618257.3624837

which replicates part of the results in

> Yi Cao, Arpit Jain, Kriti Sharma, Aruna Balasubramanian, and Anshul Gandhi. 2019. When to use and when not to use BBR: An empirical analysis and evaluation study. In Proceedings of the Internet Measurement Conference (IMC '19). Association for Computing Machinery, New York, NY, USA, 130–136. https://doi.org/10.1145/3355369.3355579

### Reproducing the figures using our experiment data

You can use our experiment data directly to generate the figures in our replication paper. Use the materials inside the `data` directory, or: [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/sdatta97/imcbbrrepro/blob/main/data/imc_bbr_repo_data_analysis.ipynb)

### Recreating our experiment and generating data on FABRIC

You can use the materials in this repository to recreate our experiment on the [FABRIC](https://fabric-testbed.net/) testbed and generate new data yourself. Assuming you already have a FABRIC account, have set it up, and are part of a project (if not, see [Hello, FABRIC](https://teaching-on-testbeds.github.io/hello-fabric/)), you can open the FABRIC Jupyter environment, and in a new terminal, run:

```
git clone https://github.com/sdatta97/imcbbrrepro
```

then open the `fabric-run.ipynb` notebook inside the `fabric-notebooks` directory. Follow the instructions in that notebook to configure your experiment, then run it.

### Recreating our experiment and generating data on CloudLab

You can use the materials in this repository to recreate our experiment on the [CloudLab]([https://fabric-testbed.net/](https://cloudlab.us/)) testbed and generate new data yourself. Assuming you already have a CloudLab account, have set it up, and are part of a project (if not, see [Hello, CloudLab](https://teaching-on-testbeds.github.io/hello-cloudlab/)), you can instantiate an experiment using the link: 

[https://www.cloudlab.us/p/nyunetworks/bbr-when-to-use](https://www.cloudlab.us/p/nyunetworks/bbr-when-to-use)

Select the Ubuntu 18.04 disk image to reproduce our replication, or the Ubuntu 20.04 disk image to reproduce our extension to BBRv2. Then, continue to reserve resources and start your experiment on any cluster.

Once your resources are reserved and active, you can SSH into each of the nodes and run experiments using the instructions provided inside the `cloudlab-materials` directory.

--- 

This material is based upon work supported by the National Science Foundation under Grant No. 2226408. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation.
