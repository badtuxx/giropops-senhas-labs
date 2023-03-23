from locust import HttpUser, task, between

class Giropops(HttpUser):
    wait_time = between(1, 2)

    @task(1)
    def gerar_senha(self):
        self.client.post("/api/gerar-senha", json={"tamanho": 8, "incluir_numeros": True, "incluir_caracteres_especiais": True})


    @task(2)
    def listar_senha(self):
        self.client.get("/api/senhas")