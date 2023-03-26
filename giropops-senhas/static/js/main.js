"use strict";

function showSenha() {
  const input = document.getElementById("senha");
  const senhaIcon = document.getElementById("senha-icon");
  if (input.attributes.type.nodeValue == "password") {
    input.setAttribute("type", "text");
    senhaIcon.innerText = "visibility_off";
  } else {
    input.setAttribute("type", "password");
    senhaIcon.innerText = "visibility";
  }
}
function copiarParaAreaDeTransferencia() {
  const senhaElemento = document.getElementById("senha");
  navigator.clipboard.writeText(senhaElemento.value).then(
    () => {
      alert("Senha copiada para a área de transferência!");
    },
    (err) => {
      alert("Não foi possível copiar a senha: " + err);
    }
  );
}

function toggleUsuarios() {
  const listaUsuariosContainer = document.getElementById(
    "lista-usuarios-container"
  );
  listaUsuariosContainer.classList.toggle("hidden");
}
function buscarUltimasSenhas() {
  fetch("/api/senhas")
    .then((response) => response.json())
    .then((senhas) => {
      const listaSenhas = document.getElementById("lista-senhas");
      listaSenhas.innerHTML = "";

      senhas.forEach((senha) => {
        const li = document.createElement("li");
        li.textContent = `Senha: ${senha.senha}`;
        listaSenhas.appendChild(li);
      });
    });
}
