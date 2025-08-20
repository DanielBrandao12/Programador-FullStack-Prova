const API_URL = "http://localhost/backend/api/products/index.asp";
const tbody = document.querySelector("#produtosTable tbody");
const alertArea = document.getElementById("alertArea");
const usuarioLogado = sessionStorage.getItem("nome");

// Verifica token ao carregar a página
document.addEventListener("DOMContentLoaded", () => {
    const token = sessionStorage.getItem("token");
    if (!token) {
        window.location.href = "index.html";
    }
});

// Exibe alertas
function showAlert(msg, type = "success", timeout = 3000) {
    alertArea.innerHTML = `
        <div class="alert alert-${type} alert-dismissible fade show" role="alert">
            ${msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `;
    if (timeout) setTimeout(() => (alertArea.innerHTML = ""), timeout);
}

// Renderiza tabela
function renderProdutos(produtos) {
    tbody.innerHTML = "";
    produtos.forEach((p) => {
        const tr = document.createElement("tr");
        tr.innerHTML = `
            <td>${p.id}</td>
            <td>${p.nome}</td>
            <td>${p.preco}</td>
            <td>${p.quantidade}</td>
            <td>${p.datacadastro}</td>
            <td>
                <button class="btn btn-sm btn-dark me-2" onclick="editarProduto(${p.id}, '${p.nome}', ${p.preco}, ${p.quantidade})">
                    <i class="bi bi-pencil"></i> Editar
                </button>
                <button class="btn btn-sm btn-dark" onclick="deletarProduto(${p.id})">
                    <i class="bi bi-trash"></i> Excluir
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

// Carrega produtos (GET)
async function carregarProdutos() {
    try {
        const res = await fetch(API_URL);
        const data = await res.json();
        if (data.success) {
            renderProdutos(data.data);
        } else {
            showAlert(data.message, "danger");
        }
    } catch (err) {
        console.error(err);
        showAlert("Erro ao carregar produtos", "danger");
    }
}

// Salvar produto (POST ou PUT)
async function salvarProduto(e) {
    e.preventDefault();

    const id = document.getElementById("produtoId").value;
    const nome = document.getElementById("nome").value;
    const preco = document.getElementById("preco").value;
    const quantidade = document.getElementById("quantidade").value;

    const body = new URLSearchParams({
        nome,
        preco,
        quantidade,
        usuario: usuarioLogado
    });

    let method = "POST";
    if (id) {
        body.append("_method", "PUT");
        body.append("id", id);
        method = "POST"; // ASP lê _method
    }

    try {
        const res = await fetch(API_URL, {
            method,
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body,
        });

        const data = await res.json();
        if (data.success) {
            showAlert(data.message || "Produto salvo!");
            carregarProdutos();
            bootstrap.Modal.getInstance(document.getElementById("produtoModal")).hide();
            document.getElementById("produtoForm").reset();
        } else {
            showAlert(data.message, "danger");
        }
    } catch (err) {
        console.error(err);
        showAlert("Erro ao salvar produto", "danger");
    }
}

// Editar
function editarProduto(id, nome, preco, quantidade) {
    document.getElementById("produtoId").value = id;
    document.getElementById("nome").value = nome;
    document.getElementById("preco").value = preco;
    document.getElementById("quantidade").value = quantidade;

    const modal = new bootstrap.Modal(document.getElementById("produtoModal"));
    modal.show();
}

// Deletar produto (DELETE)
async function deletarProduto(id) {
    if (!confirm("Tem certeza que deseja excluir este produto?")) return;

    const body = new URLSearchParams({ id, _method: "DELETE", usuario: usuarioLogado });

    try {
        const res = await fetch(API_URL, {
            method: "POST", // ASP lê _method
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body,
        });

        const data = await res.json();
        if (data.success) {
            showAlert(data.message || "Produto excluído!");
            carregarProdutos();
        } else {
            showAlert(data.message, "danger");
        }
    } catch (err) {
        console.error(err);
        showAlert("Erro ao excluir produto", "danger");
    }
}

// Resetar modal ao fechar
document.getElementById("produtoModal").addEventListener("hidden.bs.modal", () => {
    document.getElementById("produtoForm").reset();
    document.getElementById("produtoId").value = "";
});

// Filtros e pesquisa
document.addEventListener("DOMContentLoaded", () => {
    const pesquisaNome = document.getElementById("pesquisaNome");
    const precoMin = document.getElementById("precoMin");
    const precoMax = document.getElementById("precoMax");
    const ordenarNome = document.getElementById("ordenarNome");
    const btnFiltrar = document.getElementById("btnFiltrar");

    const aplicarFiltros = () => {
        let linhas = Array.from(document.querySelectorAll("#produtosTable tbody tr"));

        const nomeFiltro = pesquisaNome.value.toLowerCase();
        const min = parseFloat(precoMin.value) || 0;
        const max = parseFloat(precoMax.value) || Infinity;
        const ordem = ordenarNome.value;

        // Filtra
        linhas.forEach(linha => {
            const nome = linha.cells[1].textContent.toLowerCase();
            const preco = parseFloat(linha.cells[2].textContent);
            linha.style.display = (nome.includes(nomeFiltro) && preco >= min && preco <= max) ? "" : "none";
        });

        // Ordena
        if (ordem) {
            linhas.sort((a, b) => {
                const nomeA = a.cells[1].textContent.toLowerCase();
                const nomeB = b.cells[1].textContent.toLowerCase();
                return ordem === "asc" ? nomeA.localeCompare(nomeB) : nomeB.localeCompare(nomeA);
            });

            linhas.forEach(linha => tbody.appendChild(linha));
        }
    };

    btnFiltrar.addEventListener("click", aplicarFiltros);
    pesquisaNome.addEventListener("input", aplicarFiltros);
});

// Logout
document.getElementById("btnSair").addEventListener("click", () => {
    sessionStorage.removeItem("token");
    sessionStorage.removeItem("userId");
    sessionStorage.removeItem("nome");
    window.location.href = "index.html";
});

// Inicializa
document.addEventListener("DOMContentLoaded", () => {
    carregarProdutos();
    document.getElementById("produtoForm").addEventListener("submit", salvarProduto);
});
