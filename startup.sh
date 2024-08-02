#!/bin/bash
curl -L https://tljh.jupyter.org/bootstrap.py | sudo python3 --admin admin
    
# basics
sudo apt update 
sudo apt install -y git make wget curl bison vim fish ncdu rsync bmon slurm tcptrack pipx
# gcloud dependencies
sudo apt-get install apt-transport-https ca-certificates gnupg curl

# gh
sudo snap install gh

# install and configure IAP authentication
sudo /opt/tljh/hub/bin/python -m pip install git+https://github.com/tly1980/jupyterhub-gcp-iap-authenticator.git

# download config (there is an error in the manual congiguration approach, shown below,
# because it stips the quotes. So we must pull from a Gist).
sudo wget https://gist.githubusercontent.com/alexgoodell/2e76a0ae2bfb25dccf63aa02c9584887/raw/config.yaml -O /opt/tljh/config/config.yaml
#sudo tljh-config unset auth
#sudo tljh-config set auth.type gcpiapauthenticator.gcpiapauthenticator.GCPIAPAuthenticator
#sudo tljh-config set auth.GCPIAPAuthenticator.project_id som-etheroptime
#sudo tljh-config set auth.GCPIAPAuthenticator.project_number '943740418632'
#sudo tljh-config set auth.GCPIAPAuthenticator.backend_service_id '3685127254962691613'
#sudo tljh-config show
#sudo tljh-config reload

# sudo usermod -a -G adm,google-sudoers jupyter-agoodell
sudo tljh-config add-item users.admin jupyter-jason959
sudo tljh-config add-item users.admin jupyter-agoodell
sudo tljh-config add-item users.admin jupyter-lchu
sudo tljh-config add-item users.admin jupyter-darar

# reload
sudo tljh-config reload

# place folder to be replicated to all users in /etc/skel
git clone https://github.com/stanfordaimlab/aimlab-cloud-tutorials.git /etc/skel/tutorials

echo "DONE WITH CONFIGURATION"
# --- setup virtual environments

# we will set up virtual environments in /srv/venvs using conda
# install conda to the system environment (to avoid messing with user or hub env)

# install miniconda to /home/setup/miniconda3
#sudo wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /home/setup/miniconda.sh
#bash /home/setup/miniconda.sh -b -p /home/setup/miniconda


# Python locations
# system python (used for installation) is located at /bin/python3
# hub python (used for managing web app) is located at /opt/tljh/hub/bin/python
# user python (default environment for user) is at /opt/tljh/user/bin/python

/opt/tljh/user/bin/python -m pip install --upgrade pip
/opt/tljh/user/bin/python -m pip install pandas
/opt/tljh/user/bin/python -m pip install matplotlib

echo "------------ Creating setup user -------------"
sudo useradd -r --create-home -G adm,google-sudoers setup
sudo su setup
cd /home/setup

echo "------------ Downloading GCP -------------"
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg -y --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get update && sudo apt-get install google-cloud-cli
gcloud init

# now you have /home/setup/miniconda3/bin/conda
# and
# /home/setup/miniconda3/bin/conda-env
# available



