import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tienda_app/common/image_assets/image_assets.dart';
import 'package:tienda_app/common/widgets/buttons/primary_button.dart';
import 'package:tienda_app/common/widgets/screens/loading_screen.dart';
import 'package:tienda_app/common/widgets/text_fields/primary_text_field.dart';
import 'package:tienda_app/features/home/presentation/screens/home_screen.dart';
import 'package:tienda_app/styles/app_colors.dart';
import 'package:tienda_app/styles/text_styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Buena práctica: liberar los controladores de la memoria al destruir la pantalla
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        // 1. Envolvemos con un SingleChildScrollView usando el truco de VS Code
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20,), // Espacio superior seguro
                SvgPicture.asset(
                  ImageAssets.store,
                  height: 80,
                  width: 80,
                ),
                Text(
                  'Mi Tienda - Registro',
                  style: AppTextStyles.textTitleStyle,
                ),
                const SizedBox(height: 24,),
                PrimaryTextField(
                  hintText: 'Ingresa tu correo electrónico',
                  labelText: 'Correo',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                PrimaryTextField(
                  hintText: 'Ingresa tu contraseña',
                  labelText: 'Contraseña', // Corregido typo "Contraeña"
                  keyboardType: TextInputType.text,
                  isPassword: true,
                  controller: passwordController,
                ),
                PrimaryTextField(
                  hintText: 'Confirma tu contraseña',
                  labelText: 'Confirmar Contraseña', // Corregido typo "Contraeña"
                  keyboardType: TextInputType.text,
                  isPassword: true,
                  controller: confirmPasswordController,
                ),
                const SizedBox(height: 24,),
                PrimaryButton(
                  onTap: () {
                    if (emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El correo no puede estar vacío')));
                      return;
                    }
                    if (passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La contraseña no puede estar vacía')));
                      return;
                    }
                    if (confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La confirmación de contraseña no puede estar vacía')));
                      return;
                    }
                    if (passwordController.text != confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Las contraseñas no coinciden')));
                      return;
                    }
                    registerUserWithEmailAndPassword();
                  },
                  text: 'REGISTRAR',
                ),
                
                // 2. Reemplazamos 'Spacer()' por una separación fija para evitar el error de RenderFlex
                const SizedBox(height: 40,),
                
                Text(
                  '¿Ya tienes una cuenta?',
                  style: AppTextStyles.textDescriptionStyle,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Regresa al LoginScreen de forma limpia
                  },
                  child: Text(
                    'INGRESAR',
                    style: AppTextStyles.textButtonStyle,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUserWithEmailAndPassword() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      
      // 3. MEJORA DE NAVEGACIÓN: Limpiamos la pila de pantallas para ir directamente al Home
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false, // Elimina el registro y el login de la pila
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        SnackBar snackBar = SnackBar(content: Text(e.message ?? 'Error al registrar el usuario'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}