document.addEventListener("DOMContentLoaded", () => {
    const loginForm = document.getElementById("loginForm");
    const loginMessage = document.getElementById("loginMessage");
    const cadastroForm = document.getElementById("cadastroForm");
    const cadastroMessage = document.getElementById("cadastroMessage");

    // --- Login ---
    loginForm.addEventListener("submit", async function(e){
        e.preventDefault();
        loginMessage.innerHTML = ""; // limpa mensagem anterior

        const usernome = document.getElementById("usernome").value;
        const senha = document.getElementById("senha").value;

        try {
            const response = await fetch("http://localhost/backend/api/auth/login.asp", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: new URLSearchParams({ usernome, senha })
            });
            const res = await response.json();

            if(res.success){
                sessionStorage.setItem("token", res.token);
                sessionStorage.setItem("userId", res.userId);
                sessionStorage.setItem("nome", res.nome);
                loginMessage.innerHTML = `<div class="alert alert-success">${res.message}</div>`;
                setTimeout(() => window.location.href = "pages/produtos.html", 800);
            } else {
                loginMessage.innerHTML = `<div class="alert alert-danger">${res.message}</div>`;
            }
        } catch(err){
            console.error(err);
            loginMessage.innerHTML = `<div class="alert alert-danger">Erro na requisição</div>`;
        }
    });

    // --- Cadastro ---
    cadastroForm.addEventListener("submit", async function(e){
        e.preventDefault();
        cadastroMessage.innerHTML = ""; // limpa mensagem anterior

        const nomeCompleto = document.getElementById("nomeCompleto").value;
        const novoUsuario = document.getElementById("novoUsuario").value;
        const novaSenha = document.getElementById("novaSenha").value;
        const confirmaSenha = document.getElementById("confirmaSenha").value;

        if(novaSenha !== confirmaSenha){
            cadastroMessage.innerHTML = `<div class="alert alert-danger">As senhas não coincidem!</div>`;
            return;
        }

        try {
            const response = await fetch("http://localhost/backend/api/auth/register.asp", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: new URLSearchParams({ nome: nomeCompleto, usernome: novoUsuario, senha: novaSenha })
            });
            const res = await response.json();

            if(res.success){
                cadastroMessage.innerHTML = `<div class="alert alert-success">${res.message}</div>`;
                const modal = bootstrap.Modal.getInstance(document.getElementById("cadastroModal"));
                setTimeout(() => {
                    modal.hide();
                    cadastroForm.reset();
                    cadastroMessage.innerHTML = "";
                }, 1000);
            } else {
                cadastroMessage.innerHTML = `<div class="alert alert-danger">${res.message}</div>`;
            }
        } catch(err){
            console.error(err);
            cadastroMessage.innerHTML = `<div class="alert alert-danger">Erro ao cadastrar usuário</div>`;
        }
    });
});
