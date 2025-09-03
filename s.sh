# Update system packages
sudo apt-get update

# Install Docker
sudo apt install -y docker.io

# (Optional/Not secure for production) Change Docker socket permissions
sudo chmod 666 /var/run/docker.sock

# Install required dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

# Create keyrings directory
sudo mkdir -p -m 755 /etc/apt/keyrings

# Download Kubernetes GPG key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes apt repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | \
sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update package lists
sudo apt update

# Install Kubernetes components (v1.30.0)
sudo apt install -y kubeadm=1.30.0-1.1 kubelet=1.30.0-1.1 kubectl=1.30.0-1.1

# Prevent automatic upgrades of kubeadm, kubelet, kubectl
sudo apt-mark hold kubeadm kubelet kubectl