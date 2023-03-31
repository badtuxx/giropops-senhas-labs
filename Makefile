# Versões
KIND_VERSION ?= 0.14.0
GIROPOPS_SENHAS_VERSION ?= 1.0
GIROPOPS_LOCUST_VERSION ?= 1.0

# Tarefas principais
.PHONY: all
all: docker kind kubectl kube-prometheus argocd giropops-senhas giropops-locust 

# Instalação do Docker
.PHONY: docker
docker:
	@echo "Instalando o Docker..."
	@command -v docker >/dev/null 2>&1 || sudo curl -fsSL https://get.docker.com | bash
	@echo "Docker instalado com sucesso!"

# Instalação do Kind
.PHONY: kind
kind:
	@echo "Instalando o Kind..."
	@command -v kind >/dev/null 2>&1 || (curl -Lo ./kind https://kind.sigs.k8s.io/dl/v$(KIND_VERSION)/kind-linux-amd64 && chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind)
	@if [ -z "$$(kind get clusters | grep kind-linuxtips)" ]; then kind create cluster --name kind-linuxtips --config kind-config/kind-cluster-3-nodes.yaml; fi
	@echo "Kind instalado com sucesso!"

# Instalação do kubectl
.PHONY: kubectl
kubectl:
	@echo "Instalando o kubectl..."
	@command -v kubectl >/dev/null 2>&1 || (curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin/kubectl)
	@kubectl version
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
	kubectl wait --for=condition=ready --timeout=300s pod -l app.kubernetes.io/name=argocd-server -n argocd
	$(MAKE) argo_login
	$(MAKE) add_cluster
	ps -ef | grep -v "ps -ef" | grep kubectl | grep port-forward | grep argocd-server | awk '{print $$2}' | xargs kill
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
	git clone https://github.com/prometheus-operator/kube-prometheus
	cd kube-prometheus
	kubectl create -f kube-prometheus/manifests/setup
	sleep 10
	kubectl create -f kube-prometheus/manifests/
	rm -rf kube-prometheus
	@echo "Kube-Prometheus foi instalado com sucesso!"

# Removendo o Kind e limpando tudo que foi instalado
.PHONY: clean
clean:
	@echo "Removendo o Kind..."
	kind delete cluster --name kind-linuxtips
	@echo "Kind removido com sucesso!"