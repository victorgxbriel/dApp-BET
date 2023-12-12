document.addEventListener('DOMContentLoaded', async () => {
  // Verifica se o MetaMask está instalado
  if (window.ethereum) {
    // Cria uma instância do web3 usando o MetaMask
    window.web3 = new Web3(window.ethereum);

    try {
      // Solicita a permissão do usuário para acessar as contas
      await window.ethereum.enable();

      // Verifica se o usuário já está logado
      const accounts = await web3.eth.getAccounts();
      if (accounts.length > 0) {
        // Exibe a tela de carregamento
        showLoadingAnimation();

        // Adiciona um atraso de 2 segundos antes do redirecionamento
        setTimeout(() => {
          // Redireciona para a página após o login
          window.location.href = 'http://LOCALHOST/PROJETO_BLOCKCHAIN/casino';
        }, 2000);
      }

      // Adiciona um ouvinte de clique ao botão de login
      document.getElementById('loginButton').addEventListener('click', async () => {
        // Exibe a tela de carregamento
        showLoadingAnimation();

        // Solicita ao usuário para conectar sua conta MetaMask
        await window.ethereum.enable();

        // Adiciona um atraso de 2 segundos antes do redirecionamento
        setTimeout(() => {
          // Redireciona para a página após o login
          window.location.href = 'http://LOCALHOST/PROJETO_BLOCKCHAIN/casino';
        }, 7000);
      });
    } catch (error) {
      console.error(error);
    }
  } else {
    console.error('MetaMask não detectado. Por favor, instale o MetaMask para continuar.');
  }
});

function showLoadingAnimation() {
  const loadingOverlay = document.getElementById('loadingOverlay');
  loadingOverlay.style.display = 'flex'; // Exibe a tela de carregamento
}
