Clone the GitHub repository on your personal device.

Open terminal. Using scp, transfer the file Figure5_execute.sh to the router, which is the network node tbf:

  scp <repository_home_dir>/fig5/Figure5_execute.sh  <CloudLab username>@<hostname of tbf>:~

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
  
After completion, switch to the terminal with host h1 logged in. Copy the data files to the home directory as follows:
  
  sudo cp -r /root/fig5 .

Use scp to transfer the data files to your personal device. 
  
  scp -r <CloudLab username>@<hostname of h1>:~/fig5 .    

On your personal device, move the visualization scripts and execute them as follows:
  
  cd ~/fig5
  
  sudo cp <clone directory of repository>/fig5/fig5_visualize.* .
  
  sh fig5_visualize.sh
  
  python3 fig5_visualize.py

Save the figures when prompted by Matplotlib. 
