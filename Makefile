# Versões
KIND_VERSION ?= 0.18.0
GIROPOPS_SENHAS_VERSION ?= 1.0
GIROPOPS_LOCUST_VERSION ?= 1.0
ISTIO_VERSION ?= 1.17.1
CHAOS_MESH_VERSION ?= v2.5.1
KIALI_VERSION ?= 1.17
METALLB_VERSION ?= v0.13.9
KUBERNETES_DASHBOARD_VERSION ?= v2.7.0

# Tarefas principais
.PHONY: all
all: docker kind kubectl metallb kube-prometheus istio kiali argocd giropops-senhas giropops-locust chaos-mesh kubernetes-dashboard

# Instalação do Docker
.PHONY: docker
docker:
	@echo "Instalando o Docker..."
	@command -v docker >/dev/null 2>&1 || sudo curl -fsSL https://get.docker.com | bash

# Instalação do Kind
.PHONY: kind
kind:
	@echo "Instalando o Kind..."
	@comman -v kind >/dev/null 2>&1 || curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v$(KIND_VERSION)/kind-linux-amd64" && chmod +x ./kind && sudo mv ./kind /usr/local/bin/
	@while ! command -v kind >/dev/null 2>&1; do \
		sleep 1; \
	done
	@echo "Kind instalado com sucesso!"
	@echo "Criando o cluster..."
	@if [ -z "$$(kind get clusters | grep kind-linuxtips)" ]; then kind create cluster --name kind-linuxtips --config kind-config/kind-cluster-3-nodes.yaml; fi
	@echo "Cluster criado com sucesso!"

# Instalação do kubectl
.PHONY: kubectl
kubectl:
	@echo "Instalando o kubectl..."
	@command -v kubectl >/dev/null 2>&1 || (curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin/kubectl)
	@echo "Kubectl instalado com sucesso!"

# Login no ArgoCD
.PHONY: argo_login
argo_login:
	$(eval SENHA := $(shell kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d))
	@nohup kubectl port-forward svc/argocd-server -n argocd --address 0.0.0.0 8080:443 &
	@sleep 2
	@argocd login localhost:8080 --insecure --username admin --password $(SENHA)
	@echo "ArgoCD login realizado com sucesso!"

# Adiciona o cluster ao ArgoCD
.PHONY: add_cluster
add_cluster:
	$(eval IP_K8S_API_ENDPOINT := $(shell kubectl get endpoints kubernetes -o jsonpath='{.subsets[0].addresses[0].ip}' | head -n 1))
	$(eval CLUSTER := $(shell kubectl config current-context))
	$(eval PORT_ENDPOINT := $(shell kubectl get endpoints kubernetes -o jsonpath='{.subsets[0].ports[0].port}'))
	$(eval IP_K8S_IP := $(shell kubectl cluster-info | awk '{print $$7}' | head -n 1 | sed 's/\x1b\[[0-9;]*m//g' | sed 's/https:\/\///g'))
	@sed -i "s/https:\/\/$(IP_K8S_IP)/https:\/\/$(IP_K8S_API_ENDPOINT):6443/g" ~/.kube/config
	argocd cluster add --insecure -y $(CLUSTER)
	@echo "Cluster adicionado com sucesso!"

# Instalando e configurando o ArgoCD
.PHONY: argocd
argocd:
	@echo "Instalando o ArgoCD e o Giropops-Senhas..."
	if [ -z "$$(kubectl get namespace argocd)" ]; then kubectl create namespace argocd; fi
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
	sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
	rm argocd-linux-amd64
	kubectl wait --for=condition=ready --timeout=10m pod -l app.kubernetes.io/name=argocd-server -n argocd
	$(MAKE) argo_login
	$(MAKE) add_cluster
	ps -ef | grep -v "ps -ef" | grep kubectl | grep port-forward | grep argocd-server | awk '{print $$2}' | xargs kill
	kubectl label namespace default istio-injection=enabled
	kubectl label namespace argocd istio-injection=enabled
	@echo "ArgoCD foi instalado com sucesso!"

# Instalando o Giropops-Senhas
.PHONY: giropops-senhas
giropops-senhas:
	nohup kubectl port-forward svc/argocd-server -n argocd --address 0.0.0.0 8080:443 &
	$(eval CLUSTER := $(shell kubectl config current-context))
	sleep 2
	argocd app create giropops-senhas --repo https://github.com/badtuxx/giropops-senhas.git --path giropops-senhas --dest-name $(CLUSTER) --dest-namespace default
	argocd app sync giropops-senhas
	ps -ef | grep -v "ps -ef" | grep kubectl | grep port-forward | grep argocd-server | awk '{print $$2}' | xargs kill
	@echo "Giropops-Senhas foi instalado com sucesso!"

