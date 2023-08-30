::: {.cell .markdown}
## Replication: When to use and when not to use BBR: An empirical analysis and evaluation study

This experiment replicates Figure 5 of

> Yi Cao, Arpit Jain, Kriti Sharma, Aruna Balasubramanian, and Anshul Gandhi. 2019. When to use and when not to use BBR: An empirical analysis and evaluation study. In Proceedings of the Internet Measurement Conference (IMC '19). Association for Computing Machinery, New York, NY, USA, 130–136. https://doi.org/10.1145/3355369.3355579

and also extends it to a more recent version of BBRv1 and to BBRv2. 

:::


::: {.cell .markdown}

To run this experiment:

* **Prerequisites**: You should have a FABRIC account, be part of a FABRIC project, and have configured your FABRIC Jupyter environment, as in ["Hello, FABRIC"](https://teaching-on-testbeds.github.io/blog/hello-fabric). Then, `git clone` this repository in the FABRIC JupyterHub environment, navigate to the "fabric-notebooks" directory, and open the "fabric-run.ipynb" file.
* **Configuration**: Next, you need to edit some parts of this notebook, depending on the version of the experiment you want to run.
  * In the "Define configuration for this experiment" section, set the `slice_name` prefix - slice names must be unique, so if you are running multiple slices in parallel (for example, to validate the result for the three BBR versions in parallel slices), make each have a unique name.
  * In the "Define configuration for this experiment" section, set the `image` variable - "default_ubuntu_18" to validate the result in the original paper (4.15 kernel), "default_ubuntu_22" for a newer BBRv1 (5.15 kernel), or "default_ubuntu_20" for BBRv2 (will use 5.13 kernel).
  * If you are evaluating BBRv2, in the "Extra configuration for this experiment" section set `is_bbr2` to `True`. (Otherwise, leave it as `False`.)
  * If you are evaluating BBRv2, in the "Execute experiment" section set the `cc` in the `exp_factors` dictionary to `["cubic", "bbr2"]`. (Otherwise, leave it at `["cubic", "bbr"]`.)
  * If you are running multiple versions of this notebook in parallel, it's easiest to duplicate the notebook (right-click on the file in the JupyterHub file browser, choose Duplicate), configure the copy as described above, and execute the copy.
* **Execution**: Once you are ready, you'll want to run all of the cells in this notebook in order. An easy way to do this is to scroll to the "Delete your slice" section at the end, click on the cell that has the title of this section, and choose Run > Run All Above Selected Cell from the JupyterHub menu to run all cells until this point. 
  * In case there is a problem reserving resources (i.e. an infrastructure problem), you will want to delete your slice and try again. To do this, you would run the cells in the "Delete your slice" section, make sure your slice is deleted, then run the cells above that section again (using Run > Run All Above Selected Cell for convenience).
  * This full-factorial experiment design takes many hours to run. Once you have confirmed that the main loop in the "Execute experiment" section is running, you can leave this notebook running unattended.
  * Every 24 hours or less, your FABRIC JupyterHub session will time out, and you'll need to resume execution. When you get the alert that your server has stopped, you should: (1) Force restart your JupyterHub server: File > Hub Control Panel > Stop My Server, then Start Server. (2) Re-run the first few code cells, until you see the output "You already have a slice by this name!". (3) Scroll to the "Execute experiment" section and continue running cells in order from this point on.

:::
