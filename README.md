# 🗡️ The Legend of Zelda: Ocarina of Time Remake — Pacote tudo em um

[![Twitter/X](https://img.shields.io/badge/X-@lordumelkor-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/lordumelkor)
[![Status](https://img.shields.io/badge/Status-Plug%20%26%20Play-blue?style=for-the-badge)](https://github.com/spiritkiller/The-Legend-of-Zelda-Ocarina-of-Time-Remake-AllinOne-)
[![FPS](https://img.shields.io/badge/FPS-120%20FPS%20(LSFG%202X)-orange?style=for-the-badge)](https://github.com/spiritkiller/The-Legend-of-Zelda-Ocarina-of-Time-Remake-AllinOne-)
[![VirusTotal](https://img.shields.io/badge/VirusTotal-Clean%20%2F%20Safe-brightgreen?style=for-the-badge&logo=virustotal&logoColor=white)](https://www.virustotal.com/gui/url/9fe68971ec83f32ed51590bdd212448d6bbaa45361189e4282342170ccba91ba)

Este pacote portátil **tudo em um** foi preparado para facilitar o uso de **The Legend of Zelda: Ocarina of Time Remake** no PC, com máxima qualidade visual, sem travamentos e com o dobro da taxa de quadros (**120 FPS**), graças à geração de quadros LSFG 2X do Lossless Scaling.

---

[Vídeo de gameplay](https://www.youtube.com/watch?v=sZ9ysGepE8M)

## 🛡️ Segurança e verificação no VirusTotal

Você pode consultar os relatórios do VirusTotal e os hashes SHA-256 publicados pelo autor abaixo para verificar os arquivos da versão.

| Arquivo | Hash SHA-256 | Relatório do VirusTotal |
| :--- | :--- | :--- |
| 📦 **Zelda-OoT-Remake-AllinOne-v1.0.zip** | `4717caa0a74dd7a9ae961b35f64e5177332a2b0562403308aefcb4d9f228cab2` | [Relatório do VirusTotal](https://www.virustotal.com/gui/url/9fe68971ec83f32ed51590bdd212448d6bbaa45361189e4282342170ccba91ba) |
| ⚡ **Oyunu_Baslat.bat (inicializador)** | `df03a7828ac7b760805a24ffe6079e2b042c2f9d22e7599c3dfbbe311455e18b` | [Relatório do VirusTotal](https://www.virustotal.com/gui/url/148883740dfc97bd9dd05d2012e2c0ac0f353432b72554fd3f72d9cda026409a) |

---

## 🌟 Principais recursos

- 🏎️ **Emulador atualizado para Fritchii v5.8.4.** O autor relata de 40 a mais de 80 FPS nativos em áreas pesadas como Castle Town e de 80 a mais de 120 FPS com Lossless Scaling LSFG 2X.
- 🧠 **Suporte a 12 GB de DRAM do Switch 2 e DLSS por jogo.** O layout de memória foi otimizado para o remake, com ajustes de qualidade e predefinições do DLSS por jogo.
- 💾 **Gerenciador de saves com backup automático.** Importa e exporta saves com um clique, sincroniza perfis e cria cópias de segurança antes de alterações.
- ⚡ **Cache v54 com mais de 30.000 shaders e suporte a receitas.** O cache elimina engasgos causados pela compilação durante o jogo. Inclui suporte a arquivos `.nx2recipe` e integração com `nx2-precompile`.
- 🚀 **Integração automática com o Lossless Scaling v3.2.2.** A geração de quadros LSFG 2.3 X2 foi ajustada para oferecer fluidez a 120 FPS, sem rastros na imagem (ghosting) e sem atraso de entrada.
- 🎨 **Imagem nítida com filtro bilinear.** A filtragem bilinear mantém a nitidez original e evita o desfoque e os artefatos associados ao FSR.
- 🖥️ **Tela cheia sem bordas.** A barra de menus e a barra de status do emulador ficam ocultas, com escala automática em tela cheia.
- 📦 **Portátil e pronto para usar.** Dispensa instalação e guarda os arquivos salvos e as configurações na própria pasta do pacote.

---

## 📥 Instalação e como jogar

1. Baixe este repositório pelo menu **Code → Download ZIP** ou com `git clone`. Você também pode baixar o pacote completo em um único ZIP na página de [versões](https://github.com/spiritkiller/The-Legend-of-Zelda-Ocarina-of-Time-Remake-AllinOne-/releases). Se baixar um ZIP, extraia o conteúdo em uma pasta.
2. Coloque seu arquivo de Ocarina of Time Remake (extensão `.nup`) na pasta **`ROM_BURAYA_KONACAK`**.
3. Na pasta principal, dê dois cliques em **`Start_Game.bat`** ou `Oyunu_Baslat.bat`.
4. **Na primeira execução**, o cache de 30.000 shaders será descompactado automaticamente e carregado no emulador em 5 a 10 segundos.
5. Três segundos após o início do jogo, o Lossless Scaling entra em ação, ajusta a janela para tela cheia sem bordas e dobra a taxa de quadros sem deixar rastros na imagem.

---

## ⚙️ Configurações de otimização

| Configuração | Valor | Descrição |
| :--- | :--- | :--- |
| **Backend gráfico do emulador** | Vulkan | Máxima eficiência e compatibilidade com o pipeline da GPU |
| **Filtro de escala** | Bilinear | Bordas nítidas e sem halos do FSR |
| **Nitidez do FSR** | 0 (desativada) | Evita artefatos de nitidez excessiva |
| **Tipo de escala do Lossless Scaling** | Off (desativado) | Geração de quadros sem alterar a imagem |
| **Geração de quadros** | LSFG 2 (X2) | Sem rastros no personagem Link ou em movimentos rápidos de câmera |
| **Latência máxima de quadros** | 1 | Menor latência de entrada possível |
| **API de captura** | DXGI | Captura de janela com latência muito baixa |
