import 'package:flutter/material.dart';
import '../app_theme.dart'; // Importando nosso tema bonito

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor, // Fundo Azul Escuro
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Botão de Fechar (Para quem não quer comprar)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 2. Ícone de Coroa e Título
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium, size: 60, color: AppTheme.actionColor),
              ),
              const SizedBox(height: 20),
              
              const Text(
                "SEJA PRO",
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Desbloqueie todo o potencial",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),

              const SizedBox(height: 40),

              // 3. Lista de Benefícios
              _buildBenefit(Icons.ad_units_outlined, "Remover Anúncios", "Navegue sem interrupções"),
              _buildBenefit(Icons.speed, "Scanner Ultra-Rápido", "Processamento prioritário"),
              _buildBenefit(Icons.hd, "Qualidade HD", "Exportação em alta resolução"),

              const Spacer(),

              // 4. Preço e Botão de Compra
              const Text(
                "Apenas R\$ 9,90 / mês", // ✅ O jeito certo, // Preço fictício por enquanto
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.actionColor, // Laranja
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    // Aqui entra a lógica de compra real depois
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Processando compra... (Simulação)")),
                    );
                  },
                  child: const Text(
                    "ASSINAR AGORA",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              const Text(
                "Cancele a qualquer momento na Google Play",
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para criar as linhas de benefícios
  Widget _buildBenefit(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.actionColor, size: 30),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 14)),
            ],
          )
        ],
      ),
    );
  }
}