# Instalando o Giropops-Locust
.PHONY: giropops-locust
giropops-locust:
	nohup kubectl port-forward svc/argocd-server -n argocd --address 0.0.0.0 8080:443 &
	$(eval CLUSTER := $(shell kubectl config current-context))
	sleep 2
	argocd app create giropops-locust --repo https://github.com/badtuxx/giropops-senhas.git --path locust --dest-name $(CLUSTER) --dest-namespace default
	argocd app sync giropops-locust
	ps -ef | grep -v "ps -ef" | grep kubectl | grep port-forward | grep argocd-server | awk '{print $$2}' | xargs kill
	@echo "Giropops-Locust foi instalado com sucesso!"

# Instalando o Kube-Prometheus
.PHONY: kube-prometheus
kube-prometheus:
	@echo "Instalando o Kube-Prometheus..."
	git clone https://github.com/prometheus-operator/kube-prometheus || true
	cd kube-prometheus
	kubectl create -f kube-prometheus/manifests/setup
	until kubectl get servicemonitors; do sleep 1; done
	kubectl create -f kube-prometheus/manifests/
	kubectl wait --for=condition=ready --timeout=10m pod -l app.kubernetes.io/part-of=kube-prometheus -n monitoring
	kubectl apply -f prometheus-config/
	rm -rf kube-prometheus
	kubectl label namespace monitoring istio-injection=enabled
	@echo "Kube-Prometheus foi instalado com sucesso!"

# Instalando o MetalLB
.PHONY: metallb
metallb:
	@echo "Instalando o MetalLB..."
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/${METALLB_VERSION}/config/manifests/metallb-native.yaml
	kubectl wait --for=condition=ready --timeout=10m pod -l app=metallb -n metallb-system
	kubectl apply -f metallb-config/metallb-config.yaml
	@echo "MetalLB foi instalado com sucesso!"

# Instalando o Istio
.PHONY: istio
istio:
	@echo "Instalando o Istio..."
	curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=x86_64 sh -
	sleep 2
	./istio-1.17.1/bin/istioctl install --set profile=default -y
	kubectl label namespace default istio-injection=enabled
	kubectl wait --for=condition=ready --timeout=10m pod -l app=istiod -n istio-system
	rm -rf istio-${ISTIO_VERSION}
	@echo "Istio foi instalado com sucesso!"

# Instalando o Kiali
.PHONY: kiali
kiali: 
	@echo "Instalando o Kiali..."
	kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-${KIALI_VERSION}/samples/addons/kiali.yaml
	kubectl wait --for=condition=ready --timeout=10m pod -l app=kiali -n istio-system
	kubectl apply -f istio-config/
	kubectl rollout restart deployment kiali -n istio-system
	@echo "Kiali foi instalado com sucesso!"
	
# Instalando o Chaos Mesh
.PHONY: chaos-mesh
chaos-mesh:
	@echo "Instalando o Chaos Mesh Operator"
	curl -sSL https://mirrors.chaos-mesh.org/${CHAOS_MESH_VERSION}/install.sh | bash -s -- --local kind --name kind-linuxtips
	sleep 3
	@echo "Chaos Mesh instalado com sucesso!"

# Instalando o Kubernetes Dashboard
.PHONY: kubernetes-dashboard
kubernetes-dashboard:
	@echo "Instalando o Kubernetes Dashboard..."
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/${KUBERNETES_DASHBOARD_VERSION}/aio/deploy/recommended.yaml
	kubectl wait --for=condition=ready --timeout=10m pod -l k8s-app=kubernetes-dashboard -n kubernetes-dashboard
	kubectl apply -f dash-config/
	@echo "Kubernetes Dashboard instalado com sucesso!"
	@echo "Para criar o token de acesso ao Dashboard, execute o comando: make dashboard-token"

# Criando o token de acesso ao Kubernetes Dashboard
.PHONY: dashboard-token
dashboard-token:
	@echo "Criando o token de acesso ao Kubernetes Dashboard..."
	kubectl -n kubernetes-dashboard create token admin-user
	kubectl wait --for=condition=ready --timeout=10m pod -l k8s-app=kubernetes-dashboard -n kubernetes-dashboard
	@echo "Token criado com sucesso!"

# Removendo o Kind e limpando tudo que foi instalado
.PHONY: clean
clean:
	@echo "Desinstalando o Istio..."
	istioctl x uninstall --purge || true
	rm -rf istio-${ISTIO_VERSION} || true
	@echo "Istio desinstalado com sucesso!"
	@echo "Desinstalando o ArgoCD..."
	rm -f argocd-linux-amd64 || true
	sudo rm /usr/local/bin/argocd || true
	sudo rm -rf /etc/argocd /var/lib/argocd || true
	@echo "ArgoCD removido com sucesso!"
	@echo "Removendo o cluster do Kind..."
	kind delete cluster --name kind-linuxtips || true
	@echo "Cluster removido com sucesso!"
	@echo "Removendo diretórios kube-prometheus..."
	@sudo rm -r kube-prometheus