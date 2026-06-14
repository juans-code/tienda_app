import 'package:flutter/material.dart';
import 'package:tienda_app/styles/app_colors.dart';
import 'package:tienda_app/styles/text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  // Animaciones escalonadas (Staggered) para un acabado premium
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // 1. El logo entra primero con un leve efecto de rebote
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // 2. El texto aparece después mediante un Fade
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.9, curve: Curves.easeIn),
      ),
    );

    // 3. El texto sube sutilmente mientras aparece (Slide)
    _textSlideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.9, curve: Curves.fastOutSlowIn),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Fondo con un degradado sutil y sofisticado
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundColor,
              AppColors.backgroundColor.withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Contenido Central: Identidad de Bazar Go
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LOGO CON ANIMACIÓN DE ESCALA
                    ScaleTransition(
                      scale: _logoScaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(26),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.15),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        // Icono moderno de bolsa/carrito, ideal para e-commerce ágil
                        child: const Icon(
                          Icons.local_mall_outlined,
                          size: 72,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // TEXTO Y ES LOGAN CON ANIMACIÓN ESCALONADA (FADE + SLIDE)
                    FadeTransition(
                      opacity: _textFadeAnimation,
                      child: SlideTransition(
                        position: _textSlideAnimation,
                        child: Column(
                          children: [
                            Text(
                              'BAZAR GO',
                              style: AppTextStyles.textTitleStyle.copyWith(
                                letterSpacing: 4,
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Variedad infinita a un click de distancia',
                              style: AppTextStyles.textDescriptionStyle.copyWith(
                                color: AppColors.neutralColor.withOpacity(0.6),
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido Inferior: Indicador lineal minimalista y versión
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            minHeight: 3,
                            backgroundColor: AppColors.neutralColor.withOpacity(0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'v1.0.0',
                        style: AppTextStyles.textDescriptionStyle.copyWith(
                          color: AppColors.neutralColor.withOpacity(0.4),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}