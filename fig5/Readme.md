Clone the GitHub repository on your personal device.

Open terminal. Using scp, transfer the file Figure5_execute.sh to the router, which is the network node tbf:
  scp <repository_home_dir>/fig5/Figure5_execute.sh  <CloudLab username>@<hostname of tbf router>:~

Open another terminal and log in to the router, tbf. Install screen using the following commands:
  sudo apt update
  sudo apt install -y screen

Open two other terminals, and use one each to log in to the end hosts, network nodes h1 and h3. Install iperf3 using the following commands:
  sudo apt update
  sudo apt install -y iperf3
  
Switch to the terminal with router tbf open. Use the following commands to open a screen and execute the script:
  screen -S fig5
  sh Figure5_execute.sh

Press the key combination Cmd/Ctrl+A+D to safely exit the screen and let the experiment run till completion.
