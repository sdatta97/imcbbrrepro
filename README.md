# imcbbrrepro
Replicability study on "When to use and when not to use BBR: An empirical analysis and evaluation study", ACM IMC 2019. Submitted for peer review and possible publication in the reproducibility track at ACM IMC 2023.

This code helps to run experiments on CloudLab to replicate and extend the results reported in Figures 5-8 the original paper. 

To reproduce this paper, first ensure you have an active project on the CloudLab testbed or you are collaborating with a researcher who has an active project. If you are new to CloudLab, complete the first two tasks of this tutorial (namely, Prepare your Workstation and Set up your account on CloudLab) : https://teaching-on-testbeds.github.io/hello-cloudlab/

Download the Python profile file provided with this repository: https://github.com/sdatta97/imcbbrrepro/blob/main/profile.py 

After you have an account on CloudLab, log in to your account, and from the Experiments tab select the option "Create Experiment Profile". In the Source Code section, select the "Upload File" option. Upload the downloaded profile.py file as asked above. Enter a suitable profile name and click on the Create button to create an experiment profile.

Now that the experiment profile is created, you can instantiate it to run an experiment. From the Experiments tab, select the option "Start experiment". Click on the Change Profile button to select the profile you created above, click on the Next button and follow the prompt to select the appropriate Ubuntu OS for your required experiment (18.04, 20.04, 22.04). Give an appropriate experiment name, select an available cluster and proceed to reserve resources by clicking Next. 

Once your resources are reserved and active, you can ssh into the network nodes and run experiments to reproduce the results reported in Figures 5-8 of the original paper using the instructions provided inside the corresponding directories (fig5-8). 
