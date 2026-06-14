import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tienda_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:tienda_app/styles/app_colors.dart';
import 'package:tienda_app/styles/text_styles.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ProfileSection();
  }
}

class ProfileSection extends ConsumerWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: authState.when(
          data: (user) {
            if (user == null) {
              return _buildNoUserFallback();
            }
            return _buildProfileContent(user);
          },
          error: (error, stack) => _buildErrorFallback(error.toString()),
          loading: () => _buildLoadingState(),
        ),
      ),
    );
  }

  Widget _buildProfileContent(User user) {
    final String displayName = user.displayName ?? 'Comprador';
    final String displayEmail = user.email ?? 'Sin correo registrado';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 24),
          
          _buildHeaderSection(displayName, displayEmail),
          const SizedBox(height: 32),

          _buildSectionTitle('Mi Actividad'),
          _buildMenuContainer([
            _buildMenuRow(
              icon: Icons.local_shipping_outlined,
              title: 'Mis Pedidos',
              subtitle: 'Rastrea tus compras en curso',
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuRow(
              icon: Icons.favorite_border_rounded,
              title: 'Mis Favoritos',
              subtitle: 'Piezas guardadas del catálogo',
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuRow(
              icon: Icons.location_on_outlined,
              title: 'Direcciones de Envío',
              subtitle: 'Gestiona tus puntos de entrega',
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 24),

          _buildSectionTitle('Preferencias'),
          _buildMenuContainer([
            _buildMenuRow(
              icon: Icons.credit_card_rounded,
              title: 'Métodos de Pago',
              subtitle: 'Tarjetas guardadas de forma segura',
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuRow(
              icon: Icons.notifications_none_rounded,
              title: 'Notificaciones',
              subtitle: 'Alertas de stock y promociones',
              onTap: () {},
            ),
          ]),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(String name, String email) {
    final String singleInitial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'U';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Mini Contenedor del Avatar
          Container(
            padding: const EdgeInsets.all(2), 
            decoration: const BoxDecoration(
              color: AppColors.cardBackground,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primaryColor.withOpacity(0.08),
              child: Text(
                singleInitial,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor, // Azul principal
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: AppColors.cardBackground,
              padding: EdgeInsets.zero,
              minimumSize: const Size(36, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: AppColors.borderColor),
              ),
            ),
            icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.secondaryColor),
          ),
        ],
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 24, 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.neutralColor,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuContainer(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground, // Blanco sólido de tus productos
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: AppColors.secondaryColor),
            ),
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            const Icon(
              Icons.chevron_right_rounded, 
              size: 20, 
              color: AppColors.textHint
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(color: AppColors.dividerColor, height: 1, thickness: 1),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Cargando perfil...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorFallback(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          'Error de sincronización con la cuenta: $error',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.errorColor, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildNoUserFallback() {
    return const Center(
      child: Text(
        'Inicia sesión para visualizar tu perfil.',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
    );
  }
}